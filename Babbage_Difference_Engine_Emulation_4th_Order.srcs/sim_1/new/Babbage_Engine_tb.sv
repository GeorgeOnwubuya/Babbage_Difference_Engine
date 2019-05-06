`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2019 08:07:11 PM
// Design Name: 
// Module Name: Babbage_Engine_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Babbage_Engine_tb();

    logic clk = 0;
    logic reset = 1;
    logic [31:0] out, file_out;
    integer file,success;
 
    Babbage_Engine dut(.*);
   
    always begin
        #5;
        clk = ~clk;
    end
    
    assert property(@(posedge (clk)) (out ==? file_out))
        else $error("The values do not match");
        
    initial begin
      	file = $fopen("Polynomial_Output_2.txt", "r");
      	repeat(2)@(posedge clk);
        	repeat(100) begin
              	repeat(4)@(posedge clk);
            	success = $fscanf(file, "%d\n", file_out);
            	$display(file_out);      
        	end
      	$fclose(file);
      	//$finish;
    end    
    
    initial begin
      	//$dumpfile("dump.vcd"); //for testing in the EDA environment
      	//$dumpvars;
        repeat(5)@(posedge clk);
        reset = 0;
    end
endmodule

