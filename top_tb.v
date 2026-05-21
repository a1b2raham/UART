`timescale 1ns / 1ps

module top_tb;

  localparam data_width = 8;
  localparam sys_clk = 160;
  localparam baud_rate = 2;



  /*AUTOREGINPUT*/
  // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
  reg clk;  // To uut of top.v
  reg [data_width-1:0] data_in;  // To uut of top.v
  reg en;  // To uut of top.v
  reg rst_n;  // To uut of top.v
  // End of automatics
  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire [data_width-1:0] data_out;  // From uut of top.v
  wire frame_error;  // From uut of top.v
  wire rx_busy;  // From uut of top.v
  wire rx_done;  // From uut of top.v
  wire tx_busy;  // From uut of top.v
  wire tx_done;  // From uut of top.v
  // End of automatics

  top #(
      .data_width(data_width),
      .baud_rate(baud_rate),
      .sys_clk(sys_clk)
  ) uut (
      /*AUTOINST*/
      // Outputs
      .data_out   (data_out[data_width-1:0]),
      .rx_done    (rx_done),
      .rx_busy    (rx_busy),
      .frame_error(frame_error),
      .tx_busy    (tx_busy),
      .tx_done    (tx_done),
      // Inputs
      .data_in    (data_in[data_width-1:0]),
      .clk        (clk),
      .rst_n      (rst_n),
      .en         (en)
  );

  // clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars(0, top_tb);

    rst_n = 1;
    #2 rst_n = 0;
    #2 rst_n = 1;
    $monitor("data_out = %d",data_out);
    data_in = 8'd64;
    #1 en = 1;
    @(posedge clk);
    en = 0;
    wait(tx_done);
    data_in = 8'd72;
    #1 en = 1;
    @(posedge clk);
    en =0;
    wait(rx_done);
    #20;
    
    

    $finish;


  end


endmodule
