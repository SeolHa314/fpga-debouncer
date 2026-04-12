#include "Vtop.h"
#include <memory>
#include <verilated.h>

int main(int argc, char **argv) {
  int clock_cycles = 500;
  Verilated::mkdir("logs");
  const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};

  contextp->debug(0);
  contextp->threads(1);
  contextp->randReset(2);
  contextp->traceEverOn(true);
  contextp->commandArgs(argc, argv);

  const std::unique_ptr<Vtop> top{new Vtop{contextp.get(), "TOP"}};

  top->clk = 0;
  top->btn = !0;
  top->leds = 0b111110;

  while (clock_cycles > 0) {
    contextp->timeInc(1);
    top->clk = !top->clk;
    if (top->clk) {
      if (contextp->time() % 25 == 0) {
        top->btn = !top->btn;
      } else if (contextp->time() % 25 == 12) {
        top->btn = !top->btn;
      }
    }
    top->eval();
    clock_cycles -= top->clk;

    VL_PRINTF("[%" PRId64 "] clk=%x btn=%x\n", contextp->time(), top->clk,
              top->btn);
  }

  top->final();

#if VM_COVERAGE
  Verilated::mkdir("logs");
  contextp->coveragep()->write("logs/coverage.dat");
#endif
  contextp->statsPrintSummary();
  return 0;
};
