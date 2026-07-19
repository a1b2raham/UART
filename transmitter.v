
module transmitter #(
    parameter data_width = 8,
    parameter sys_clk = 100_000_000,
    parameter baud_rate = 9600,
    parameter wait_time = 20
) (
    input clk,
    input btn_rst,
    input [data_width-1:0] data_in,
    input in_sync,

    output data_out,
    output tx_done,
    output tx_busy

);
  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire baud_tick;  // From baud1 of baud.v
  wire en;  // From btn of btn_deb.v
  // End of automatics
  wire rst_n;
  assign rst_n = ~btn_rst;

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
      .rst_n    (rst_n),
      .tx_busy  (tx_busy)
  );


  btn_deb #(
      .wait_time(wait_time),
      .sys_clk  (sys_clk)
  ) btn (
      /*AUTOINST*/
      // Outputs
      .en     (en),
      // Inputs
      .in_sync(in_sync),
      .clk    (clk),
      .rst_n  (rst_n)
  );


endmodule
