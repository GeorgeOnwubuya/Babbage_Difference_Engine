`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2019 04:21:20 PM
// Design Name: 
// Module Name: Babbage_Engine
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


module Babbage_Engine#(parameter H_0 = 1, I_1 = -1, J_2 = 14, K_3 = -36, K_INC = 24)
    ( 
    input  logic clk,
    input  logic reset,
    output logic [31:0]out
    );

    //FSM
    typedef enum logic[4:0]{INIT = 5'b00001, CALC_1 = 5'b00010, CALC_2 = 5'b00100, CALC_3 = 5'b01000, CALC_4 = 5'b10000}state_type;
       
    state_type curr_state, next_state;
    
    //Signal declarations
  	logic[31:0] h, next_h;
  	logic[31:0] i, next_i;
  	logic[31:0] j, next_j;
  	logic[31:0] k, next_k;
        
    always_ff@(posedge clk, posedge reset) begin
        if(reset) begin
            curr_state = INIT;
        end
        else begin
            curr_state = next_state;
        end
    end
    
    always_ff@(posedge clk, posedge reset) begin: register
        if(reset) begin
            h <= 20'b0;
            i <= 20'b0;
            j <= 20'b0; 
            k <= 20'b0;
        end
        else begin
            h <= next_h;
            i <= next_i;
            j <= next_j;
            k <= next_k;
        end
    end
    
    always_comb begin
        next_state = curr_state;
        next_h = h;
        next_i = i;
        next_j = j;
        next_k = k;
            
        case(next_state) 
            INIT: begin: initialization_state
                next_h = H_0;
                next_i = I_1;
                next_j = J_2;
                next_k = K_3;
                next_state = CALC_1;  
            end
            
            CALC_1: begin: calculation1
                next_k = k + K_INC;
                next_state = CALC_2;
            end
            
            CALC_2: begin: calculaion2
                next_j = j + k;
                next_state = CALC_3;
            end
            
            CALC_3: begin: calculation3
                next_i = i + j;
                next_state = CALC_4;
            end
            
            CALC_4: begin: calculation4   
                next_h = h + i;
                next_state = CALC_1;   
            end 
                                   
            default: begin
                next_state = INIT;
            end   
        endcase
    end        
    assign out = h;
endmodule
