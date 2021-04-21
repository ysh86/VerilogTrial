`default_nettype none

`define DIV_BITS 15 // clk:33MHz div:32768 -> 1007Hz

module practice5(
	input wire clk,
	input wire sw_in_n,
	output wire led_out
);

	reg led_node;
	reg sw_in_node_n;
	reg [`DIV_BITS-1:0] div_counter;
	wire div_clk;

	always @(posedge clk) begin
		div_counter <= div_counter + `DIV_BITS'b1;
	end

	assign div_clk = div_counter[`DIV_BITS-1];

	always @(posedge div_clk) begin
		sw_in_node_n <= sw_in_n;
	end

	always @(negedge sw_in_node_n) begin
		led_node <= !led_node;
	end

	assign led_out = led_node;

endmodule
