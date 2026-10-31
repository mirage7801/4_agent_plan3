// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:20:18 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_xa57s1v9/synth_netlist.v
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
    a,
    b,
    out_assign,
    out_always_comb,
    out_always_ff);
  input clk;
  input a;
  input b;
  output out_assign;
  output out_always_comb;
  output out_always_ff;

  wire \<const0> ;
  wire \<const1> ;
  wire VCC_2;
  wire a;
  wire a_IBUF;
  wire b;
  wire b_IBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire out_always_comb;
  wire out_always_comb_OBUF;
  wire out_always_ff;
  wire out_always_ff_OBUF;
  wire out_assign;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  VCC VCC_1
       (.P(VCC_2));
  IBUF a_IBUF_inst
       (.I(a),
        .O(a_IBUF));
  IBUF b_IBUF_inst
       (.I(b),
        .O(b_IBUF));
  (* XILINX_LEGACY_PRIM = "BUFG" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:CE" *) 
  BUFGCE #(
    .CE_TYPE("ASYNC"),
    .SIM_DEVICE("ULTRASCALE_PLUS")) 
    clk_IBUF_BUFG_inst
       (.CE(VCC_2),
        .I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  OBUF out_always_comb_OBUF_inst
       (.I(out_always_comb_OBUF),
        .O(out_always_comb));
  OBUF out_always_ff_OBUF_inst
       (.I(out_always_ff_OBUF),
        .O(out_always_ff));
  FDRE out_always_ff_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_always_comb_OBUF),
        .Q(out_always_ff_OBUF),
        .R(\<const0> ));
  OBUF out_assign_OBUF_inst
       (.I(out_always_comb_OBUF),
        .O(out_assign));
  LUT2 #(
    .INIT(4'h6)) 
    out_assign_OBUF_inst_i_1
       (.I0(b_IBUF),
        .I1(a_IBUF),
        .O(out_always_comb_OBUF));
endmodule
