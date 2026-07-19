module btn_deb #(
    parameter sys_clk   = 100_000_000,
    parameter wait_time = 20
) (
    input in_sync,
    input clk,
    input rst_n,
    output reg en = 1'b0
);
  localparam count = (sys_clk / 1000) * wait_time;


  reg  [$clog2(count)-1:0] counter = 0;
  wire [$clog2(count)-1:0] counter_wire;
  reg                      data_store;
  wire                     en_store;
  wire en_out, final_value;
  wire en_out_wire;

  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire data_in;  // From uut of sync.v
  // End of automatics

  sync uut (
      /*AUTOINST*/
      // Outputs
      .data_in   (data_in),
      // Inputs
      .clk   (clk),
      .rst_n   (rst_n),
      .in_sync   (in_sync)
  );
  // counter
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) counter <= 0;
    else counter <= counter_wire;
  end

  // initial value storing

  always @(posedge clk) begin
    if (en_store) data_store <= data_in;
  end

  // output register
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) en <= 0;
    else if (en_out) en <= en_out_wire;
  end



  assign counter_wire = (final_value) ? 0 : counter + 1;
  assign en_store = ~|counter;
  assign en_out = ~(data_in ^ data_store);
  assign final_value = (counter == count);
  assign en_out_wire = (final_value) ? data_in : 1'b0;



endmodule
