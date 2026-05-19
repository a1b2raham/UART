
module transmitter #(
    parameter data_width = 8,
    parameter sys_clk = 100,
    parameter baud_rate = 10
) (
    input clk,
    input rst_n,
    input [data_width-1:0] data_in,
    input en,

    output data_out,
    output tx_done,
    output tx_busy

);
  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire baud_tick;  // From baud1 of baud.v
  // End of automatics


  tx #(
      .data_width(data_width)
  ) tx1 (
      /*AUTOINST*/
      // Outputs
      .data_out (data_out),
      .tx_done  (tx_done),
      .tx_busy  (tx_busy),
      // Inputs
      .en       (en),
      .clk      (clk),
      .rst_n    (rst_n),
      .baud_tick(baud_tick),
      .data_in  (data_in[data_width-1:0])
  );
  baud #(
      .sys_clk  (sys_clk),
      .baud_rate(baud_rate)
  ) baud1 (
      /*AUTOINST*/
      // Outputs
      .baud_tick(baud_tick),
      // Inputs
      .clk      (clk),
      .rst_n    (rst_n)
  );

endmodule
