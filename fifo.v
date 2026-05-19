`timescale 1ns / 1ps

module fifo #(
    parameter depth = 8,
    parameter width = 32
) (
    input clk,
    input rst,
    input rd_en,
    input wr_en,

    input [width-1:0] write_data,
    output reg [width-1 : 0] read_data
);

  wire full, empty;

  reg [width-1:0] register[0:depth-1];


  reg [$clog2(depth) - 1 : 0] read_ptr, write_ptr;


  assign full  = (write_ptr + 1) == read_ptr;
  assign empty = write_ptr == read_ptr;

  always @(posedge clk or posedge rst) begin
    if (rst) read_ptr <= 0;
    else if (rd_en && ~empty) begin
      read_data <= register[read_ptr];
      read_ptr  <= read_ptr + 1;
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst) write_ptr <= 0;
    else if (wr_en && ~full) begin
      register[write_ptr] <= write_data;
      write_ptr <= write_ptr + 1;
    end
  end


endmodule

