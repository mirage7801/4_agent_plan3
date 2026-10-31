// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:48:05 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_d98ui5dr/synth_netlist.v
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
    train_valid,
    train_taken,
    state);
  input clk;
  input areset;
  input train_valid;
  input train_taken;
  output [1:0]state;

  wire VCC_1;
  wire areset;
  wire areset_IBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [1:0]state;
  wire \state[0]_i_1_n_0 ;
  wire \state[1]_i_1_n_0 ;
  wire \state[1]_i_2_n_0 ;
  wire [1:0]state_OBUF;
  wire train_taken;
  wire train_taken_IBUF;
  wire train_valid;
  wire train_valid_IBUF;

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
  LUT1 #(
    .INIT(2'h1)) 
    \state[0]_i_1 
       (.I0(state_OBUF[0]),
        .O(\state[0]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h2AA8)) 
    \state[1]_i_1 
       (.I0(train_valid_IBUF),
        .I1(state_OBUF[0]),
        .I2(state_OBUF[1]),
        .I3(train_taken_IBUF),
        .O(\state[1]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hE9)) 
    \state[1]_i_2 
       (.I0(state_OBUF[0]),
        .I1(state_OBUF[1]),
        .I2(train_taken_IBUF),
        .O(\state[1]_i_2_n_0 ));
  OBUF \state_OBUF[0]_inst 
       (.I(state_OBUF[0]),
        .O(state[0]));
  OBUF \state_OBUF[1]_inst 
       (.I(state_OBUF[1]),
        .O(state[1]));
  FDPE \state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\state[1]_i_1_n_0 ),
        .D(\state[0]_i_1_n_0 ),
        .PRE(areset_IBUF),
        .Q(state_OBUF[0]));
  FDCE \state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\state[1]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(\state[1]_i_2_n_0 ),
        .Q(state_OBUF[1]));
  IBUF train_taken_IBUF_inst
       (.I(train_taken),
        .O(train_taken_IBUF));
  IBUF train_valid_IBUF_inst
       (.I(train_valid),
        .O(train_valid_IBUF));
endmodule
