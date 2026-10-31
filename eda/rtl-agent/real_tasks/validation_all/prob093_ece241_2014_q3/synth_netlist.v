// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:17:25 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_cw4ha__q/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (c,
    d,
    mux_in);
  input c;
  input d;
  output [3:0]mux_in;

  wire \<const0> ;
  wire c;
  wire c_IBUF;
  wire d;
  wire d_IBUF;
  wire [3:0]mux_in;
  wire [3:0]mux_in_OBUF;

  GND GND
       (.G(\<const0> ));
  IBUF c_IBUF_inst
       (.I(c),
        .O(c_IBUF));
  IBUF d_IBUF_inst
       (.I(d),
        .O(d_IBUF));
  OBUF \mux_in_OBUF[0]_inst 
       (.I(mux_in_OBUF[0]),
        .O(mux_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \mux_in_OBUF[0]_inst_i_1 
       (.I0(c_IBUF),
        .I1(d_IBUF),
        .O(mux_in_OBUF[0]));
  OBUF \mux_in_OBUF[1]_inst 
       (.I(\<const0> ),
        .O(mux_in[1]));
  OBUF \mux_in_OBUF[2]_inst 
       (.I(mux_in_OBUF[2]),
        .O(mux_in[2]));
  LUT1 #(
    .INIT(2'h1)) 
    \mux_in_OBUF[2]_inst_i_1 
       (.I0(d_IBUF),
        .O(mux_in_OBUF[2]));
  OBUF \mux_in_OBUF[3]_inst 
       (.I(mux_in_OBUF[3]),
        .O(mux_in[3]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \mux_in_OBUF[3]_inst_i_1 
       (.I0(c_IBUF),
        .I1(d_IBUF),
        .O(mux_in_OBUF[3]));
endmodule
