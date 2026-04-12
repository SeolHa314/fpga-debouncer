`define clkcnt 19'd2
`include "impl.v"

module top
(
  input clk,          // clk input
  input btn,
  output [5:0] leds = 6'b111110      // 6 LEDS pin
);

  led blinker(
      .sys_clk(clk),
      .sys_rst_n(rst_n),
      .sys_btn(btn),
      .leds(leds)
  );
  
  reg rst_n;

  // Print some stuff as an example
  initial begin
    if ($test$plusargs("trace") != 0) begin
      $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
      $dumpfile("logs/vlt_dump.vcd");
      $dumpvars();
    end
    $display("[%0t] Model running...\n", $time);
  end

  initial begin
    rst_n = 0;
    #10;
    rst_n = 1;
  end

endmodule
