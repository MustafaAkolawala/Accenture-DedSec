from flask import Flask, jsonify,request,send_file
import holidays
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow import keras
from sklearn.preprocessing import RobustScaler, OneHotEncoder , LabelEncoder
from datetime import datetime, timedelta
from keras.models import Model
from keras.layers import Input, Dense, LSTM, Flatten, concatenate
from keras.optimizers import RMSprop
from keras.preprocessing.sequence import pad_sequences
from io import BytesIO
from flask_ngrok import run_with_ngrok
from pyngrok import ngrok



import warnings
warnings.filterwarnings('ignore')
app = Flask(__name__)
year_all = [2015, 2016, 2017, 2018, 2019, 2020, 2021]
indian_holidays = holidays.India()
forecast_date = datetime(2021, 12, 31) 
day_names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
month_names = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
season_mapping = {
        'Summer': 0,
        'Monsoon': 1,
        'Autumn': 2,
        'Winter': 3
    }
seasons = {
        'Summer': [3, 4, 5],
        'Monsoon': [6, 7, 8],
        'Autumn': [9, 10, 11],
        'Winter': [12, 1, 2],
    }
#model = None

def get_data(df):
    list_row = []
    date = []
    traffic = []
    indian_holidays = holidays.India()
    
    for i, row in df.iterrows():
        # 'DATE' column is already in datetime format, no need for strptime
        current_date = row['DATE']
        weekday = current_date.strftime('%A')
    
        is_holiday = 1 if current_date in indian_holidays else 0
        list_row.append([current_date, row['SALES'], is_holiday, weekday if weekday else ""])
    
        date.append(current_date)
        traffic.append(row['SALES'])
    
    new_df = pd.DataFrame(list_row, columns=['DATE', 'SALES', 'HOLIDAY', 'WEEKDAY'])
    
    return new_df, date, traffic, list_row

def date_to_enc(date_series):
    encoded_days = np.zeros(31).astype(int)
    encoded_mon = np.zeros(12).astype(int)
    encoded_years = np.zeros(7).astype(int)
    encoded_days[date_series.dt.day.astype(int) - 1] = 1
    encoded_mon[date_series.dt.month.astype(int) - 1] = 1
    encoded_days[date_series.dt.year.astype(int) - 2015] = 1
    return encoded_days, encoded_mon, encoded_years

def conversion(list_row):
    # Create an instance of OneHotEncoder
    encoder = OneHotEncoder(sparse=False)
    # Extract the day names from the 'list_row' argument
    day_names = [row[3] for row in list_row]
    # Fit the encoder on the day names
    encoder.fit(np.array(day_names).reshape(-1, 1))

    inp_day = []
    inp_mon = []
    inp_year = []
    inp_week = []
    inp_hol = []
    out = []

    for row in list_row:
        # Filter out date from list_row
        date = row[0]

        # The date was split into three values: date, month, and year.
        d1, d2, d3 = date_to_enc(pd.Series(date))
        inp_day.append(d1)
        inp_mon.append(d2)
        inp_year.append(d3)

        week2 = encoder.transform([[row[3]]]).flatten()
        inp_week.append(week2)

        inp_hol.append([row[2]])

        t1 = row[1]
        out.append(t1)

    return inp_day, inp_mon, inp_year, inp_week, inp_hol, out

def cur_season(seasons, month):
    encoded_sess = np.zeros(4).astype(int)
    #month = date.dt.month.astype(int)
    if month in seasons['Summer']:
        encoded_sess = [1,0,0,0]
    elif month in seasons['Monsoon']:
        encoded_sess = [0,1,0,0]
    elif month in seasons['Autumn']:
        encoded_sess = [0,0,1,0]
    elif month in seasons['Winter']:
        encoded_sess = [0,0,0,1]
    
    return encoded_sess

def other_inputs(seasons, list_row):
    inp7 = []
    inp_prev = []
    inp_sess = []
    count = 0  
    
    for row in list_row:
        ind = count
        count += 1
        d = row[0].strftime('%Y-%m-%d')
        d_split = d.split('-')
        
        if d_split[0] == str(year_all[0]):
            continue

        month = int(d_split[1])
        sess = cur_season(seasons, month)
        inp_sess.append(sess)
        t7 = []  
        t_prev = []  
        t_prev.append(list_row[ind - 365][1])  
        
        for j in range(0, 7):
            t7.append(list_row[ind - j - 1][1]) 
        
        inp7.append(t7)
        inp_prev.append(t_prev)
        
    return inp7, inp_prev, inp_sess

def encode_input(date):
    global day_names, seasons

    d1, d2, d3 = date_to_enc(pd.Series([date]))

    # Fit the day_encoder on all day indices before transforming
    day_index = day_names.index(date.strftime('%A'))
    day_encoder = OneHotEncoder(sparse=False, categories=[range(len(day_names))])
    day_encoder.fit(np.array(list(range(len(day_names)))).reshape(-1, 1))
    week2 = day_encoder.transform(np.array(day_index).reshape(-1, 1))

    is_holiday = 1 if date in indian_holidays else 0

    season = cur_season(seasons, date)
    sess = np.array([season])

    return d1, d2, d3, week2, np.array([is_holiday]), sess


def forecast_testing(date,df, list_row, traffic,model):
    maxj = max(traffic)  # determines the maximum sales value to normalize or return the data to its original form
    out = []
    count = -1
    ind = 0

    for i in list_row:
        count = count + 1
        if i[0] == date:  # identify the index of the data in the list
            ind = count

    t_7 = []
    t_prev = []
    t_prev.append(list_row[ind - 365][1])  # previous year data

    # for the first input, sales data of the last seven days will be taken from the training data
    for j in range(0, 7):
        t_7.append(list_row[ind - j - 365][1])

    result = []  # list to store the output and values

    for delta in range(90):  # Adjust the range to 90 days for 3 months
        i = forecast_date - timedelta(days=delta)
        d1, d2, d3, week2, h, sess = encode_input(i)  # using the input function to process input values into numpy arrays

        # Ensure that all input arrays have a shape of (1, ...) to represent one sample
        d1 = np.array(d1).reshape(1, -1)  # Reshape to (1, ...)
        d2 = np.array(d2).reshape(1, -1)  # Reshape to (1, ...)
        d3 = np.array(d3).reshape(1, -1)  # Reshape to (1, ...)
        week2 = week2.reshape(1, -1)  # Reshape to (1, ...)
        h = h.reshape(1, -1)  # Reshape to (1, ...)
        t_7 = np.array(t_7).reshape(1, -1)  # Reshape to (1, ...)
        t_prev = np.array(t_prev).reshape(1, -1)  # Reshape to (1, ...)
        sess = sess.reshape(1, -1)  # Reshape to (1, ...)

        # Predicting value for output
        y_out = model.predict([d1, d2, d3, week2, h])

        # Output and multiply the max value to the output value to increase its range from 0-1
        result.append(y_out[0][0] * maxj)

    return result

def generate_forecast_plot(df):

    df = pd.read_csv('D:\\accenture\\hsfg\\Accenture-DedSec-main\\Accenture-DedSec-main\\sale_sample.csv')

    df['SALES'] = df['SALES'].str.replace(r'[^0-9]', '', regex=True)
    df['SALES'] = pd.to_numeric(df['SALES'])
    df['DATE'] = pd.to_datetime(df['DATE'])

    scaler = RobustScaler()
    df['SALES'] = scaler.fit_transform(df[['SALES']])



    # Extract data for the 6 years used for training
    training_years = [2015, 2016, 2017, 2018, 2019, 2020]

    # Filter the DataFrame to get sales data for training years
    train_data = df[df['DATE'].dt.year.isin(training_years)]

    # Filter the DataFrame to get sales data for the 7th year (2021)
    actual_sales_7th_year = df[df['DATE'].dt.year == 2021]

    list_row = None
    
   
   
    

    model = None
    maxj = None

   
    df, date, traffic, list_row = get_data(df)

    inp_day, inp_mon, inp_year, inp_week, inp_hol, out = conversion(list_row)

    inp_day = np.array(inp_day)
    inp_mon = np.array(inp_mon)
    inp_year = np.array(inp_year)
    inp_week = np.array(inp_week)
    inp_hol = np.array(inp_hol)
    out = np.array(out)
    out = out.reshape(-1, 1)  
    inp7,inp_prev,inp_sess = other_inputs(seasons,list_row)
    inp7 = np.array(inp7)
    inp7= inp7.reshape(inp7.shape[0],inp7.shape[1],1)

    inp_prev = np.array(inp_prev)
    inp_sess = np.array(inp_sess)
    #inp_sess = inp_sess.reshape(-1, 1)

    input_day = Input(shape=(inp_day.shape[1],),name = 'input_day')
    input_mon = Input(shape=(inp_mon.shape[1],),name = 'input_mon')
    input_year = Input(shape=(inp_year.shape[1],),name = 'input_year')
    input_week = Input(shape=(inp_week.shape[1],),name = 'input_week')
    input_hol = Input(shape=(inp_hol.shape[1],),name = 'input_hol')
    x1 = Dense(5, activation='relu')(input_day)
    x2 = Dense(5, activation='relu')(input_mon)
    x3 = Dense(5, activation='relu')(input_year)
    x4 = Dense(5, activation='relu')(input_week)
    x5 = Dense(5, activation='relu')(input_hol)
    c = concatenate([x1,x2,x3,x4,x5])
    layer1 = Dense(64,activation='relu')(c)
    outputs = Dense(1, activation='sigmoid')(layer1)
    model = Model(inputs=[input_day,input_mon,input_year,input_week,input_hol,], outputs=outputs)
    model.summary()


    # Batch your dataset
    batch_size = 16

    model.compile(
        loss=['mean_squared_error'],
        optimizer='adam',
        metrics=['acc']
    )
    # Train your model using the dataset
    history = model.fit(
        [inp_day, inp_mon, inp_year, inp_week, inp_hol, ],
        out,
        batch_size,
        epochs=15,
        verbose=1,
        shuffle=False
    )
   
    forecasted_sales = forecast_testing(forecast_date,df, list_row, traffic,model)

    # Create a list of dates starting from 'forecast_date' and going back 90 days (3 months)
    date_range = [forecast_date - timedelta(days=i) for i in range(90)]

    plt.figure(figsize=(12, 6))
    plt.plot(date_range, forecasted_sales, label='Forecasted Sales (3 Months)', color='blue')
    plt.xlabel('Date')
    plt.ylabel('Sales')
    plt.title('Forecasted Sales for the Next 3 Months')
    plt.legend()
    plt.grid(True)
    img = BytesIO()
    plt.savefig(img, format='png')
    img.seek(0)
    return img

ngrok.set_auth_token("2VNVOxwngwswLJP3UgPQsaNoHh1_6XPgtp14E6X99WRwaoWZG")

run_with_ngrok(app)
@app.route('/forecast-plot', methods=['POST'])
def get_forecast_plot():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part in the request'}), 400

    file = request.files['file']
    print(file)
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400

    df = pd.read_csv(file)
    img = generate_forecast_plot(df)  # Pass the DataFrame to the function

    return send_file(img, mimetype='image/png')

if __name__ == '__main__':
    app.run()





