%This m file takes in the sample test vector, 
%that contains S streams of size 128 bytes 
%line by line. The function will then export 
%the location of 1s in every stream and write 
%them line by line in a location.txt file. 
%Meanwhile, it writes the hamming weigh of 
%every stream in a hamming_weight.txt file.
%
%written by morteza hosseini
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
inputdata = importdata('input_decimal.txt');

fileID_P = fopen('locations.txt','w');

S = 4; % number of streams of size 1024(=128*8)

for j=1:S
    outputlocations = zeros (1, 1024);
    hammingweight = 0;
    for line = 1:128
        line_fetched = de2bi (inputdata(line+(j-1)*128), 8, 'left-msb');
        for i = 1:8
            if (line_fetched(8-i+1) == 1) 
                hammingweight = hammingweight + 1;
                outputlocations(8*(line-1)+ i) = (i-1)+8*(line-1);
            end
        end
    end
    outputlocations = sort (outputlocations);
    valid_locations = outputlocations(1024-hammingweight+1:1024);
    fprintf(fileID_P,'%d\n',valid_locations);
end

fclose(fileID_P);
