// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:09:25 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_gzcfq39q/synth_netlist.v
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
    out_and,
    out_or,
    out_xor,
    out_nand,
    out_nor,
    out_xnor,
    out_anotb);
  input a;
  input b;
  output out_and;
  output out_or;
  output out_xor;
  output out_nand;
  output out_nor;
  output out_xnor;
  output out_anotb;

  wire a;
  wire a_IBUF;
  wire b;
  wire b_IBUF;
  wire out_and;
  wire out_and_OBUF;
  wire out_anotb;
  wire out_anotb_OBUF;
  wire out_nand;
  wire out_nand_OBUF;
  wire out_nor;
  wire out_nor_OBUF;
  wire out_or;
  wire out_or_OBUF;
  wire out_xnor;
  wire out_xnor_OBUF;
  wire out_xor;
  wire out_xor_OBUF;

  IBUF a_IBUF_inst
       (.I(a),
        .O(a_IBUF));
  IBUF b_IBUF_inst
       (.I(b),
        .O(b_IBUF));
  OBUF out_and_OBUF_inst
       (.I(out_and_OBUF),
        .O(out_and));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h8)) 
    out_and_OBUF_inst_i_1
       (.I0(a_IBUF),
        .I1(b_IBUF),
        .O(out_and_OBUF));
  OBUF out_anotb_OBUF_inst
       (.I(out_anotb_OBUF),
        .O(out_anotb));
  LUT2 #(
    .INIT(4'h2)) 
    out_anotb_OBUF_inst_i_1
       (.I0(a_IBUF),
        .I1(b_IBUF),
        .O(out_anotb_OBUF));
  OBUF out_nand_OBUF_inst
       (.I(out_nand_OBUF),
        .O(out_nand));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h7)) 
    out_nand_OBUF_inst_i_1
       (.I0(b_IBUF),
        .I1(a_IBUF),
        .O(out_nand_OBUF));
  OBUF out_nor_OBUF_inst
       (.I(out_nor_OBUF),
        .O(out_nor));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h1)) 
    out_nor_OBUF_inst_i_1
       (.I0(b_IBUF),
        .I1(a_IBUF),
        .O(out_nor_OBUF));
  OBUF out_or_OBUF_inst
       (.I(out_or_OBUF),
        .O(out_or));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'hE)) 
    out_or_OBUF_inst_i_1
       (.I0(a_IBUF),
        .I1(b_IBUF),
        .O(out_or_OBUF));
  OBUF out_xnor_OBUF_inst
       (.I(out_xnor_OBUF),
        .O(out_xnor));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h9)) 
    out_xnor_OBUF_inst_i_1
       (.I0(a_IBUF),
        .I1(b_IBUF),
        .O(out_xnor_OBUF));
  OBUF out_xor_OBUF_inst
       (.I(out_xor_OBUF),
        .O(out_xor));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    out_xor_OBUF_inst_i_1
       (.I0(b_IBUF),
        .I1(a_IBUF),
        .O(out_xor_OBUF));
endmodule
