# Implementing Button Debouncer

A learning repository for basic FPGA skills.

## Implementation Details

LED's brightness cycles through 0, 25, 50, 100% when button on the right is pushed.
To detect the button press stably, the debouncer using shifted registers is implemented by a separated module.
PWM operations are also in separated module for code readability.

## Prerequisites

Install `openFPGALoader`, usually available in Ubuntu repository.
If needed, enable [udev rules](https://trabucayre.github.io/openFPGALoader/guide/install.html#udev-rules).

Install `uv`.

To simulate the design, install `verilator`. The package in Ubuntu repository is relatively old, building your own version of verilator is recommanded.

## Howto

1. `uv sync`
2. `uv run main.py`

## Commandline Options

- `--skip-synthesis` to only flash to device and skip synthesizing/P&L.
- `--write-flash` or `-f` to write to the flash.

## Simulation

Basic simulation by `verilator` is implemented, run `make` in `sim/` and vcd waveform will be created under `sim/logs/`.
Waveform viewers such as GTKWave or vaporview are available.
