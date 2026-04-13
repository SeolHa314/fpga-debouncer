`ifndef clkcnt
    `define clkcnt 19'd270_000
`endif
`ifndef width
    `define width 8
`endif

module debouncer #(
    parameter WIDTH = 8
)
(
    input clk,          // clk input
    input rst_n,        // reset input
    input btn,          // button input
    output btn_pulse   // debounced button output
);

reg [18:0] timer_count;
reg [WIDTH-1:0] btn_history;
reg sample_tick;

wire is_stable;
reg is_stable_delay;

assign is_stable = (btn_history == {WIDTH{1'b1}});
assign btn_pulse = ~is_stable_delay & is_stable;

always @(posedge clk) begin
    if (!rst_n) begin
        timer_count <= 0;
        btn_history <= {WIDTH{1'b1}};
        is_stable_delay <= 1;
    end else begin
        if (timer_count < `clkcnt) begin
            timer_count <= timer_count + 1;
            sample_tick <= 0;
        end else begin
            timer_count <= 0;
            sample_tick <= 1;
        end
        
        if (sample_tick) begin
            btn_history <= {btn_history[WIDTH-2:0], btn};
        end

        is_stable_delay <= is_stable;
    end
end

endmodule

module pwm #(
    parameter WIDTH = 8
)
(
    input clk,          // clk input
    input rst_n,        // reset input
    input [1:0] mode,         // PWM mode
    output pwm_out      // PWM output
);

reg [WIDTH-1:0] pwm_clock;
reg [WIDTH-1:0] threshold;
assign pwm_out = (pwm_clock < threshold) ? 1'b1 : 1'b0;

always @(*) begin
    case (mode)
        2'd0: threshold = {WIDTH{1'b0}};    // State 0 (OFF): pwm_clock = 0
        2'd1: threshold = {WIDTH{1'b1}} >> 2;
        2'd2: threshold = {WIDTH{1'b1}} >> 1;
        2'd3: threshold = {WIDTH{1'b1}};
        default: threshold = {WIDTH{1'b0}}; // Safety net: always include a default!
    endcase
end

always @(posedge clk) begin
    if (!rst_n) begin
        pwm_clock <= {WIDTH{1'b0}};
    end else begin
        pwm_clock <= pwm_clock + 1;
    end
end

endmodule

module led
(
    input sys_clk,          // clk input
    input sys_rst_n,        // reset input
    input sys_btn,          // button input
    output [5:0] leds    // 6 LEDS pin
);

reg [1:0] mode;
wire pwm_out;
wire debounced_btn_pulse;
assign leds = pwm_out ? {6{1'b0}} : {6{1'b1}};

debouncer #( .WIDTH(`width) ) db (
    .clk(sys_clk),
    .rst_n(sys_rst_n),
    .btn(sys_btn),
    .btn_pulse(debounced_btn_pulse)
);

pwm #( .WIDTH(`width) ) pwm_inst
(
    .clk(sys_clk),
    .rst_n(sys_rst_n),
    .mode(mode),
    .pwm_out(pwm_out)
);

always @(posedge sys_clk) begin
    if (!sys_rst_n) begin
        mode <= 2'd0;
    end else if (debounced_btn_pulse) begin
        mode <= mode + 1;
    end
end

endmodule
