`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2025 00:57:22
// Design Name: 
// Module Name: tx
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


module tx(
    input [7:0] data,
    input clk,
    input reset,
    input ready,
    output buffer,
    output count
    );
    
    reg [1:0] state;
    reg out_reg;
    reg [3:0] num;
    reg [7:0] temp;
    
    localparam idle = 2'b00;
    localparam start =2'b01;
    localparam trans = 2'b11;
    localparam stop = 2'b10;
    
    baud_generator tick (.reset(reset),.limit(10415),.clk(clk),.tick(clock));
    always @(posedge clk, posedge reset)
    begin
        if(reset)
            begin
            
            state <= idle;
            num <= 0;
            out_reg <= 1;  
            end
        else
        begin
        if(clock)
        
        begin
          case(state)
             idle:begin
                out_reg <= 1;
                if(ready)
                    begin
                    state <= start;
                    temp<= data;
                    num <= 0; 
                    end
             end
             start:begin
                out_reg <= 1'b0;
                state <= trans;
             end
             
             trans:begin
                if(num<8)
                    begin
                    out_reg <= temp[0];
                    temp <= {1'b0,temp[7:1]};
                    num <= num +1;
                    end
                else
                    begin
                    state <= stop;
                    out_reg <= 1;
                    end
                 end
             stop:begin
                out_reg <= 1;
                state <= idle;
             end
             default:
             begin
             state <= idle;
             end
             
             endcase
         end 
         end   
    end
    assign buffer = out_reg;
    
    assign count =(clock > 0)? 1:0;
  
endmodule












