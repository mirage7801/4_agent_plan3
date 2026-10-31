// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:16:48 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_zziqmt0z/synth_netlist.v
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
    j,
    k,
    Q);
  input clk;
  input j;
  input k;
  output Q;

  wire \<const0> ;
  wire \<const1> ;
  wire Q;
  wire Q_OBUF;
  wire Q_i_1_n_0;
  wire VCC_2;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire j;
  wire j_IBUF;
  wire k;
  wire k_IBUF;

  GND GND
       (.G(\<const0> ));
  OBUF Q_OBUF_inst
       (.I(Q_OBUF),
        .O(Q));
  LUT3 #(
    .INIT(8'h3A)) 
    Q_i_1
       (.I0(j_IBUF),
        .I1(k_IBUF),
        .I2(Q_OBUF),
        .O(Q_i_1_n_0));
  FDRE Q_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(Q_i_1_n_0),
        .Q(Q_OBUF),
        .R(\<const0> ));
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
  IBUF j_IBUF_inst
       (.I(j),
        .O(j_IBUF));
  IBUF k_IBUF_inst
       (.I(k),
        .O(k_IBUF));
endmodule
