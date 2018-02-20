`timescale 1ns / 1ps
module fifo648 (clk, srst, din, rd_en, wr_en, dout, empty, full);    
 
// inputs
input clk ; // clock
input srst ; // reset
input rd_en ; // read enable
input wr_en ; // write enable
input [7:0] din ;
output reg [7:0] dout ;
output full ;
output empty ;

// Wires and Registers
reg  [5:0] wr_pointer; // write pointer
reg  [5:0] rd_pointer; // read pointer
reg  [6:0] status_cnt; // status counter
wire [7:0] data_ram ; // from the dual port ram


//write pointer control
always @ (posedge clk)
begin 
  if (srst==1) 
    wr_pointer <= 0;
  else if (wr_en==1) 
    wr_pointer <= wr_pointer + 1;
end

// read pointer control
always @ (posedge clk )
begin 
  if (srst==1) 
    rd_pointer <= 0;
  else if (rd_en==1) 
    rd_pointer <= rd_pointer + 1;
end

// dout
always  @ (posedge clk)
begin 
  if (srst==1) 
    dout <= 0;
   else if (rd_en==1) 
    dout <= data_ram;
end

// status counter control
always @ (posedge clk)
begin 
  if (srst) 
    status_cnt <= 0;
   else if ((rd_en==1) && (wr_en==0) && (status_cnt != 0)) 
    status_cnt <= status_cnt - 1;
   else if ((wr_en==1) && (rd_en==0) && (status_cnt != 63)) 
    status_cnt <= status_cnt + 1;
end 

// full and empty signals to indicate the state of the FIFO
assign full = (status_cnt == 63);
assign empty = (status_cnt == 0);

   
dual_port_ram U4 (
.address_0 (wr_pointer) , // input 
.data_0    (din)    ,     // inout data_0 
.we_0      (wr_en)      , // write enable
.re_0      (1'b0)       , // output enable
.address_1 (rd_pointer) , // address_q input
.data_1    (data_ram)   , // data_1 bi-directional
.we_1      (1'b0)       , // Read enable
.re_1      (rd_en)        // output enable
);     

endmodule
