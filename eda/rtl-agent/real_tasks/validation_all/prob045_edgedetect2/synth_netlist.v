// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 21:57:37 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_7d6r0k5i/synth_netlist.v
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
    in,
    anyedge);
  input clk;
  input [7:0]in;
  output [7:0]anyedge;

  wire \<const0> ;
  wire \<const1> ;
  wire VCC_2;
  wire [7:0]anyedge;
  wire \anyedge[0]_i_1_n_0 ;
  wire \anyedge[1]_i_1_n_0 ;
  wire \anyedge[2]_i_1_n_0 ;
  wire \anyedge[3]_i_1_n_0 ;
  wire \anyedge[4]_i_1_n_0 ;
  wire \anyedge[5]_i_1_n_0 ;
  wire \anyedge[6]_i_1_n_0 ;
  wire \anyedge[7]_i_1_n_0 ;
  wire [7:0]anyedge_OBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [7:0]d_last;
  wire [7:0]in;
  wire [7:0]in_IBUF;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  VCC VCC_1
       (.P(VCC_2));
  LUT2 #(
    .INIT(4'h6)) 
    \anyedge[0]_i_1 
       (.I0(d_last[0]),
        .I1(in_IBUF[0]),
        .O(\anyedge[0]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \anyedge[1]_i_1 
       (.I0(d_last[1]),
        .I1(in_IBUF[1]),
        .O(\anyedge[1]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \anyedge[2]_i_1 
       (.I0(d_last[2]),
        .I1(in_IBUF[2]),
        .O(\anyedge[2]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \anyedge[3]_i_1 
       (.I0(d_last[3]),
        .I1(in_IBUF[3]),
        .O(\anyedge[3]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \anyedge[4]_i_1 
       (.I0(d_last[4]),
        .I1(in_IBUF[4]),
        .O(\anyedge[4]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \anyedge[5]_i_1 
       (.I0(d_last[5]),
        .I1(in_IBUF[5]),
        .O(\anyedge[5]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \anyedge[6]_i_1 
       (.I0(d_last[6]),
        .I1(in_IBUF[6]),
        .O(\anyedge[6]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \anyedge[7]_i_1 
       (.I0(d_last[7]),
        .I1(in_IBUF[7]),
        .O(\anyedge[7]_i_1_n_0 ));
  OBUF \anyedge_OBUF[0]_inst 
       (.I(anyedge_OBUF[0]),
        .O(anyedge[0]));
  OBUF \anyedge_OBUF[1]_inst 
       (.I(anyedge_OBUF[1]),
        .O(anyedge[1]));
  OBUF \anyedge_OBUF[2]_inst 
       (.I(anyedge_OBUF[2]),
        .O(anyedge[2]));
  OBUF \anyedge_OBUF[3]_inst 
       (.I(anyedge_OBUF[3]),
        .O(anyedge[3]));
  OBUF \anyedge_OBUF[4]_inst 
       (.I(anyedge_OBUF[4]),
        .O(anyedge[4]));
  OBUF \anyedge_OBUF[5]_inst 
       (.I(anyedge_OBUF[5]),
        .O(anyedge[5]));
  OBUF \anyedge_OBUF[6]_inst 
       (.I(anyedge_OBUF[6]),
        .O(anyedge[6]));
  OBUF \anyedge_OBUF[7]_inst 
       (.I(anyedge_OBUF[7]),
        .O(anyedge[7]));
  FDRE \anyedge_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\anyedge[0]_i_1_n_0 ),
        .Q(anyedge_OBUF[0]),
        .R(\<const0> ));
  FDRE \anyedge_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\anyedge[1]_i_1_n_0 ),
        .Q(anyedge_OBUF[1]),
        .R(\<const0> ));
  FDRE \anyedge_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\anyedge[2]_i_1_n_0 ),
        .Q(anyedge_OBUF[2]),
        .R(\<const0> ));
  FDRE \anyedge_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\anyedge[3]_i_1_n_0 ),
        .Q(anyedge_OBUF[3]),
        .R(\<const0> ));
  FDRE \anyedge_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\anyedge[4]_i_1_n_0 ),
        .Q(anyedge_OBUF[4]),
        .R(\<const0> ));
  FDRE \anyedge_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\anyedge[5]_i_1_n_0 ),
        .Q(anyedge_OBUF[5]),
        .R(\<const0> ));
  FDRE \anyedge_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\anyedge[6]_i_1_n_0 ),
        .Q(anyedge_OBUF[6]),
        .R(\<const0> ));
  FDRE \anyedge_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\anyedge[7]_i_1_n_0 ),
        .Q(anyedge_OBUF[7]),
        .R(\<const0> ));
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
  FDRE \d_last_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF[0]),
        .Q(d_last[0]),
        .R(\<const0> ));
  FDRE \d_last_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF[1]),
        .Q(d_last[1]),
        .R(\<const0> ));
  FDRE \d_last_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF[2]),
        .Q(d_last[2]),
        .R(\<const0> ));
  FDRE \d_last_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF[3]),
        .Q(d_last[3]),
        .R(\<const0> ));
  FDRE \d_last_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF[4]),
        .Q(d_last[4]),
        .R(\<const0> ));
  FDRE \d_last_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF[5]),
        .Q(d_last[5]),
        .R(\<const0> ));
  FDRE \d_last_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF[6]),
        .Q(d_last[6]),
        .R(\<const0> ));
  FDRE \d_last_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF[7]),
        .Q(d_last[7]),
        .R(\<const0> ));
  IBUF \in_IBUF[0]_inst 
       (.I(in[0]),
        .O(in_IBUF[0]));
  IBUF \in_IBUF[1]_inst 
       (.I(in[1]),
        .O(in_IBUF[1]));
  IBUF \in_IBUF[2]_inst 
       (.I(in[2]),
        .O(in_IBUF[2]));
  IBUF \in_IBUF[3]_inst 
       (.I(in[3]),
        .O(in_IBUF[3]));
  IBUF \in_IBUF[4]_inst 
       (.I(in[4]),
        .O(in_IBUF[4]));
  IBUF \in_IBUF[5]_inst 
       (.I(in[5]),
        .O(in_IBUF[5]));
  IBUF \in_IBUF[6]_inst 
       (.I(in[6]),
        .O(in_IBUF[6]));
  IBUF \in_IBUF[7]_inst 
       (.I(in[7]),
        .O(in_IBUF[7]));
endmodule
