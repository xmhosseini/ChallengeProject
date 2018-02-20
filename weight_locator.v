// This is a purely combinational module to export the location 
// of 1s, if any, in a data byte, on 8 3-bit buses. Meanwhile 
// it instantly exports the hamming weight, A.K.A the population 
// count of the input on the PC output
//
//    An Example to illustrate how the weight_locator works
//
//    |''''''''''''''''''|
//    |                PC|--5
// 1--|                L0|--0
// 1--|                L1|--1
// 0--|                L2|--4
// 0--|                L3|--6
// 1--|                L4|--7
// 0--|                L5|--0
// 1--|                L6|--0
// 1--|                L7|--0  
//    |..................|--0
//
// Note that in the above circuit PC=5 distinguishes 
// L0=0 as a 1-indicator from L5=0 as a non-1-indicator	 
//
// written by Morteza Hosseini
//////////////////////////////////////////////////

`timescale 1ns / 1ps

module weight_locator (R, PC, L0, L1, L2, L3, L4, L5, L6, L7);

input [7:0] R;
output reg [3:0] PC;
output reg [2:0] L0;
output reg [2:0] L1;
output reg [2:0] L2;
output reg [2:0] L3;
output reg [2:0] L4;
output reg [2:0] L5;
output reg [2:0] L6;
output reg [2:0] L7;


always @(*)
PC = R[0]+R[1]+R[2]+R[3]+R[4]+R[5]+R[6]+R[7];


always @(*)
begin

{L0, L1, L2, L3, L4, L5, L6, L7} = 0;
if (R[0]==1) L0 = 0;
if (R[1]*(R[0]==0)==1) L0 =1;
if (R[2]*(R[1]+R[0]==0)==1) L0 =2;
if (R[3]*(R[2]+R[1]+R[0]==0)==1) L0 =3;
if (R[4]*(R[3]+R[2]+R[1]+R[0]==0)==1) L0 =4;
if (R[5]*(R[4]+R[3]+R[2]+R[1]+R[0]==0)==1) L0 =5;
if (R[6]*(R[5]+R[4]+R[3]+R[2]+R[1]+R[0]==0)==1) L0 =6;
if (R[7]*(R[6]+R[5]+R[4]+R[3]+R[2]+R[1]+R[0]==0)==1) L0 =7;

if (R[1]* R[0]==1) L1 = 1;
if (R[2]*(R[1]+R[0])==1) L1 = 2;
if (R[3]*(R[2]+R[1]+R[0])==1) L1 = 3;
if (R[4]*(R[3]+R[2]+R[1]+R[0])==1) L1 = 4;
if (R[5]*(R[4]+R[3]+R[2]+R[1]+R[0])==1) L1 = 5;
if (R[6]*(R[5]+R[4]+R[3]+R[2]+R[1]+R[0])==1) L1 = 6;
if (R[7]*(R[6]+R[5]+R[4]+R[3]+R[2]+R[1]+R[0])==1) L1 = 7;

if (R[2]*(R[1]+R[0])==2) L2 = 2;
if (R[3]*(R[2]+R[1]+R[0])==2) L2 = 3;
if (R[4]*(R[3]+R[2]+R[1]+R[0])==2) L2 = 4;
if (R[5]*(R[4]+R[3]+R[2]+R[1]+R[0])==2) L2 = 5;
if (R[6]*(R[5]+R[4]+R[3]+R[2]+R[1]+R[0])==2) L2 = 6;
if (R[7]*(R[6]+R[5]+R[4]+R[3]+R[2]+R[1]+R[0])==2) L2 = 7;

if (R[3]*(R[2]+R[1]+R[0])==3) L3 = 3;
if (R[4]*(R[3]+R[2]+R[1]+R[0])==3) L3 = 4;
if (R[5]*(R[4]+R[3]+R[2]+R[1]+R[0])==3) L3 = 5;
if (R[6]*(R[5]+R[4]+R[3]+R[2]+R[1]+R[0])==3) L3 = 6;
if (R[7]*(R[6]+R[5]+R[4]+R[3]+R[2]+R[1]+R[0])==3) L3 = 7;

if (R[4]*(R[3]+R[2]+R[1]+R[0])==4) L4 = 4;
if (R[5]*(R[4]+R[3]+R[2]+R[1]+R[0])==4) L4 = 5;
if (R[6]*(R[5]+R[4]+R[3]+R[2]+R[1]+R[0])==4) L4 = 6;
if (R[7]*(R[6]+R[5]+R[4]+R[3]+R[2]+R[1]+R[0])==4) L4 = 7;

if (R[5]*(R[4]+R[3]+R[2]+R[1]+R[0])==5) L5 = 5;
if (R[6]*(R[5]+R[4]+R[3]+R[2]+R[1]+R[0])==5) L5 = 6;
if (R[7]*(R[6]+R[5]+R[4]+R[3]+R[2]+R[1]+R[0])==5) L5 = 7;

if (R[6]*(R[5]+R[4]+R[3]+R[2]+R[1]+R[0])==6) L6 = 6;
if (R[7]*(R[6]+R[5]+R[4]+R[3]+R[2]+R[1]+R[0])==6) L6 = 7;

if (R[7]*(R[6]+R[5]+R[4]+R[3]+R[2]+R[1]+R[0])==7) L7 = 7;

end

endmodule