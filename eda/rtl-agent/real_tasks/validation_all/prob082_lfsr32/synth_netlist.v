// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:00:41 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_y8z9sae0/synth_netlist.v
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
    reset,
    q);
  input clk;
  input reset;
  output [31:0]q;

  wire \<const1> ;
  wire VCC_2;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [31:0]q;
  wire [31:0]q_OBUF;
  wire [21:0]q_next;
  wire reset;
  wire reset_IBUF;

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
  LUT2 #(
    .INIT(4'h6)) 
    \q[0]_i_1 
       (.I0(q_OBUF[0]),
        .I1(q_OBUF[1]),
        .O(q_next[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \q[1]_i_1 
       (.I0(q_OBUF[0]),
        .I1(q_OBUF[2]),
        .O(q_next[1]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \q[21]_i_1 
       (.I0(q_OBUF[0]),
        .I1(q_OBUF[22]),
        .O(q_next[21]));
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
  OBUF \q_OBUF[16]_inst 
       (.I(q_OBUF[16]),
        .O(q[16]));
  OBUF \q_OBUF[17]_inst 
       (.I(q_OBUF[17]),
        .O(q[17]));
  OBUF \q_OBUF[18]_inst 
       (.I(q_OBUF[18]),
        .O(q[18]));
  OBUF \q_OBUF[19]_inst 
       (.I(q_OBUF[19]),
        .O(q[19]));
  OBUF \q_OBUF[1]_inst 
       (.I(q_OBUF[1]),
        .O(q[1]));
  OBUF \q_OBUF[20]_inst 
       (.I(q_OBUF[20]),
        .O(q[20]));
  OBUF \q_OBUF[21]_inst 
       (.I(q_OBUF[21]),
        .O(q[21]));
  OBUF \q_OBUF[22]_inst 
       (.I(q_OBUF[22]),
        .O(q[22]));
  OBUF \q_OBUF[23]_inst 
       (.I(q_OBUF[23]),
        .O(q[23]));
  OBUF \q_OBUF[24]_inst 
       (.I(q_OBUF[24]),
        .O(q[24]));
  OBUF \q_OBUF[25]_inst 
       (.I(q_OBUF[25]),
        .O(q[25]));
  OBUF \q_OBUF[26]_inst 
       (.I(q_OBUF[26]),
        .O(q[26]));
  OBUF \q_OBUF[27]_inst 
       (.I(q_OBUF[27]),
        .O(q[27]));
  OBUF \q_OBUF[28]_inst 
       (.I(q_OBUF[28]),
        .O(q[28]));
  OBUF \q_OBUF[29]_inst 
       (.I(q_OBUF[29]),
        .O(q[29]));
  OBUF \q_OBUF[2]_inst 
       (.I(q_OBUF[2]),
        .O(q[2]));
  OBUF \q_OBUF[30]_inst 
       (.I(q_OBUF[30]),
        .O(q[30]));
  OBUF \q_OBUF[31]_inst 
       (.I(q_OBUF[31]),
        .O(q[31]));
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
  FDSE \q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_next[0]),
        .Q(q_OBUF[0]),
        .S(reset_IBUF));
  FDRE \q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[11]),
        .Q(q_OBUF[10]),
        .R(reset_IBUF));
  FDRE \q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[12]),
        .Q(q_OBUF[11]),
        .R(reset_IBUF));
  FDRE \q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[13]),
        .Q(q_OBUF[12]),
        .R(reset_IBUF));
  FDRE \q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[14]),
        .Q(q_OBUF[13]),
        .R(reset_IBUF));
  FDRE \q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[15]),
        .Q(q_OBUF[14]),
        .R(reset_IBUF));
  FDRE \q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[16]),
        .Q(q_OBUF[15]),
        .R(reset_IBUF));
  FDRE \q_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[17]),
        .Q(q_OBUF[16]),
        .R(reset_IBUF));
  FDRE \q_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[18]),
        .Q(q_OBUF[17]),
        .R(reset_IBUF));
  FDRE \q_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[19]),
        .Q(q_OBUF[18]),
        .R(reset_IBUF));
  FDRE \q_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[20]),
        .Q(q_OBUF[19]),
        .R(reset_IBUF));
  FDRE \q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_next[1]),
        .Q(q_OBUF[1]),
        .R(reset_IBUF));
  FDRE \q_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[21]),
        .Q(q_OBUF[20]),
        .R(reset_IBUF));
  FDRE \q_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_next[21]),
        .Q(q_OBUF[21]),
        .R(reset_IBUF));
  FDRE \q_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[23]),
        .Q(q_OBUF[22]),
        .R(reset_IBUF));
  FDRE \q_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[24]),
        .Q(q_OBUF[23]),
        .R(reset_IBUF));
  FDRE \q_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[25]),
        .Q(q_OBUF[24]),
        .R(reset_IBUF));
  FDRE \q_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[26]),
        .Q(q_OBUF[25]),
        .R(reset_IBUF));
  FDRE \q_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[27]),
        .Q(q_OBUF[26]),
        .R(reset_IBUF));
  FDRE \q_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[28]),
        .Q(q_OBUF[27]),
        .R(reset_IBUF));
  FDRE \q_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[29]),
        .Q(q_OBUF[28]),
        .R(reset_IBUF));
  FDRE \q_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[30]),
        .Q(q_OBUF[29]),
        .R(reset_IBUF));
  FDRE \q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[3]),
        .Q(q_OBUF[2]),
        .R(reset_IBUF));
  FDRE \q_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[31]),
        .Q(q_OBUF[30]),
        .R(reset_IBUF));
  FDRE \q_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[0]),
        .Q(q_OBUF[31]),
        .R(reset_IBUF));
  FDRE \q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[4]),
        .Q(q_OBUF[3]),
        .R(reset_IBUF));
  FDRE \q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[5]),
        .Q(q_OBUF[4]),
        .R(reset_IBUF));
  FDRE \q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[6]),
        .Q(q_OBUF[5]),
        .R(reset_IBUF));
  FDRE \q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[7]),
        .Q(q_OBUF[6]),
        .R(reset_IBUF));
  FDRE \q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[8]),
        .Q(q_OBUF[7]),
        .R(reset_IBUF));
  FDRE \q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[9]),
        .Q(q_OBUF[8]),
        .R(reset_IBUF));
  FDRE \q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(q_OBUF[10]),
        .Q(q_OBUF[9]),
        .R(reset_IBUF));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
endmodule
