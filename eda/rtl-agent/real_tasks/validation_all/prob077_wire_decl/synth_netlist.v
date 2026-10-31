// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:51:34 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_35ms20eu/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (a,
    b,
    c,
    d,
    out,
    out_n);
  input a;
  input b;
  input c;
  input d;
  output out;
  output out_n;

  wire a;
  wire a_IBUF;
  wire b;
  wire b_IBUF;
  wire c;
  wire c_IBUF;
  wire d;
  wire d_IBUF;
  wire out;
  wire out_OBUF;
  wire out_n;
  wire out_n_OBUF;

  IBUF a_IBUF_inst
       (.I(a),
        .O(a_IBUF));
  IBUF b_IBUF_inst
       (.I(b),
        .O(b_IBUF));
  IBUF c_IBUF_inst
       (.I(c),
        .O(c_IBUF));
  IBUF d_IBUF_inst
       (.I(d),
        .O(d_IBUF));
  OBUF out_OBUF_inst
       (.I(out_OBUF),
        .O(out));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hF888)) 
    out_OBUF_inst_i_1
       (.I0(b_IBUF),
        .I1(a_IBUF),
        .I2(d_IBUF),
        .I3(c_IBUF),
        .O(out_OBUF));
  OBUF out_n_OBUF_inst
       (.I(out_n_OBUF),
        .O(out_n));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h0777)) 
    out_n_OBUF_inst_i_1
       (.I0(c_IBUF),
        .I1(d_IBUF),
        .I2(a_IBUF),
        .I3(b_IBUF),
        .O(out_n_OBUF));
endmodule
