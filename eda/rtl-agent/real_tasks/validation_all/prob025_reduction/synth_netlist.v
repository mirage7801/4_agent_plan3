// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 21:22:51 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_id8w2_t7/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (in,
    parity);
  input [7:0]in;
  output parity;

  wire [7:0]in;
  wire [7:0]in_IBUF;
  wire parity;
  wire parity_OBUF;
  wire parity_OBUF_inst_i_2_n_0;

  IBUF \in_IBUF[0]_inst 
       (.I(in[0]),
        .O(in_IBUF[0]));
  IBUF \in_IBUF[1]_inst 
       (.I(in[1]),
        .O(in_IBUF[1]));
  IBUF \in_IBUF[2]_inst 
       (.I(in[2]),
        .O(in_IBUF[2]));
  IBUF \in_IBUF[3]_inst 
       (.I(in[3]),
        .O(in_IBUF[3]));
  IBUF \in_IBUF[4]_inst 
       (.I(in[4]),
        .O(in_IBUF[4]));
  IBUF \in_IBUF[5]_inst 
       (.I(in[5]),
        .O(in_IBUF[5]));
  IBUF \in_IBUF[6]_inst 
       (.I(in[6]),
        .O(in_IBUF[6]));
  IBUF \in_IBUF[7]_inst 
       (.I(in[7]),
        .O(in_IBUF[7]));
  OBUF parity_OBUF_inst
       (.I(parity_OBUF),
        .O(parity));
  LUT5 #(
    .INIT(32'h96696996)) 
    parity_OBUF_inst_i_1
       (.I0(in_IBUF[5]),
        .I1(in_IBUF[4]),
        .I2(in_IBUF[7]),
        .I3(in_IBUF[6]),
        .I4(parity_OBUF_inst_i_2_n_0),
        .O(parity_OBUF));
  LUT4 #(
    .INIT(16'h6996)) 
    parity_OBUF_inst_i_2
       (.I0(in_IBUF[2]),
        .I1(in_IBUF[3]),
        .I2(in_IBUF[0]),
        .I3(in_IBUF[1]),
        .O(parity_OBUF_inst_i_2_n_0));
endmodule
