`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2025 00:18:59
// Design Name: 
// Module Name: baud_generator
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


module baud_generator(
    input reset,
    input [13:0] limit,
    input clk,
    output tick
    );
    reg [13:0] baud_counter;
    wire [13:0] next;
    
    always @(posedge clk,posedge reset)
    begin
    if(reset)
    baud_counter <= 0;
    else
    baud_counter <= next;
    end
    
    assign next = (baud_counter==limit)? 0 : baud_counter +1;
    assign tick = (baud_counter == 1);
endmodule

