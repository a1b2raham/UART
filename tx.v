module tx #(
    parameter data_width = 8
) (
    input                       en,
    input                       clk,
    input                       rst_n,
    input                       baud_tick,
    input      [data_width-1:0] data_in,
    output reg                  data_out,
    output reg                  tx_done,
    output reg                  tx_busy
);

  localparam idle = 2'b00;
  localparam start = 2'b01;
  localparam trans = 2'b11;
  localparam stop = 2'b10;


  reg [1:0] state, nxt_state;
  reg  [$clog2(data_width)- 1:0] data_count;
  wire [ $clog2(data_width)-1:0] data_count_wire;
  wire                           data_chk;
  reg  [       data_width-1 : 0] data_reg;
  wire                           data_sent;
  reg                            data_out_wire;
  wire                           tx_done_wire;
  wire                           tx_busy_wire;



  //state register
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) state <= idle;
    else state <= nxt_state;
  end

  //data_pointer_counter
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) data_count <= 1'b0;
    else if (baud_tick) data_count <= data_count_wire;
  end

  //data_store_reg

  always @(posedge clk) begin
    if (data_sent) data_reg <= data_in;
  end

  //comb of nxt_state

  always @(*) begin
    nxt_state = state;
    case (state)
      idle: begin
        if (en) nxt_state = start;
        else nxt_state = idle;
      end
      start: if (baud_tick) nxt_state = trans;
      trans: begin
        if (baud_tick) begin
          if (data_chk) nxt_state = trans;
          else nxt_state = stop;
        end
      end
      stop: if (baud_tick) nxt_state = idle;
      default: nxt_state = idle;
    endcase  // case (state)

  end  // always @ (*)




  //output register
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) data_out <= 1'b1;
    else if (baud_tick) data_out <= data_out_wire;
  end

  //output logic
  always @(*) begin
    case (state)
      idle: data_out_wire = 1'b1;
      start: data_out_wire = 1'b0;
      trans: data_out_wire = data_reg[data_count];
      stop: data_out_wire = 1'b1;
      default: data_out_wire = 1'b1;
    endcase  // case (state)
  end

  // stop signal for baud_tick
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) tx_done <= 1'b0;
    else tx_done <= tx_done_wire;
  end

  //busy signal

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) tx_busy <= 0;
    else tx_busy <= tx_busy_wire;
  end


  assign data_count_wire = ((state == trans) && data_chk) ? data_count + 1'b1 : 0;//mux for data_pointer
  assign data_chk = (data_count < data_width - 1);  // data_finished
  assign tx_done_wire = ((state == stop) && baud_tick);
  assign tx_busy_wire = (~(state == idle) && baud_tick);

  assign data_sent = (en && state == idle);  // computer has sent data




endmodule
