// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:25:44 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_x9ab2t5m/synth_netlist.v
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
    w,
    R,
    E,
    L,
    Q);
  input clk;
  input w;
  input R;
  input E;
  input L;
  output Q;

  wire \<const0> ;
  wire E;
  wire E_IBUF;
  wire L;
  wire L_IBUF;
  wire Q;
  wire Q_OBUF;
  wire Q_i_1_n_0;
  wire Q_i_2_n_0;
  wire R;
  wire R_IBUF;
  wire VCC_1;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire w;
  wire w_IBUF;

  IBUF E_IBUF_inst
       (.I(E),
        .O(E_IBUF));
  GND GND
       (.G(\<const0> ));
  IBUF L_IBUF_inst
       (.I(L),
        .O(L_IBUF));
  OBUF Q_OBUF_inst
       (.I(Q_OBUF),
        .O(Q));
  LUT2 #(
    .INIT(4'hE)) 
    Q_i_1
       (.I0(E_IBUF),
        .I1(L_IBUF),
        .O(Q_i_1_n_0));
  LUT3 #(
    .INIT(8'hAC)) 
    Q_i_2
       (.I0(R_IBUF),
        .I1(w_IBUF),
        .I2(L_IBUF),
        .O(Q_i_2_n_0));
  FDRE Q_reg
       (.C(clk_IBUF_BUFG),
        .CE(Q_i_1_n_0),
        .D(Q_i_2_n_0),
        .Q(Q_OBUF),
        .R(\<const0> ));
  IBUF R_IBUF_inst
       (.I(R),
        .O(R_IBUF));
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
  IBUF w_IBUF_inst
       (.I(w),
        .O(w_IBUF));
endmodule
