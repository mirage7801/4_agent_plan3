// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:04:09 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_9ktc1qwc/synth_netlist.v
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
    enable,
    S,
    A,
    B,
    C,
    Z);
  input clk;
  input enable;
  input S;
  input A;
  input B;
  input C;
  output Z;

  wire \<const0> ;
  wire A;
  wire A_IBUF;
  wire B;
  wire B_IBUF;
  wire C;
  wire C_IBUF;
  wire S;
  wire S_IBUF;
  wire VCC_1;
  wire Z;
  wire Z_OBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire enable;
  wire enable_IBUF;

  IBUF A_IBUF_inst
       (.I(A),
        .O(A_IBUF));
  IBUF B_IBUF_inst
       (.I(B),
        .O(B_IBUF));
  IBUF C_IBUF_inst
       (.I(C),
        .O(C_IBUF));
  GND GND
       (.G(\<const0> ));
  IBUF S_IBUF_inst
       (.I(S),
        .O(S_IBUF));
  VCC VCC
       (.P(VCC_1));
  OBUF Z_OBUF_inst
       (.I(Z_OBUF),
        .O(Z));
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
  IBUF enable_IBUF_inst
       (.I(enable),
        .O(enable_IBUF));
  (* srl_bus_name = "\\q_reg " *) 
  (* srl_name = "\\q_reg[0]_srl8 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \q_reg[0]_srl8 
       (.A0(C_IBUF),
        .A1(B_IBUF),
        .A2(A_IBUF),
        .A3(\<const0> ),
        .CE(enable_IBUF),
        .CLK(clk_IBUF_BUFG),
        .D(S_IBUF),
        .Q(Z_OBUF));
endmodule
