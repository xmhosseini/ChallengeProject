//////////////////////////////////////////////////////////////////////////////////
//
// Test bench for weight_locator
// written by morteza hosseini
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`define clk_period 20

module weight_locator_tb();

reg  [7:0] R;
wire [3:0] PC;
wire [2:0] L0;
wire [2:0] L1;
wire [2:0] L2;
wire [2:0] L3;
wire [2:0] L4;
wire [2:0] L5;
wire [2:0] L6;
wire [2:0] L7;

reg clk;
integer i;

weight_locator weight_locator_U2 (.R(R), .PC(PC), .L0(L0), .L1(L1), .L2(L2), .L3(L3), .L4(L4), .L5(L5), .L6(L6), .L7(L7));

initial clk = 1;
always #(`clk_period/2) clk = ~clk;

initial begin
    #`clk_period
	  for (i= 0; i<=31;i=i+1) begin
		R = i; 
		#`clk_period;   
	  end
end


endmodule
