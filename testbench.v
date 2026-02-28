`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2025 00:21:49
// Design Name: 
// Module Name: testbench
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


module testbench;

reg clk,reset;
reg [7:0] data;
wire [7:0] out;
wire buffer,tick,data_ready;
wire [1:0] state;
reg ready;
tx transmitter(
.data(data),
.reset(reset),
.ready(ready),
.clk(clk),
.buffer(buffer)
);
baud_generator bod(
.reset(reset),
.limit(650),
.clk(clk),
.tick(tick)
);
rx reciver(
.buffer(buffer),
.clk(clk),
.reset(reset),
.out(out),
.data_ready(data_ready)

);

initial
begin
ready = 1;
data=157;
clk = 0;
#1.2e6
ready =0;
end

initial
begin
#27e5
$finish;
end

initial
begin
reset=0;
#2
reset=1;
#2
reset=0;



end
always
begin
#5
clk =~clk;
end

    

endmodule
