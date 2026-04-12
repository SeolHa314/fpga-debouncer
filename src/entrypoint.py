import argparse
import pathlib
import glob
from . import yosys
from . import nextpnr
from . import openfpgaloader

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--skip-synthesis",
        action="store_true",
        help="Skip synthesis, place-and-route, and packing, and only load an existing bitstream.",
    )
    parser.add_argument(
        "--skip-flash",
        action="store_true",
        help="Skip writing to flash.",
    )
    parser.add_argument(
        "--write-flash",
        "-f",
        action="store_true",
        help="Write the bitstream to flash instead of only loading it to SRAM.",
    )
    return parser.parse_args()

def entrypoint():
    args = parse_args()
    skip_synthesis = args.skip_synthesis
    
    for file in glob.glob(str(pathlib.Path("fpga_build") / "*")):
        if file.endswith(".gitkeep") or (skip_synthesis and file.endswith(".fs")):
            continue
        pathlib.Path(file).unlink()

    if not skip_synthesis:
        yosys.run_yosys()
        nextpnr.runNextpnr()
        nextpnr.runGowinPack()
    else:
        # if "fpga_build/pack.fs" doesn't exist, raise an error
        if not pathlib.Path("fpga_build/pack.fs").exists():
            raise SystemExit(
                "Error: fpga_build/pack.fs not found. Please run the script without --skip-synthesis first."
            )
    if not args.skip_flash:
        if args.write_flash:
            openfpgaloader.runOpenFPGALoader(write_flash=True)
        else:
            openfpgaloader.runOpenFPGALoader()
