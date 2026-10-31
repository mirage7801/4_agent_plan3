// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:05:54 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_zog9g2h7/synth_netlist.v
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
    areset,
    load,
    ena,
    data,
    q);
  input clk;
  input areset;
  input load;
  input ena;
  input [3:0]data;
  output [3:0]q;

  wire VCC_1;
  wire areset;
  wire areset_IBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [3:0]data;
  wire [3:0]data_IBUF;
  wire ena;
  wire ena_IBUF;
  wire load;
  wire load_IBUF;
  wire [3:0]q;
  wire \q[0]_i_1_n_0 ;
  wire \q[1]_i_1_n_0 ;
  wire \q[2]_i_1_n_0 ;
  wire \q[3]_i_1_n_0 ;
  wire \q[3]_i_2_n_0 ;
  wire [3:0]q_OBUF;

  VCC VCC
       (.P(VCC_1));
  IBUF areset_IBUF_inst
       (.I(areset),
        .O(areset_IBUF));
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
  IBUF \data_IBUF[0]_inst 
       (.I(data[0]),
        .O(data_IBUF[0]));
  IBUF \data_IBUF[1]_inst 
       (.I(data[1]),
        .O(data_IBUF[1]));
  IBUF \data_IBUF[2]_inst 
       (.I(data[2]),
        .O(data_IBUF[2]));
  IBUF \data_IBUF[3]_inst 
       (.I(data[3]),
        .O(data_IBUF[3]));
  IBUF ena_IBUF_inst
       (.I(ena),
        .O(ena_IBUF));
  IBUF load_IBUF_inst
       (.I(load),
        .O(load_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \q[0]_i_1 
       (.I0(data_IBUF[0]),
        .I1(q_OBUF[1]),
        .I2(load_IBUF),
        .O(\q[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \q[1]_i_1 
       (.I0(data_IBUF[1]),
        .I1(q_OBUF[2]),
        .I2(load_IBUF),
        .O(\q[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \q[2]_i_1 
       (.I0(data_IBUF[2]),
        .I1(q_OBUF[3]),
        .I2(load_IBUF),
        .O(\q[2]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \q[3]_i_1 
       (.I0(ena_IBUF),
        .I1(load_IBUF),
        .O(\q[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \q[3]_i_2 
       (.I0(data_IBUF[3]),
        .I1(load_IBUF),
        .O(\q[3]_i_2_n_0 ));
  OBUF \q_OBUF[0]_inst 
       (.I(q_OBUF[0]),
        .O(q[0]));
  OBUF \q_OBUF[1]_inst 
       (.I(q_OBUF[1]),
        .O(q[1]));
  OBUF \q_OBUF[2]_inst 
       (.I(q_OBUF[2]),
        .O(q[2]));
  OBUF \q_OBUF[3]_inst 
       (.I(q_OBUF[3]),
        .O(q[3]));
  FDCE \q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[3]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(\q[0]_i_1_n_0 ),
        .Q(q_OBUF[0]));
  FDCE \q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[3]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(\q[1]_i_1_n_0 ),
        .Q(q_OBUF[1]));
  FDCE \q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[3]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(\q[2]_i_1_n_0 ),
        .Q(q_OBUF[2]));
  FDCE \q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[3]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(\q[3]_i_2_n_0 ),
        .Q(q_OBUF[3]));
endmodule
