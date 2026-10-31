// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:36:16 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_knp37efg/synth_netlist.v
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
    slowena,
    reset,
    q);
  input clk;
  input slowena;
  input reset;
  output [3:0]q;

  wire VCC_1;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [3:0]q;
  wire \q[0]_i_1_n_0 ;
  wire \q[1]_i_1_n_0 ;
  wire \q[2]_i_1_n_0 ;
  wire \q[3]_i_1_n_0 ;
  wire [3:0]q_OBUF;
  wire reset;
  wire reset_IBUF;
  wire slowena;
  wire slowena_IBUF;

  VCC VCC
       (.P(VCC_1));
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
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \q[0]_i_1 
       (.I0(q_OBUF[0]),
        .O(\q[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h0FB0)) 
    \q[1]_i_1 
       (.I0(q_OBUF[2]),
        .I1(q_OBUF[3]),
        .I2(q_OBUF[0]),
        .I3(q_OBUF[1]),
        .O(\q[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \q[2]_i_1 
       (.I0(q_OBUF[2]),
        .I1(q_OBUF[0]),
        .I2(q_OBUF[1]),
        .O(\q[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h6C8C)) 
    \q[3]_i_1 
       (.I0(q_OBUF[2]),
        .I1(q_OBUF[3]),
        .I2(q_OBUF[0]),
        .I3(q_OBUF[1]),
        .O(\q[3]_i_1_n_0 ));
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
  FDRE \q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(slowena_IBUF),
        .D(\q[0]_i_1_n_0 ),
        .Q(q_OBUF[0]),
        .R(reset_IBUF));
  FDRE \q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(slowena_IBUF),
        .D(\q[1]_i_1_n_0 ),
        .Q(q_OBUF[1]),
        .R(reset_IBUF));
  FDRE \q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(slowena_IBUF),
        .D(\q[2]_i_1_n_0 ),
        .Q(q_OBUF[2]),
        .R(reset_IBUF));
  FDRE \q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(slowena_IBUF),
        .D(\q[3]_i_1_n_0 ),
        .Q(q_OBUF[3]),
        .R(reset_IBUF));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  IBUF slowena_IBUF_inst
       (.I(slowena),
        .O(slowena_IBUF));
endmodule
