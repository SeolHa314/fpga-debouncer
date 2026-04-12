#include "Vtop.h"
#include <memory>
#include <verilated.h>

int main(int argc, char **argv) {
  int clock_cycles = 200;
  Verilated::mkdir("logs");
  const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};

  contextp->debug(0);
  contextp->threads(1);
  contextp->randReset(2);
  contextp->traceEverOn(true);
  contextp->commandArgs(argc, argv);

  const std::unique_ptr<Vtop> top{new Vtop{contextp.get(), "TOP"}};

  top->rst_n = !0;
  top->clk = 0;
  top->leds = 0b111110;

  while (clock_cycles > 0) {
    contextp->timeInc(1);
    top->clk = !top->clk;
    if (top->clk) {
      if (contextp->time() > 40 && contextp->time() < 46) {
        top->rst_n = !1;
      } else {
        top->rst_n = !0;
      }
    }
    top->eval();
    clock_cycles -= top->clk;

    VL_PRINTF("[%" PRId64 "] clk=%x rst_n=%x\n", contextp->time(), top->clk,
              top->rst_n);
  }

  top->final();

#if VM_COVERAGE
  Verilated::mkdir("logs");
  contextp->coveragep()->write("logs/coverage.dat");
#endif
  contextp->statsPrintSummary();
  return 0;
};
