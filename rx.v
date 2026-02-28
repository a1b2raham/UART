`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2025 22:41:16
// Design Name: 
// Module Name: rx
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


module rx(
    
    input buffer,
    input clk,
    input reset,
    output reg[7:0] out,
    output [1:0] st,
    output data_ready
    );
    reg [4:0] n;
    reg [3:0] bit;
    reg [7:0] out_reg;
    wire tick;
    baud_generator bod(
    .reset(reset),
    .clk(clk),
    .limit(650),
    .tick(tick)
    );
    reg [1:0] state;
    localparam idle = 2'b00;
    localparam start = 2'b01;
    localparam rec = 2'b10;
    localparam stop = 2'b11;
    
    
    
    always @(posedge tick, posedge reset)
    begin
    if(reset)
    begin
    n <= 0;
    bit <= 0;
    out_reg <= 0;
    
    state <= idle;
    end
    else
    begin
    
    case(state)
    idle:begin
    bit <= 0;
    n <= 0;
    out_reg <= 0;
    if(~buffer)
    state <= start;
    end
    
    start:begin
    out <= 0;
    if(~buffer)
    begin
    n = n+1;// same cycle execution both n++ and if
    if(n==7)
    begin
    state <= rec;
    n <= 0;
    end
    end 
    end
    
    rec:begin
    if(n==15)
    begin
    out_reg <= {buffer,out_reg [7:1]};//shift right
    bit <= bit + 1;
    n <= 0;
    end
    else
    begin
    n <= n + 1;
    end
    if(bit >7)
    begin
    state <= stop;
    end
    end
    
    stop:begin
    if(buffer)
    begin
    if(n > 2)
    begin
    out <= out_reg;
    state <= idle;
    end 
    else 
    n <= n+1;
    end
    end
    
    endcase
    end
    
    end
    assign data_ready = (out == 0)? 0:1;
    assign st = state;
endmodule
