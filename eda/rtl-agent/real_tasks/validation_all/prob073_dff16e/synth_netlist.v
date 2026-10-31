// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:44:33 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_6ndtb58n/synth_netlist.v
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
    resetn,
    byteena,
    d,
    q);
  input clk;
  input resetn;
  input [1:0]byteena;
  input [15:0]d;
  output [15:0]q;

  wire VCC_1;
  wire [1:0]byteena;
  wire [1:0]byteena_IBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [15:0]d;
  wire [15:0]d_IBUF;
  wire p_0_in;
  wire [15:0]q;
  wire [15:0]q_OBUF;
  wire resetn;
  wire resetn_IBUF;

  VCC VCC
       (.P(VCC_1));
  IBUF \byteena_IBUF[0]_inst 
       (.I(byteena[0]),
        .O(byteena_IBUF[0]));
  IBUF \byteena_IBUF[1]_inst 
       (.I(byteena[1]),
        .O(byteena_IBUF[1]));
  (* XILINX_LEGACY_PRIM = "BUFG" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:CE" *) 
  BUFGCE #(
    .CE_TYPE("ASYNC"),
    .SIM_DEVICE("ULTRASCALE_PLUS")) 
    clk_IBUF_BUFG_inst
       (.CE(VCC_1),
        .I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  IBUF \d_IBUF[0]_inst 
       (.I(d[0]),
        .O(d_IBUF[0]));
  IBUF \d_IBUF[10]_inst 
       (.I(d[10]),
        .O(d_IBUF[10]));
  IBUF \d_IBUF[11]_inst 
       (.I(d[11]),
        .O(d_IBUF[11]));
  IBUF \d_IBUF[12]_inst 
       (.I(d[12]),
        .O(d_IBUF[12]));
  IBUF \d_IBUF[13]_inst 
       (.I(d[13]),
        .O(d_IBUF[13]));
  IBUF \d_IBUF[14]_inst 
       (.I(d[14]),
        .O(d_IBUF[14]));
  IBUF \d_IBUF[15]_inst 
       (.I(d[15]),
        .O(d_IBUF[15]));
  IBUF \d_IBUF[1]_inst 
       (.I(d[1]),
        .O(d_IBUF[1]));
  IBUF \d_IBUF[2]_inst 
       (.I(d[2]),
        .O(d_IBUF[2]));
  IBUF \d_IBUF[3]_inst 
       (.I(d[3]),
        .O(d_IBUF[3]));
  IBUF \d_IBUF[4]_inst 
       (.I(d[4]),
        .O(d_IBUF[4]));
  IBUF \d_IBUF[5]_inst 
       (.I(d[5]),
        .O(d_IBUF[5]));
  IBUF \d_IBUF[6]_inst 
       (.I(d[6]),
        .O(d_IBUF[6]));
  IBUF \d_IBUF[7]_inst 
       (.I(d[7]),
        .O(d_IBUF[7]));
  IBUF \d_IBUF[8]_inst 
       (.I(d[8]),
        .O(d_IBUF[8]));
  IBUF \d_IBUF[9]_inst 
       (.I(d[9]),
        .O(d_IBUF[9]));
  LUT1 #(
    .INIT(2'h1)) 
    \q[15]_i_1 
       (.I0(resetn_IBUF),
        .O(p_0_in));
  OBUF \q_OBUF[0]_inst 
       (.I(q_OBUF[0]),
        .O(q[0]));
  OBUF \q_OBUF[10]_inst 
       (.I(q_OBUF[10]),
        .O(q[10]));
  OBUF \q_OBUF[11]_inst 
       (.I(q_OBUF[11]),
        .O(q[11]));
  OBUF \q_OBUF[12]_inst 
       (.I(q_OBUF[12]),
        .O(q[12]));
  OBUF \q_OBUF[13]_inst 
       (.I(q_OBUF[13]),
        .O(q[13]));
  OBUF \q_OBUF[14]_inst 
       (.I(q_OBUF[14]),
        .O(q[14]));
  OBUF \q_OBUF[15]_inst 
       (.I(q_OBUF[15]),
        .O(q[15]));
  OBUF \q_OBUF[1]_inst 
       (.I(q_OBUF[1]),
        .O(q[1]));
  OBUF \q_OBUF[2]_inst 
       (.I(q_OBUF[2]),
        .O(q[2]));
  OBUF \q_OBUF[3]_inst 
       (.I(q_OBUF[3]),
        .O(q[3]));
  OBUF \q_OBUF[4]_inst 
       (.I(q_OBUF[4]),
        .O(q[4]));
  OBUF \q_OBUF[5]_inst 
       (.I(q_OBUF[5]),
        .O(q[5]));
  OBUF \q_OBUF[6]_inst 
       (.I(q_OBUF[6]),
        .O(q[6]));
  OBUF \q_OBUF[7]_inst 
       (.I(q_OBUF[7]),
        .O(q[7]));
  OBUF \q_OBUF[8]_inst 
       (.I(q_OBUF[8]),
        .O(q[8]));
  OBUF \q_OBUF[9]_inst 
       (.I(q_OBUF[9]),
        .O(q[9]));
  FDRE \q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(byteena_IBUF[0]),
        .D(d_IBUF[0]),
        .Q(q_OBUF[0]),
        .R(p_0_in));
  FDRE \q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(byteena_IBUF[1]),
        .D(d_IBUF[10]),
        .Q(q_OBUF[10]),
        .R(p_0_in));
  FDRE \q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(byteena_IBUF[1]),
        .D(d_IBUF[11]),
        .Q(q_OBUF[11]),
        .R(p_0_in));
  FDRE \q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(byteena_IBUF[1]),
        .D(d_IBUF[12]),
        .Q(q_OBUF[12]),
        .R(p_0_in));
  FDRE \q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(byteena_IBUF[1]),
        .D(d_IBUF[13]),
        .Q(q_OBUF[13]),
        .R(p_0_in));
  FDRE \q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(byteena_IBUF[1]),
        .D(d_IBUF[14]),
        .Q(q_OBUF[14]),
        .R(p_0_in));
  FDRE \q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(byteena_IBUF[1]),
        .D(d_IBUF[15]),
        .Q(q_OBUF[15]),
        .R(p_0_in));
  FDRE \q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(byteena_IBUF[0]),
        .D(d_IBUF[1]),
        .Q(q_OBUF[1]),
        .R(p_0_in));
  FDRE \q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(byteena_IBUF[0]),
        .D(d_IBUF[2]),
        .Q(q_OBUF[2]),
        .R(p_0_in));
  FDRE \q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(byteena_IBUF[0]),
        .D(d_IBUF[3]),
        .Q(q_OBUF[3]),
        .R(p_0_in));
  FDRE \q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(byteena_IBUF[0]),
        .D(d_IBUF[4]),
        .Q(q_OBUF[4]),
        .R(p_0_in));
  FDRE \q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(byteena_IBUF[0]),
        .D(d_IBUF[5]),
        .Q(q_OBUF[5]),
        .R(p_0_in));
  FDRE \q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(byteena_IBUF[0]),
        .D(d_IBUF[6]),
        .Q(q_OBUF[6]),
        .R(p_0_in));
  FDRE \q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(byteena_IBUF[0]),
        .D(d_IBUF[7]),
        .Q(q_OBUF[7]),
        .R(p_0_in));
  FDRE \q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(byteena_IBUF[1]),
        .D(d_IBUF[8]),
        .Q(q_OBUF[8]),
        .R(p_0_in));
  FDRE \q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(byteena_IBUF[1]),
        .D(d_IBUF[9]),
        .Q(q_OBUF[9]),
        .R(p_0_in));
  IBUF resetn_IBUF_inst
       (.I(resetn),
        .O(resetn_IBUF));
endmodule
