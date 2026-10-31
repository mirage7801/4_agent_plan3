// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 21:28:23 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_pmot54co/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (d,
    ena,
    q);
  input d;
  input ena;
  output q;

  wire GND_1;
  wire VCC_1;
  wire d;
  wire d_IBUF;
  wire ena;
  wire ena_IBUF;
  wire ena_IBUF_BUFG;
  wire q;
  wire q_OBUF;

  GND GND
       (.G(GND_1));
  VCC VCC
       (.P(VCC_1));
  IBUF d_IBUF_inst
       (.I(d),
        .O(d_IBUF));
  (* XILINX_LEGACY_PRIM = "BUFG" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:CE" *) 
  BUFGCE #(
    .CE_TYPE("ASYNC"),
    .SIM_DEVICE("ULTRASCALE_PLUS")) 
    ena_IBUF_BUFG_inst
       (.CE(VCC_1),
        .I(ena_IBUF),
        .O(ena_IBUF_BUFG));
  IBUF ena_IBUF_inst
       (.I(ena),
        .O(ena_IBUF));
  OBUF q_OBUF_inst
       (.I(q_OBUF),
        .O(q));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    q_reg
       (.CLR(GND_1),
        .D(d_IBUF),
        .G(ena_IBUF_BUFG),
        .GE(VCC_1),
        .Q(q_OBUF));
endmodule
