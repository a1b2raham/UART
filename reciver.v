module reciver #(
    parameter data_width = 8,
    parameter baud_rate = 9600,
    parameter sys_clk = 100_000_000
) (
    input clk,
    input rst_not,
    input in_sync,
    output rx_done,
    output rx_busy,
    output frame_error,
    output [data_width-1:0] data_out
);
  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire baud_tick;  // From uut1 of baud_rx.v
  wire data_in;
  wire rst_n;
  // From uut2 of sync.v
  // End of automatics

  baud_rx #(
      .sys_clk  (sys_clk),
      .baud_rate(baud_rate * 16)
  ) uut1 (
      /*AUTOINST*/
      // Outputs
      .baud_tick(baud_tick),
      // Inputs
      .clk      (clk),
      .rst_n    (rst_n)
  );



  sync uut2 (
      /*AUTOINST*/
      // Outputs
      .data_in   (data_in),
      // Inputs
      .clk   (clk),
      .rst_n   (rst_n),
      .in_sync   (in_sync)
  );



  rx #(
      .data_width(data_width)
  ) uut3 (
      /*AUTOINST*/
      // Outputs
      .rx_done    (rx_done),
      .rx_busy    (rx_busy),
      .frame_error(frame_error),
      .data_out   (data_out[data_width-1:0]),
      // Inputs
      .clk        (clk),
      .rst_n      (rst_n),
      .baud_tick  (baud_tick),
      .data_in    (data_in)
  );


  assign rst_n = ~(rst_not);



endmodule
