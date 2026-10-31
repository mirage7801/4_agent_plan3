// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:30:44 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_yixernsx/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* A = "0" *) (* B = "1" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (clk,
    in,
    reset,
    out);
  input clk;
  input in;
  input reset;
  output out;

  wire \<const0> ;
  wire \<const1> ;
  wire VCC_2;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire in;
  wire in_IBUF;
  wire out;
  wire out_OBUF;
  wire reset;
  wire reset_IBUF;
  wire state_i_1_n_0;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  VCC VCC_1
       (.P(VCC_2));
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
  IBUF in_IBUF_inst
       (.I(in),
        .O(in_IBUF));
  OBUF out_OBUF_inst
       (.I(out_OBUF),
        .O(out));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  LUT3 #(
    .INIT(8'hF9)) 
    state_i_1
       (.I0(in_IBUF),
        .I1(out_OBUF),
        .I2(reset_IBUF),
        .O(state_i_1_n_0));
  FDRE state_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(state_i_1_n_0),
        .Q(out_OBUF),
        .R(\<const0> ));
endmodule
