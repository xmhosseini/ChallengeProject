%This file generates S streams of 128 byte numbers line by line 
%in two binary and decimal formats. The generation is such that 
%there are on average thirty-one 1s insides a stream (the 
%distribution follows a Guassian function) then those streams 
%that have more than thirty-one 1s are discarded. The parameter S 
%should be determined for each examination. After running this m 
%file, two file input_decimal.txt and input_binary.bin are generated
%
%written by morteza hosseini
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all;
S = 4; % number of streams of size 128 bytes to be generated

fileID_D = fopen('input_decimal.txt','w');
fileID_B = fopen('input_binary.bin','w');
fileID_H = fopen('hamming_weights.txt','w');

inputdata     = zeros (1, 128);
inputdata_bin = zeros (1, 128);
hammingweights = 0;

for i=1:S    
    samplevector = max(0, sign (-1.862+randn(1,1024)));
    while (sum(samplevector)>31)
        samplevector = max(0, sign (-1.862+randn(1,1024)));
    end
    for j = 1:128
        inputdata(j) = bi2de (samplevector (8*(j-1)+1:8*j), 'left-msb');
        array_bin = samplevector (8*(j-1)+1:8*j);
		% a naive way of converting a decimal into a binary format later to be saved in the second output file
        inputdata_bin(j) = array_bin(8)+10*array_bin(7)+100*array_bin(6)+1000*array_bin(5)+10000*array_bin(4)+100000*array_bin(3)+1000000*array_bin(2)+10000000*array_bin(1);
    end
    hammingweights = sum(samplevector);  
    fprintf(fileID_D,'%d\n' ,inputdata);
    fprintf(fileID_B,'%8d\n',inputdata_bin);
    fprintf(fileID_H,'%d\n' ,hammingweights);
end

% test vectors,  decimal, binary and hamming_weight
    fclose(fileID_D);
    fclose(fileID_B);    
    fclose(fileID_H);
    fprintf ('Test vector files generated inside the Path directory.\nNow please run weightdetector.m\n');

