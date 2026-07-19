module baud #(
    parameter sys_clk   = 100,
    parameter baud_rate = 10
) (
    input  clk,
    input  rst_n,
    input  tx_busy,
    output baud_tick
);

  localparam count = sys_clk / baud_rate;

  wire [$clog2(count) - 1:0] count_wire;
  reg  [$clog2(count) - 1:0] count_reg = 0;


  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) count_reg <= 0;
    else count_reg <= count_wire;
  end

  assign baud_tick  = (count_reg == count - 1);
  assign count_wire = (baud_tick || ~(tx_busy)) ? 0 : count_reg + 1;


endmodule
