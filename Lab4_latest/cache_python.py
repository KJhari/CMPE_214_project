#!/usr/bin/python
import pandas as pd
import numpy as np

df = pd.read_excel('L1_Cache_Size_Calculation.xls', sheet_name='Sheet1', usecols='A:B')

time_diff = df.iloc[:,1].diff().dropna()
threshold = 1000000 * time_diff.std()
deviation_above_threshold = np.abs(time_diff) > threshold
first_large_deviation_index = np.where(deviation_above_threshold)[0][0]
first_large_deviation_rows = df.iloc[first_large_deviation_index:first_large_deviation_index+2,:]


first_large_deviation = np.abs(time_diff)[deviation_above_threshold][0]

print("First large deviation rows:")
print(first_large_deviation_rows)