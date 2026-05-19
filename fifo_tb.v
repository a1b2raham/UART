
module fifo_tb #(
    parameter depth = 4,
    parameter width = 5
);
  reg clk, rst, rd_en, wr_en;
  reg  [width-1:0] write_data;

  wire [width-1:0] read_data;


  /*AUTOWIRE*/

  fifo #(
      .depth(depth),
      .width(width)
  ) uut (
      /*AUTOINST*/
      // Outputs
      .read_data   (read_data[width-1:0]),
      // Inputs
      .clk   (clk),
      .rst   (rst),
      .rd_en   (rd_en),
      .wr_en   (wr_en),
      .write_data  (write_data[width-1:0])
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, fifo_tb);


    rst = 0;
    #2 rst = 1;
    #1 rst = 0;

    $monitor(" registor = %d , output = %d", uut.register[0], read_data);



    #2 write_data = 5'd3;
    wr_en = 1;

    @(posedge clk) rd_en = 1;
    #25;



    $finish;



  end



endmodule

