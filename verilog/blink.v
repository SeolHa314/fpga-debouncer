// copied and modified from sipeed wiki
`ifndef clkcnt
    `define clkcnt 24'd1349_9999
`endif

module led
(
    input sys_clk,          // clk input
    input sys_rst_n,        // reset input
    output reg [5:0] leds    // 6 LEDS pin
);

reg [23:0] counter;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        counter <= 24'd0;
    else if (counter < `clkcnt)       // 0.5s delay
        counter <= counter + 1'b1;
    else
        counter <= 24'd0;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        leds <= 6'b111110;
    else if (counter == `clkcnt)       // 0.5s delay
        leds[5:0] <= {leds[4:0],leds[5]};
    else
        leds <= leds;
end

endmodule
