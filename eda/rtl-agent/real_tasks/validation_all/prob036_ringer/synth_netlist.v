// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 21:41:55 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_pv5d4ok1/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (ring,
    vibrate_mode,
    ringer,
    motor);
  input ring;
  input vibrate_mode;
  output ringer;
  output motor;

  wire motor;
  wire motor_OBUF;
  wire ring;
  wire ring_IBUF;
  wire ringer;
  wire ringer_OBUF;
  wire vibrate_mode;
  wire vibrate_mode_IBUF;

  OBUF motor_OBUF_inst
       (.I(motor_OBUF),
        .O(motor));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h8)) 
    motor_OBUF_inst_i_1
       (.I0(ring_IBUF),
        .I1(vibrate_mode_IBUF),
        .O(motor_OBUF));
  IBUF ring_IBUF_inst
       (.I(ring),
        .O(ring_IBUF));
  OBUF ringer_OBUF_inst
       (.I(ringer_OBUF),
        .O(ringer));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h2)) 
    ringer_OBUF_inst_i_1
       (.I0(ring_IBUF),
        .I1(vibrate_mode_IBUF),
        .O(ringer_OBUF));
  IBUF vibrate_mode_IBUF_inst
       (.I(vibrate_mode),
        .O(vibrate_mode_IBUF));
endmodule
