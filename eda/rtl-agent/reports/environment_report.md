# Environment check (2026-09-21)

- Project: `E:\fpga\赛题研究\rtl-agent`; this directory did not exist before work began. The sibling PDFs, teammate instruction and `tmp` were not modified. Not a Git repository.
- Windows 11 Home Chinese 64-bit, 10.0.26200. `python` resolves to `C:\Users\46611\AppData\Local\Programs\Python\Python312\python.exe`, version 3.12.10; `py` launcher is available. E: free space at check: 89,870,794,752 bytes (~83.7 GiB); directory ACL permits writes and new files were created.
- `vivado`, `xvlog`, `xelab`, `xsim` absent from PATH. Registry identified Vivado 2026.1 at `D:\AMDDesignTools`. Actual executables: `D:\AMDDesignTools\2026.1\Vivado\bin\{vivado,xvlog,xelab,xsim}.bat`. Explicit paths are used in every run.
- `vivado.bat -version` printed `vivado v2026.1 (64-bit)`, SW Build 6511674. Its informational Windows switch returned code 1; real batch invocation returned 0. Tcl `get_parts -quiet xczu3eg-sbva484-1-e` returned exactly one match.
- Vivado reported an active BASIC license expiring 20 Sep 2027; the actual counter synthesis acquired `Vivado_Synthesis`/device license. No license bypass or installer/environment changes were attempted.
- Initial synthesis with Unicode cwd/source entered RTL elaboration and exited `0xC0000374` without netlist. Byte-identical staging in a private ASCII temporary directory fixed that run; see original failure and successful run under `outputs/counter_reference*`. Temporary tool products are contained there and cleaned on completion; persistent logs/netlist stay in `outputs/`.
- An independent Icarus Verilog is at `C:\iverilog\bin\iverilog.exe` and was used only as a supplementary fast check, not as a substitute for Vivado.
