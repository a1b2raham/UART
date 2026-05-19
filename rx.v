module rx #(
    parameter data_width = 8
) (
    input clk,
    input rst_n,
    input baud_tick,
    input data_in,
    output reg rx_done,
    output reg rx_busy,
    output reg frame_error,

    output reg [data_width-1:0] data_out
);

  localparam idle = 2'b00;
  localparam start = 2'b01;
  localparam rec = 2'b11;
  localparam stop = 2'b10;




  reg  [                   3:0] counter;
  wire [                   3:0] count_out;
  reg  [                   3:0] value;
  wire                          en_count;

  reg  [$clog2(data_width)-1:0] data_counter;
  wire [$clog2(data_width)-1:0] data_counter_wire;
  wire                          en_data_count;

  wire [        data_width-1:0] data_out_wire;
  wire                          data_out_en;


  wire                          sample_data;  // wire to indicate points of sampling
  wire                          data_completed;  // wire to show that data is completed
  wire                          frame_error_wire;


  reg [1:0] nxt_state, state;


  reg [data_width-1:0] data_shift_reg;
  wire en_data_shift;


  // state register
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) state <= 0;
    else state <= nxt_state;
  end

  //fsm
  always @(*) begin
    nxt_state = state;
    case (state)
      idle: if (~data_in) nxt_state = start;
      start: if (sample_data) nxt_state = (data_in) ? idle : rec;
      rec: if (data_completed) nxt_state = stop;
      stop: if (sample_data) nxt_state = idle;
      default: nxt_state = idle;
    endcase
  end  // always @ (*)


  // counter for finding center point
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) counter <= 0;
    else if (en_count) counter <= count_out;
  end


  //data bit counter
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) data_counter <= 0;
    else if (en_data_count) data_counter <= data_counter_wire;
  end


  // shift register
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) data_shift_reg <= 0;
    else if (en_data_shift) data_shift_reg <= {data_in, data_shift_reg[data_width-1:1]};
  end


  // frame_error
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) frame_error <= 0;
    else frame_error <= frame_error_wire;
  end

  //output register
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) data_out <= 0;
    else if (data_out_en) data_out <= data_shift_reg;
  end

  //rx_done
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) rx_done <= 0;
    else rx_done <= data_out_en;
  end

  //rx_busy
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) rx_busy <= 0;
    else rx_busy <= ~(state == idle);
  end


  // assignments
  assign frame_error_wire = (~data_in && (state == stop) && sample_data);
  assign en_data_count = (sample_data && (state == rec));
  assign data_counter_wire = (data_counter == data_width - 1) ? 0 : data_counter + 1'b1;
  assign count_out = (counter == value) ? 0 : counter + 1'b1;
  assign en_count = (baud_tick && (state != idle));
  assign sample_data = ((counter == value) && baud_tick);
  assign data_completed = ((data_counter == data_width - 1) && sample_data);
  assign en_data_shift = (sample_data && (state == rec));
  assign data_out_en = ((state == stop) && sample_data);

  always @(*) begin
    case (state)
      start: value = 4'd7;
      rec: value = 4'd15;
      stop: value = 4'd15;
      default: value = 4'd0;
    endcase
  end


endmodule
