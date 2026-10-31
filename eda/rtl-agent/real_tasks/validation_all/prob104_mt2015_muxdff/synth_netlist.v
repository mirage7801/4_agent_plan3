// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:27:40 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_6y65lqzd/synth_netlist.v
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
    L,
    q_in,
    r_in,
    Q);
  input clk;
  input L;
  input q_in;
  input r_in;
  output Q;

  wire \<const0> ;
  wire \<const1> ;
  wire L;
  wire L_IBUF;
  wire Q;
  wire Q_OBUF;
  wire Q_i_1_n_0;
  wire VCC_2;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire q_in;
  wire q_in_IBUF;
  wire r_in;
  wire r_in_IBUF;

  GND GND
       (.G(\<const0> ));
  IBUF L_IBUF_inst
       (.I(L),
        .O(L_IBUF));
  OBUF Q_OBUF_inst
       (.I(Q_OBUF),
        .O(Q));
  LUT3 #(
    .INIT(8'hAC)) 
    Q_i_1
       (.I0(r_in_IBUF),
        .I1(q_in_IBUF),
        .I2(L_IBUF),
        .O(Q_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    Q_reg
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
  IBUF q_in_IBUF_inst
       (.I(q_in),
        .O(q_in_IBUF));
  IBUF r_in_IBUF_inst
       (.I(r_in),
        .O(r_in_IBUF));
endmodule
