module sync (
    input  clk,
    input  rst_n,
    input  in_sync,
    output data_in
);


  wire inter;

  reg ff1, ff2;

  // ff1
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) ff1 <= 0;
    else ff1 <= in_sync;
  end

  //ff2
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) ff2 <= 0;
    else ff2 <= inter;
  end



  assign inter   = ff1;
  assign data_in = ff2;



endmodule
