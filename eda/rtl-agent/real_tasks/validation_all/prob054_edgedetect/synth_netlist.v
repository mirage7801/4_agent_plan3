// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:13:15 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_a31olh5z/synth_netlist.v
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
    pedge);
  input clk;
  input [7:0]in;
  output [7:0]pedge;

  wire \<const0> ;
  wire \<const1> ;
  wire VCC_2;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [7:0]d_last;
  wire [7:0]in;
  wire [7:0]in_IBUF;
  wire [7:0]pedge;
  wire \pedge[0]_i_1_n_0 ;
  wire \pedge[1]_i_1_n_0 ;
  wire \pedge[2]_i_1_n_0 ;
  wire \pedge[3]_i_1_n_0 ;
  wire \pedge[4]_i_1_n_0 ;
  wire \pedge[5]_i_1_n_0 ;
  wire \pedge[6]_i_1_n_0 ;
  wire \pedge[7]_i_1_n_0 ;
  wire [7:0]pedge_OBUF;

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
  LUT2 #(
    .INIT(4'h2)) 
    \pedge[0]_i_1 
       (.I0(in_IBUF[0]),
        .I1(d_last[0]),
        .O(\pedge[0]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \pedge[1]_i_1 
       (.I0(in_IBUF[1]),
        .I1(d_last[1]),
        .O(\pedge[1]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \pedge[2]_i_1 
       (.I0(in_IBUF[2]),
        .I1(d_last[2]),
        .O(\pedge[2]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \pedge[3]_i_1 
       (.I0(in_IBUF[3]),
        .I1(d_last[3]),
        .O(\pedge[3]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \pedge[4]_i_1 
       (.I0(in_IBUF[4]),
        .I1(d_last[4]),
        .O(\pedge[4]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \pedge[5]_i_1 
       (.I0(in_IBUF[5]),
        .I1(d_last[5]),
        .O(\pedge[5]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \pedge[6]_i_1 
       (.I0(in_IBUF[6]),
        .I1(d_last[6]),
        .O(\pedge[6]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \pedge[7]_i_1 
       (.I0(in_IBUF[7]),
        .I1(d_last[7]),
        .O(\pedge[7]_i_1_n_0 ));
  OBUF \pedge_OBUF[0]_inst 
       (.I(pedge_OBUF[0]),
        .O(pedge[0]));
  OBUF \pedge_OBUF[1]_inst 
       (.I(pedge_OBUF[1]),
        .O(pedge[1]));
  OBUF \pedge_OBUF[2]_inst 
       (.I(pedge_OBUF[2]),
        .O(pedge[2]));
  OBUF \pedge_OBUF[3]_inst 
       (.I(pedge_OBUF[3]),
        .O(pedge[3]));
  OBUF \pedge_OBUF[4]_inst 
       (.I(pedge_OBUF[4]),
        .O(pedge[4]));
  OBUF \pedge_OBUF[5]_inst 
       (.I(pedge_OBUF[5]),
        .O(pedge[5]));
  OBUF \pedge_OBUF[6]_inst 
       (.I(pedge_OBUF[6]),
        .O(pedge[6]));
  OBUF \pedge_OBUF[7]_inst 
       (.I(pedge_OBUF[7]),
        .O(pedge[7]));
  FDRE \pedge_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\pedge[0]_i_1_n_0 ),
        .Q(pedge_OBUF[0]),
        .R(\<const0> ));
  FDRE \pedge_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\pedge[1]_i_1_n_0 ),
        .Q(pedge_OBUF[1]),
        .R(\<const0> ));
  FDRE \pedge_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\pedge[2]_i_1_n_0 ),
        .Q(pedge_OBUF[2]),
        .R(\<const0> ));
  FDRE \pedge_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\pedge[3]_i_1_n_0 ),
        .Q(pedge_OBUF[3]),
        .R(\<const0> ));
  FDRE \pedge_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\pedge[4]_i_1_n_0 ),
        .Q(pedge_OBUF[4]),
        .R(\<const0> ));
  FDRE \pedge_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\pedge[5]_i_1_n_0 ),
        .Q(pedge_OBUF[5]),
        .R(\<const0> ));
  FDRE \pedge_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\pedge[6]_i_1_n_0 ),
        .Q(pedge_OBUF[6]),
        .R(\<const0> ));
  FDRE \pedge_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\pedge[7]_i_1_n_0 ),
        .Q(pedge_OBUF[7]),
        .R(\<const0> ));
endmodule
