import subprocess
from . import boardconf

def runNextpnr():
    
    command = [
    "--json",
      "fpga_build/top.json",
      "--write",
      "fpga_build/pnr.json",
      "--device",
      boardconf.DEVICE,
      "--vopt",
      f"family={boardconf.FAMILY}",
      "--vopt",
      f"cst=verilog/{boardconf.CST}",
    ]

    subprocess.run(["yowasp-nextpnr-himbaechel-gowin"] + command)

def runGowinPack():
    command = [
        "-d", boardconf.FAMILY, "-o", "fpga_build/pack.fs", "fpga_build/pnr.json"
    ]
    subprocess.run(["gowin_pack"] + command)