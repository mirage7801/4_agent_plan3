// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Thu Oct  8 00:01:12 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_m9bthlef/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (clk,
    x,
    y,
    Y0,
    z);
  input clk;
  input x;
  input [2:0]y;
  output Y0;
  output z;

  wire Y0;
  wire Y0_OBUF;
  wire x;
  wire x_IBUF;
  wire [2:0]y;
  wire [2:0]y_IBUF;
  wire z;
  wire z_OBUF;

  OBUF Y0_OBUF_inst
       (.I(Y0_OBUF),
        .O(Y0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h56)) 
    Y0_OBUF_inst_i_1
       (.I0(x_IBUF),
        .I1(y_IBUF[0]),
        .I2(y_IBUF[2]),
        .O(Y0_OBUF));
  IBUF x_IBUF_inst
       (.I(x),
        .O(x_IBUF));
  IBUF \y_IBUF[0]_inst 
       (.I(y[0]),
        .O(y_IBUF[0]));
  IBUF \y_IBUF[1]_inst 
       (.I(y[1]),
        .O(y_IBUF[1]));
  IBUF \y_IBUF[2]_inst 
       (.I(y[2]),
        .O(y_IBUF[2]));
  OBUF z_OBUF_inst
       (.I(z_OBUF),
        .O(z));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hEA)) 
    z_OBUF_inst_i_1
       (.I0(y_IBUF[2]),
        .I1(y_IBUF[0]),
        .I2(y_IBUF[1]),
        .O(z_OBUF));
endmodule
