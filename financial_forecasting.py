import pandas as pd					 						 
import numpy as np					 
import matplotlib.pyplot as plt		 
import tensorflow as tf				 
from tensorflow import keras	
from datetime import datetime	 

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

