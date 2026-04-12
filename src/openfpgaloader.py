import subprocess
import sys
from . import boardconf
def runOpenFPGALoader(write_flash=False):
    command = [
        "-b", boardconf.BOARD,
        "fpga_build/pack.fs",
    ]

    if write_flash:
        command.append("--write-flash")
    
    subprocess.run(["openFPGALoader"] + command)