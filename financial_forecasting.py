import pandas as pd					 						 
import numpy as np					 
import matplotlib.pyplot as plt		 
import tensorflow as tf				 
from tensorflow import keras	
from sklearn.preprocessing import RobustScaler, OneHotEncoder
from datetime import datetime, timedelta
import holidays

df = pd.read_csv('sale_sample.csv')

df['SALES'] = df['SALES'].str.replace(r'[^0-9]', '', regex=True)
df['SALES'] = pd.to_numeric(df['SALES'])
scaler = RobustScaler()
scaled_sales = scaler.fit_transform(df[['SALES']])
df['SALES'] = scaled_sales


seasons = {
    'Summer': range(4, 7),      
    'Monsoon': range(7, 10),    
    'Winter': [11, 12, 1],     
}

def get_data(df):
    list_row = []
    date = []
    traffic = []

    # Define the country for which you want to check holidays (e.g., 'US' for United States)
    indian_holidays = holidays.India()

    for index, row in df.iterrows():
        # Convert the date column to datetime format
        current_date = datetime.strptime(row['DATE'], '%Y-%m-%d')

        # Check if the current date is a holiday
        is_holiday = 1 if current_date in indian_holidays else 0

        list_row.append([current_date, row['SALES'], is_holiday])
        date.append(current_date)
        traffic.append(row['SALES'])
        
    date_to_weekday = {}
    for date_str in date:
        weekday = current_date.strftime('%A')
        date_to_weekday[date_str] = weekday

    # Append weekdays to the list_row based on the date column
    for i, row in enumerate(list_row):
        order_date = row[0]
        weekday = date_to_weekday.get(order_date)
        if weekday:
            row.append(weekday)
        else:
            row.append("") 
    new_df = pd.DataFrame(list_row, columns=['DATE', 'SALES', 'HOLIDAY', 'WEEKDAY'])
    
    return new_df, date, traffic , list_row

def date_to_enc(date_series):
    day_names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    month_names = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    
    # Encode days, months, and years
    encoded_days = pd.get_dummies(date_series.dt.day_name())
    encoded_months = pd.get_dummies(date_series.dt.month_name())
    encoded_years = pd.get_dummies(date_series.dt.year.astype(str))
    
    return encoded_days, encoded_months, encoded_years

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
        inp_day.append(d1.values[0])
        inp_mon.append(d2.values[0])
        inp_year.append(d3.values[0])

        week2 = encoder.transform([[row[3]]]).flatten()
        inp_week.append(week2)

        inp_hol.append([row[2]])

        t1 = row[1]
        out.append(t1)

    return inp_day, inp_mon, inp_year, inp_week, inp_hol, out

df , date , traffic , list_row = get_data(df)
inp_day,inp_mon,inp_year,inp_week,inp_hol,out = conversion(list_row)

inp_day = np.array(inp_day)
inp_mon = np.array(inp_mon)
inp_year = np.array(inp_year)
inp_week = np.array(inp_week)
inp_hol = np.array(inp_hol)

def cur_season(seasons, date):

    month = int(date.split('-')[1])
    for season, month_range in seasons.items():
        if month in month_range:
            return season

    return 'Unknown Season'

def year_all():
  
    return [2015, 2016, 2017, 2018, 2019, 2020, 2021]  

def other_inputs(season, list_row):
    inp7 = []
    inp_prev = []
    inp_sess = []
    count = 0  
    for row in list_row:
        ind = count
        count += 1
        d = row[0]  
        d = row[0].strftime('%Y-%m-%d')
        d_split = d.split('-')
        if d_split[0] == str(year_all()[0]):
            continue
        sess = cur_season(season, d)  
        inp_sess.append(sess)  
        t7 = []  
        t_prev = []  
        t_prev.append(list_row[ind - 365][1])  
        for j in range(0, 7):
            t7.append(list_row[ind - j - 1][1]) 
        inp7.append(t7)
        inp_prev.append(t_prev)

    return inp7, inp_prev, inp_sess

inp7,inp_prev,inp_sess = other_inputs(seasons,list_row)
inp7 = np.array(inp7)
inp7= inp7.reshape(inp7.shape[0],inp7.shape[1],1)
inp_prev = np.array(inp_prev)
inp_sess = np.array(inp_sess)

print(inp7)