import subprocess
import glob
import pathlib

def vfile_path():
    return glob.glob(str(pathlib.Path("verilog") / "**" / "*.v"), recursive=True)

def run_yosys():
    vfiles = vfile_path()
    yosys_commands = []
    for vfile in vfiles:
        yosys_commands.append(f"read_verilog {vfile}")
    yosys_commands.append("synth_gowin -json fpga_build/top.json")
    cmd = ["yowasp-yosys", "-p", "; ".join(yosys_commands)]
    subprocess.run(cmd)