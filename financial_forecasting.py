import pandas as pd					 						 
import numpy as np					 
import matplotlib.pyplot as plt		 
import tensorflow as tf				 
from tensorflow import keras	
from datetime import datetime , timedelta
	 
'''
def get_data(csv_file_path):
    list_row = []  
    date = []      
    traffic = []   

    try:
        with open(csv_file_path, 'r', newline='',  encoding= 'ISO-8859-1') as csvfile:
            columns = ['SALES','ORDERDATE']
            csvreader = pd.read_csv(csvfile, usecols = columns )

            date = csvreader['ORDERDATE'].tolist()
            traffic = csvreader['SALES'].tolist()
            list_row = csvreader.values.tolist()

    except FileNotFoundError:
        print(f"File not found: {csv_file_path}")
    
    return list_row, date, traffic

list_row,date,traffic = get_data('sales_data_sample.csv')
'''


# Load your CSV file into a DataFrame (assuming you have already removed the time component)
df = pd.read_csv('sale_sample.csv')

# Define the initial sales value for the first year
initial_sales = 1000

# Define the annual growth rate (percentage increase)
annual_growth_rate = 0.1  # 10% annual growth rate

# Define parameters for random fluctuations
fluctuation_mean = 0  # Mean of fluctuations (zero for no net change)
fluctuation_std = 50  # Standard deviation of fluctuations

# Initialize a variable to keep track of the current year
current_year = None

# Initialize a variable to keep track of current sales
current_sales = initial_sales

# Create an array to store sales data
sales_data = []

df['DATE'] = pd.to_datetime(df['DATE'])
# Iterate through the DataFrame to calculate sales data based on the pattern
for index, row in df.iterrows():
    # Extract the year from the date (assuming 'DATEORDER' is in datetime format)
    year = row['DATE'].year

    # Check if a new year has started
    if year != current_year:
        current_year = year
        current_sales = initial_sales  # Reset sales at the beginning of the year

    # Calculate the annual growth
    annual_growth = current_sales * annual_growth_rate

    # Add random fluctuations
    fluctuation = np.random.normal(fluctuation_mean, fluctuation_std)
    
    increase_sales = np.random.choice([True, False])

    # Update sales with annual growth and fluctuations
    if increase_sales:
        current_sales += annual_growth + fluctuation
    else:
        current_sales -= annual_growth + fluctuation

    
    # Append the calculated sales value to the list
    sales_data.append(current_sales)

# Add the sales data as a new column in the DataFrame
df['SALES'] = sales_data

# Save the updated DataFrame back to the CSV file (overwrite the existing file)
df.to_csv('sale_sample.csv', index=False)
