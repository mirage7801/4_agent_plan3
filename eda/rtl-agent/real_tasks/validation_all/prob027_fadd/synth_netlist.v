// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 21:26:28 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_4d7efoez/synth_netlist.v
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
    cin,
    cout,
    sum);
  input a;
  input b;
  input cin;
  output cout;
  output sum;

  wire a;
  wire a_IBUF;
  wire b;
  wire b_IBUF;
  wire cin;
  wire cin_IBUF;
  wire cout;
  wire cout_OBUF;
  wire sum;
  wire sum_OBUF;

  IBUF a_IBUF_inst
       (.I(a),
        .O(a_IBUF));
  IBUF b_IBUF_inst
       (.I(b),
        .O(b_IBUF));
  IBUF cin_IBUF_inst
       (.I(cin),
        .O(cin_IBUF));
  OBUF cout_OBUF_inst
       (.I(cout_OBUF),
        .O(cout));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    cout_OBUF_inst_i_1
       (.I0(b_IBUF),
        .I1(cin_IBUF),
        .I2(a_IBUF),
        .O(cout_OBUF));
  OBUF sum_OBUF_inst
       (.I(sum_OBUF),
        .O(sum));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h96)) 
    sum_OBUF_inst_i_1
       (.I0(a_IBUF),
        .I1(b_IBUF),
        .I2(cin_IBUF),
        .O(sum_OBUF));
endmodule
