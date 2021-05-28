`default_nettype none

module baseball_top(
	input wire clk,
	input wire reset_n,
	input wire hit_sw_n,
	output wire base1_led, base2_led, base3_led,
	output wire out1_led, out2_led, out3_led,
	output wire [6:0] score0_led,
	output wire team0_led,
	output wire [6:0] score1_led,
	output wire team1_led,
	output wire [7:0] batter_led
);

	wire clk_divided;

	wire [4:0] hitout_node; // hit1,hit2,hit3,hit4,out
	wire [3:0] hit_pulse;   // hit1,hit2,hit3,hit4
	wire out_pulse;
	wire change_pulse;

	wire reset_n_for_base_and_score;
	wire [2:0] base_node; // base1,base2,base3
	wire [3:0] add_to_score_pulse;

	reg hit_n;
	reg hitting_reg;
	reg team_reg;

	clk_div clk_div(clk, clk_divided);

	always @(posedge clk_divided) begin
		hit_n <= hit_sw_n;
	end
	always @(negedge hit_n, negedge reset_n) begin
		if (!reset_n) begin
			hitting_reg <= 1'b0;
		end else begin
			hitting_reg <= !hitting_reg;
		end
	end

	batting batting(
		clk_divided, reset_n,
		hitting_reg,
		hitout_node);
	batter_led_out batter_led_out(
		hitout_node,
		batter_led);
	batting_pulse batting_pulse(
		clk_divided, reset_n,
		hitting_reg,
		hitout_node,
		hit_pulse, out_pulse);
	outcount_led_out outcount_led_out(
		clk_divided, reset_n,
		out_pulse,
		out1_led, out2_led, out3_led,
		change_pulse);

	always @(posedge change_pulse, negedge reset_n) begin
		if (!reset_n) begin
			team_reg <= 1'b0;
		end else begin
			team_reg <= !team_reg;
		end
	end

	assign reset_n_for_base_and_score = (!reset_n || change_pulse) ? 0 : 1;

	base base(
		clk_divided, reset_n_for_base_and_score,
		hit_pulse,
		base_node);
	score_pulse score_pulse(
		clk_divided, reset_n_for_base_and_score,
		{base_node, hit_pulse},
		add_to_score_pulse);
	baseball_led_out baseball_led_out(
		clk_divided, reset_n,
		team_reg,
		base_node,
		add_to_score_pulse,
		team0_led, team1_led,
		base1_led, base2_led, base3_led,
		score0_led, score1_led);

endmodule
