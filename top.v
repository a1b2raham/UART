module top #(
    parameter data_width = 8,
    parameter sys_clk = 10,
    parameter baud_rate = 2
) (
    input  [data_width-1:0] data_in,
    input                   clk,
    input                   rst_n,
    input                   en,
    output [data_width-1:0] data_out,
    output                  rx_done,
    output                  rx_busy,
    output                  frame_error,
    output                  tx_busy,
    output                  tx_done
);

  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)

  wire data_out_tx;
  // From uut of transmitter.v
  // End of automatics

  transmitter #(
      .data_width(data_width),
      .sys_clk(sys_clk),
      .baud_rate(baud_rate)

  ) uut (
      /*AUTOINST*/
      // Outputs
      .data_out(data_out_tx),
      .tx_done (tx_done),
      .tx_busy (tx_busy),
      // Inputs
      .clk     (clk),
      .rst_n   (rst_n),
      .data_in (data_in[data_width-1:0]),
      .en      (en)
  );


  reciver #(
      .data_width(data_width),
      .baud_rate(baud_rate),
      .sys_clk(sys_clk)
  ) uut1 (
      /*AUTOINST*/
      // Outputs
      .rx_done    (rx_done),
      .rx_busy    (rx_busy),
      .frame_error(frame_error),
      .data_out   (data_out[data_width-1:0]),
      // Inputs
      .clk        (clk),
      .rst_n      (rst_n),
      .in_sync    (data_out_tx)
  );








endmodule
