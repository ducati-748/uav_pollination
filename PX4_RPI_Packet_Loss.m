% This program will pull seq# and timestamps from excel files
% to determine the packet loss between the PX4 and RPI (if any)
% This program runs the first 999 pings of the data set, and will 
% also calculate latency.
% Last Edited: March 2021

%Pull coordinates into variables
format long
seq = readtable('PX4_RPi_seq_data.xlsx');
time = readtable('PX4_RPi_time_data.xlsx');
seq_array = table2array(seq);
time_array = table2array(time);

lost_packet_counter = 0;
n = 0;
row = 1;
while n < 1000          %Determines the amount of data to be evaluated
    if seq_array(row,1) == n
        %do nothing
    else
        fprintf("Busted!")
        disp(n)
        lost_packet_counter = lost_packet_counter + 1;
    end
    n = n + 1;
    row = row + 1;
end
%disp(n)
%disp(lost_packet_counter)

%Latency test
latency_sum = sum(time_array);
[col, row] = size(time_array);
latency_avg = latency_sum / col; 

%Latency Plot
scatter(seq_array,time_array,15,'.')
title("RPi and Pixhawk GPIO Packet Loss")