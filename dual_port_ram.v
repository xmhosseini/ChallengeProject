`timescale 1ns / 1ps

module dual_port_ram (address_0, data_0, we_0, re_0, address_1, data_1, we_1, re_1); 

// inputs 
input [5:0] address_0 ; // port 0 address
input we_0 ; // port 0 write enable
input re_0 ; // port 0 read enable
input [5:0] address_1 ; // port 1 address
input we_1 ; // port 1 write enable
input re_1 ; // port 1 read enable

// inout two data ports 
inout [7:0] data_0 ; // port 0 inout data
inout [7:0] data_1 ; // port 1 inout data

// registers and memory allocations
reg [7:0] data_0_out ; 
reg [7:0] data_1_out ;
reg [7:0] memory [0:63];


// port 0, write phase
always @ (*)
begin 
  if (we_0==1) 
     memory[address_0] <= data_0;
  else if (we_1==1) 
     memory[address_1] <= data_1;
end

// port 0, read phase
always @ (*)
begin 
  if ((we_0==0) && (re_0==1)) 
    data_0_out <= memory[address_0]; 
   else 
    data_0_out <= 0; 
end 


// port 1, read phase
always @ (*)
begin 
  if ((we_1==0) && (re_1==1)) 
    data_1_out <= memory[address_1]; 
   else 
    data_1_out <= 0; 
end

// port 0, tri state output
assign data_0 = ((re_0==1) && (we_0==0)) ? data_0_out : 8'bz; 

// port 1, tri state output
assign data_1 = ((re_1==1) && (we_1==0)) ? data_1_out : 8'bz; 


endmodule 
