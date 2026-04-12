`define clkcnt 24'd4
`include "blink.v"

module top
(
  input clk,          // clk input
  input rst_n,        // reset input
  output [5:0] leds = 6'b111110      // 6 LEDS pin
);

  led blinker(
      .sys_clk(clk),
      .sys_rst_n(rst_n),
      .leds(leds)
  );
  
  // Print some stuff as an example
  initial begin
    if ($test$plusargs("trace") != 0) begin
      $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
      $dumpfile("logs/vlt_dump.vcd");
      $dumpvars();
    end
    $display("[%0t] Model running...\n", $time);
  end

endmodule
