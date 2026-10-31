// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Thu Oct  8 00:15:03 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_4a_dfour/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (clock,
    a,
    p,
    q);
  input clock;
  input a;
  output p;
  output q;

  wire \<const0> ;
  wire \<const1> ;
  wire GND_2;
  wire VCC_2;
  wire a;
  wire a_IBUF;
  wire clock;
  wire clock_IBUF;
  wire clock_IBUF_BUFG;
  wire p;
  wire p_OBUF;
  wire q;
  wire q_OBUF;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  VCC VCC_1
       (.P(VCC_2));
  IBUF a_IBUF_inst
       (.I(a),
        .O(a_IBUF));
  (* XILINX_LEGACY_PRIM = "BUFG" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:CE" *) 
  BUFGCE #(
    .CE_TYPE("ASYNC"),
    .SIM_DEVICE("ULTRASCALE_PLUS")) 
    clock_IBUF_BUFG_inst
       (.CE(VCC_2),
        .I(clock_IBUF),
        .O(clock_IBUF_BUFG));
  IBUF clock_IBUF_inst
       (.I(clock),
        .O(clock_IBUF));
  OBUF p_OBUF_inst
       (.I(p_OBUF),
        .O(p));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    p_reg
       (.CLR(GND_2),
        .D(a_IBUF),
        .G(clock_IBUF_BUFG),
        .GE(VCC_2),
        .Q(p_OBUF));
  OBUF q_OBUF_inst
       (.I(q_OBUF),
        .O(q));
  FDRE #(
    .IS_C_INVERTED(1'b1)) 
    q_reg
       (.C(clock_IBUF_BUFG),
        .CE(\<const1> ),
        .D(a_IBUF),
        .Q(q_OBUF),
        .R(\<const0> ));
endmodule
