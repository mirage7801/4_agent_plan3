// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Sun Oct 25 16:49:54 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_pmwral6e/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (cpu_overheated,
    shut_off_computer,
    arrived,
    gas_tank_empty,
    keep_driving);
  input cpu_overheated;
  output shut_off_computer;
  input arrived;
  input gas_tank_empty;
  output keep_driving;

  wire arrived;
  wire arrived_IBUF;
  wire cpu_overheated;
  wire gas_tank_empty;
  wire gas_tank_empty_IBUF;
  wire keep_driving;
  wire keep_driving_OBUF;
  wire shut_off_computer;
  wire shut_off_computer_OBUF;

  IBUF arrived_IBUF_inst
       (.I(arrived),
        .O(arrived_IBUF));
  IBUF cpu_overheated_IBUF_inst
       (.I(cpu_overheated),
        .O(shut_off_computer_OBUF));
  IBUF gas_tank_empty_IBUF_inst
       (.I(gas_tank_empty),
        .O(gas_tank_empty_IBUF));
  OBUF keep_driving_OBUF_inst
       (.I(keep_driving_OBUF),
        .O(keep_driving));
  LUT2 #(
    .INIT(4'h1)) 
    keep_driving_OBUF_inst_i_1
       (.I0(arrived_IBUF),
        .I1(gas_tank_empty_IBUF),
        .O(keep_driving_OBUF));
  OBUF shut_off_computer_OBUF_inst
       (.I(shut_off_computer_OBUF),
        .O(shut_off_computer));
endmodule
