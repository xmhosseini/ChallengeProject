//////////////////////////////////////////////////////////////////////////////////
//
// top_tb.v
//
// This file is a test bench that generates the result from top.v (which is a 1-locater
// within a byte-stream.) The input bit-stream is given input_binary.bin which can be 
// generated manually or by a MATLAB random-vector generator (testvectorgenerator.m) 
// The results of this testbench are compared and validated against the MATLAB output
// simulation which are generated by outputgenerator.m file given an input_binary. 
// The size of the input streams should be set in parameter S, here, and in MATLAB files
//
// wrritten by: Morteza Hosseini
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`define clk_period 20

module top_tb
  #(// number of Episodes or Streams of 128x8 for input
    parameter S=100 
  )();


     reg   clk;
     reg   srst;
	   reg   start; // go signal that asserts every 129th cycle
     reg   [7:0] din; // data in (input)
     wire  [7:0] hw;  // hamming weight of every episode (=stream of input)
     wire  [9:0] locations; // locations of 1s that are instantly sent out one location at a clk  after the stream went it 
     wire  valid; // indicates if the outputs, hamming weight and locations are valid
     integer i, j, k;     
   
     reg [7:0] input_data [128*S-1:0]; //the testvectors are saved into a 2D array, and then fed to the input signal one entry at a time
     reg [9:0] locations_validation; // locations.txt which is generated by MATLAB for the locations of 1s is read into this register for comparison to that of HDL 
     reg [7:0] hw_validation ; // hamming_weights.txt which is generated by MATLAB for hamming weights is read into this register for comparison to that of HDL 
  
top DUT
       (
        .clk(clk) , //input
        .srst(srst) , //input
        .start(start) ,	//	input
        .din(din) ,//input
        .hw(hw),//output
        .locations(locations),//output
        .valid(valid),//output
        .overflow()// output, which is connected to Full signal of FIFO
      );
  
  // clock generation  
  initial clk = 1;
  always #(`clk_period/2) clk = ~clk;
  
  
 
// Stimuli is given to the din in spans of 129 clock cycle, depending of the number of 
// Episodes are streams. At cycle 129 signal start is asserted again to indicate the start of
// the new Episode
    
  initial 
  begin
       
      din = 0; 
      srst = 0;
      start = 1;
     
      #`clk_period;
      srst = 1;
      #`clk_period;
      srst = 0;
      #(`clk_period*3);// FIFO IP documentation of Xilinx states that 3 clock cycle is required for resetting FIFO
     
      #`clk_period;
      for (j = 0; j<=S-1;j = j+1) 
      begin  
        start = 1; 
        #`clk_period;
        start = 0;                 
        for (i = 0; i<=127; i = i+1) 
        begin
          din= input_data[i+128*j];
          #`clk_period;     
        end
      end
      din = 0;
      #(`clk_period*128); 
      $stop;     
      
  end
  
 
 
 
 
 // Validation
 
  integer reg_location_validation;
  integer reg_hw_validation;
 
  initial
  begin
    $readmemb("C:/Users/xmhos/Desktop/ChallengeProject/TestSamples/Automatic100/input_binary.bin",input_data);
    reg_location_validation = $fopen ("C:/Users/xmhos/Desktop/ChallengeProject/TestSamples/Automatic100/locations.txt", "r");
    reg_hw_validation = $fopen ("C:/Users/xmhos/Desktop/ChallengeProject/TestSamples/Automatic100/hamming_weights.txt", "r");
  end 
/*      
  initial 
  begin

    #`clk_period;
    for (k = 0 ; k<(S*129+30); k=k+1) 
    begin
      if ((valid == 1) && (DUT.clk_cycle_counter== 128))
        begin
          $display ("Hamming Weight generated by HDL is", hw);  
          $fscanf  (reg_hw_validation, "%d\n", hw_validation);
          $display ("Hamming Weight validated by MATLAB is", hw_validation); 
        end 

      if (valid == 1)
        begin
          $display ("Location generated by HDL is", locations);               
          $fscanf  (reg_location_validation, "%d\n", locations_validation);
          $display ("Location validated by MATLAB is", locations_validation); 
          if  (locations == locations_validation)
             $display ("OK");
          else
             $display ("ERROR. Display error specifications. i.e. the system state & at which clock cycle");
        end
      #`clk_period;  
    end
    $fclose(reg_location_validation);
    $fclose(reg_hw_validation);
   $stop; 
  end
*/
  
endmodule
