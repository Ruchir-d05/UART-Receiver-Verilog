//RTL Design Code:
module UART_RX
 #(parameter CLKS_PER_BIT = 217)
 (
 input clk,
 input rx,
 output rx_valid,
 output [7:0] rx_data
 );
 parameter STATE_IDLE = 3'b000;
 parameter STATE_START = 3'b001;
 parameter STATE_DATA = 3'b010;
 parameter STATE_STOP = 3'b011;
 parameter STATE_CLEANUP = 3'b100;
 reg [7:0] baud_cnt = 0;
 reg [2:0] bit_cnt = 0;
 reg [7:0] rx_shift_reg = 0;
 reg rx_valid_reg = 0;
 reg [2:0] state = 0;
 always @(posedge clk) begin
 case (state)
 STATE_IDLE: begin
 rx_valid_reg <= 1'b0;
 baud_cnt <= 0;
 bit_cnt <= 0;
 if (rx == 1'b0)
 state <= STATE_START;
 else
 state <= STATE_IDLE;
 end
 STATE_START: begin
 if (baud_cnt == (CLKS_PER_BIT-1)/2) begin
 if (rx == 1'b0) begin
 baud_cnt <= 0;
 state <= STATE_DATA;
 end else
 state <= STATE_IDLE;
 end else begin
 baud_cnt <= baud_cnt + 1;
 state <= STATE_START;
 end
 end
 STATE_DATA: begin
 if (baud_cnt < CLKS_PER_BIT-1) begin
 baud_cnt <= baud_cnt + 1;
 state <= STATE_DATA;
 end else begin
 baud_cnt <= 0;
 rx_shift_reg[bit_cnt] <= rx;
 if (bit_cnt < 7) begin
 bit_cnt <= bit_cnt + 1;
 state <= STATE_DATA;
 end else begin
 bit_cnt <= 0;
 state <= STATE_STOP;
 end
 end
 end
 STATE_STOP: begin
 if (baud_cnt < CLKS_PER_BIT-1) begin
 baud_cnt <= baud_cnt + 1;
 state <= STATE_STOP;
 end else begin
 rx_valid_reg <= 1'b1;
 baud_cnt <= 0;
 state <= STATE_CLEANUP;
 end
 end
 STATE_CLEANUP: begin
 rx_valid_reg <= 1'b0;
 state <= STATE_IDLE;
 end
 default: state <= STATE_IDLE;
 endcase
 end
 assign rx_valid = rx_valid_reg;
 assign rx_data = rx_shift_reg;
endmodule
