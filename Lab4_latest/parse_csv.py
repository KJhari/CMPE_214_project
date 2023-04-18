import argparse
import csv

parser = argparse.ArgumentParser(description='Read data from a CSV file')
parser.add_argument('--filename', help='Name of the CSV file to read')
parser.add_argument('--threshold', help='Max threshold')

args = parser.parse_args()

previous_array_size=0
previous_duration = 0

############################## Just print the csv as it
# with open(args.filename, 'r') as csvfile:
#     csvreader = csv.reader(csvfile)
#     for row in csvreader:
#         print(row)
############################## 

with open(args.filename, 'r') as csvfile:
    csvreader = csv.reader(csvfile)
    for row in csvreader:
        try:
            int(row[0])
        except ValueError:
            continue

        try:
            value = row[1].split("E+")
            if len(value) == 1:
                current_duration = int(value[0])
            else:
                current_duration = float(value[0]) * pow(10,int(value[1]))

            if (current_duration - previous_duration < int(args.threshold)):
                previous_duration =  current_duration
                previous_array_size = int(row[0])
            else:
                print(previous_array_size) 
                break   
            
        except:
            # printf(f"Ran into an exception parsing {row[1]}")
            break