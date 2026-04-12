`ifndef clkcnt
    `define clkcnt 19'd270_000
`endif

module led
(
    input sys_clk,          // clk input
    input sys_rst_n,        // reset input
    input sys_btn,          // button input
    output [5:0] leds    // 6 LEDS pin
);

reg [18:0] timer_count;
reg [5:0] count;
//reg led_state;

reg [7:0] btn_history;

//assign leds = ~{6{led_state}};
assign leds = ~count;

wire is_stable;
reg is_stable_delay;
reg sample_tick;

assign is_stable = (btn_history == 8'hFF);

always @(posedge sys_clk) begin
    if (!sys_rst_n) begin
        count <= 0;
        //led_state <= 1;
        timer_count <= 0;
        btn_history <= 8'hFF;
        is_stable_delay <= 0;
        sample_tick <= 0;
    end else begin
        if (timer_count < `clkcnt) begin
            timer_count <= timer_count + 1;
            sample_tick <= 0;
        end else begin
            timer_count <= 1;
            sample_tick <= 1;
        end
        
        if (sample_tick) begin
            btn_history <= {btn_history[6:0], sys_btn};
        end

        if (~is_stable_delay & is_stable) begin
            count <= count + 1;
            //led_state <= ~led_state;
        end
        is_stable_delay <= is_stable;
    end
end 

endmodule
