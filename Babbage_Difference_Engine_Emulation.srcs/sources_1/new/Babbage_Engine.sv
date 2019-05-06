`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2019 12:42:51 PM
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


module Babbage_Engine#(parameter I_0 = -2, H_0 = 1, G_0 = 1, I_INC = 6)
    ( 
    input  logic clk,
    input  logic reset,
    output logic [31:0]out
    );
    
    //FSM
    typedef enum logic[4:0]{INIT = 5'b00001, CALC_1 = 5'b00010, CALC_2 = 5'b00100, CALC_3 = 5'b01000, DONE = 5'b10000}state_type;
       
    state_type curr_state, next_state;
       
    //Signal declarations
    logic[19:0] g, next_g;
    logic[19:0] h, next_h;
    logic[19:0] i, next_i;
    
    always_ff@(posedge clk, posedge reset) begin
        if(reset) begin
            curr_state = INIT;
        end
        else begin
            curr_state = next_state;
        end
    end
    
    always_ff@(posedge clk, posedge reset) begin
        if(reset) begin
            i = 0;
            h = 0;
            g = 0;
        end
        else begin
            i = next_i;
            h = next_h;
            g = next_g;
        end
    end
        
    always_comb begin
        next_state = curr_state;
        next_i = i;
        next_h = h;
        next_g = g;
        
        case(next_state) 
            INIT: begin: initialization_state
                next_i = I_0;
                next_h = H_0;
                next_g = G_0;
                next_state = CALC_1;  
            end
            
            CALC_1: begin: calculation_state_1
                next_i = i + I_INC;
                next_state = CALC_2;
            end
            
            CALC_2: begin: calculation_state_2
                next_h = h + i;
                next_state = CALC_3;            
            end
            
            CALC_3: begin: calculation_state_3
                next_g = g + h;
                next_state = CALC_1;
            end
        
            default: begin
                next_state = INIT;
            end
        endcase;
    end
    
    assign out = g;
endmodule
    
   
    