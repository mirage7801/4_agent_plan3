// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:31:02 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_vopdiedk/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (a,
    b,
    c,
    d,
    e,
    f,
    w,
    x,
    y,
    z);
  input [4:0]a;
  input [4:0]b;
  input [4:0]c;
  input [4:0]d;
  input [4:0]e;
  input [4:0]f;
  output [7:0]w;
  output [7:0]x;
  output [7:0]y;
  output [7:0]z;

  wire \<const1> ;
  wire [4:0]a;
  wire [4:0]b;
  wire [4:0]c;
  wire [4:0]d;
  wire [4:0]e;
  wire [4:0]f;
  wire [7:0]w;
  wire [7:0]w_OBUF;
  wire [7:0]x;
  wire [7:0]x_OBUF;
  wire [7:0]y;
  wire [7:0]y_OBUF;
  wire [7:0]z;
  wire [7:2]z_OBUF;

  VCC VCC
       (.P(\<const1> ));
  IBUF \a_IBUF[0]_inst 
       (.I(a[0]),
        .O(w_OBUF[3]));
  IBUF \a_IBUF[1]_inst 
       (.I(a[1]),
        .O(w_OBUF[4]));
  IBUF \a_IBUF[2]_inst 
       (.I(a[2]),
        .O(w_OBUF[5]));
  IBUF \a_IBUF[3]_inst 
       (.I(a[3]),
        .O(w_OBUF[6]));
  IBUF \a_IBUF[4]_inst 
       (.I(a[4]),
        .O(w_OBUF[7]));
  IBUF \b_IBUF[0]_inst 
       (.I(b[0]),
        .O(x_OBUF[6]));
  IBUF \b_IBUF[1]_inst 
       (.I(b[1]),
        .O(x_OBUF[7]));
  IBUF \b_IBUF[2]_inst 
       (.I(b[2]),
        .O(w_OBUF[0]));
  IBUF \b_IBUF[3]_inst 
       (.I(b[3]),
        .O(w_OBUF[1]));
  IBUF \b_IBUF[4]_inst 
       (.I(b[4]),
        .O(w_OBUF[2]));
  IBUF \c_IBUF[0]_inst 
       (.I(c[0]),
        .O(x_OBUF[1]));
  IBUF \c_IBUF[1]_inst 
       (.I(c[1]),
        .O(x_OBUF[2]));
  IBUF \c_IBUF[2]_inst 
       (.I(c[2]),
        .O(x_OBUF[3]));
  IBUF \c_IBUF[3]_inst 
       (.I(c[3]),
        .O(x_OBUF[4]));
  IBUF \c_IBUF[4]_inst 
       (.I(c[4]),
        .O(x_OBUF[5]));
  IBUF \d_IBUF[0]_inst 
       (.I(d[0]),
        .O(y_OBUF[4]));
  IBUF \d_IBUF[1]_inst 
       (.I(d[1]),
        .O(y_OBUF[5]));
  IBUF \d_IBUF[2]_inst 
       (.I(d[2]),
        .O(y_OBUF[6]));
  IBUF \d_IBUF[3]_inst 
       (.I(d[3]),
        .O(y_OBUF[7]));
  IBUF \d_IBUF[4]_inst 
       (.I(d[4]),
        .O(x_OBUF[0]));
  IBUF \e_IBUF[0]_inst 
       (.I(e[0]),
        .O(z_OBUF[7]));
  IBUF \e_IBUF[1]_inst 
       (.I(e[1]),
        .O(y_OBUF[0]));
  IBUF \e_IBUF[2]_inst 
       (.I(e[2]),
        .O(y_OBUF[1]));
  IBUF \e_IBUF[3]_inst 
       (.I(e[3]),
        .O(y_OBUF[2]));
  IBUF \e_IBUF[4]_inst 
       (.I(e[4]),
        .O(y_OBUF[3]));
  IBUF \f_IBUF[0]_inst 
       (.I(f[0]),
        .O(z_OBUF[2]));
  IBUF \f_IBUF[1]_inst 
       (.I(f[1]),
        .O(z_OBUF[3]));
  IBUF \f_IBUF[2]_inst 
       (.I(f[2]),
        .O(z_OBUF[4]));
  IBUF \f_IBUF[3]_inst 
       (.I(f[3]),
        .O(z_OBUF[5]));
  IBUF \f_IBUF[4]_inst 
       (.I(f[4]),
        .O(z_OBUF[6]));
  OBUF \w_OBUF[0]_inst 
       (.I(w_OBUF[0]),
        .O(w[0]));
  OBUF \w_OBUF[1]_inst 
       (.I(w_OBUF[1]),
        .O(w[1]));
  OBUF \w_OBUF[2]_inst 
       (.I(w_OBUF[2]),
        .O(w[2]));
  OBUF \w_OBUF[3]_inst 
       (.I(w_OBUF[3]),
        .O(w[3]));
  OBUF \w_OBUF[4]_inst 
       (.I(w_OBUF[4]),
        .O(w[4]));
  OBUF \w_OBUF[5]_inst 
       (.I(w_OBUF[5]),
        .O(w[5]));
  OBUF \w_OBUF[6]_inst 
       (.I(w_OBUF[6]),
        .O(w[6]));
  OBUF \w_OBUF[7]_inst 
       (.I(w_OBUF[7]),
        .O(w[7]));
  OBUF \x_OBUF[0]_inst 
       (.I(x_OBUF[0]),
        .O(x[0]));
  OBUF \x_OBUF[1]_inst 
       (.I(x_OBUF[1]),
        .O(x[1]));
  OBUF \x_OBUF[2]_inst 
       (.I(x_OBUF[2]),
        .O(x[2]));
  OBUF \x_OBUF[3]_inst 
       (.I(x_OBUF[3]),
        .O(x[3]));
  OBUF \x_OBUF[4]_inst 
       (.I(x_OBUF[4]),
        .O(x[4]));
  OBUF \x_OBUF[5]_inst 
       (.I(x_OBUF[5]),
        .O(x[5]));
  OBUF \x_OBUF[6]_inst 
       (.I(x_OBUF[6]),
        .O(x[6]));
  OBUF \x_OBUF[7]_inst 
       (.I(x_OBUF[7]),
        .O(x[7]));
  OBUF \y_OBUF[0]_inst 
       (.I(y_OBUF[0]),
        .O(y[0]));
  OBUF \y_OBUF[1]_inst 
       (.I(y_OBUF[1]),
        .O(y[1]));
  OBUF \y_OBUF[2]_inst 
       (.I(y_OBUF[2]),
        .O(y[2]));
  OBUF \y_OBUF[3]_inst 
       (.I(y_OBUF[3]),
        .O(y[3]));
  OBUF \y_OBUF[4]_inst 
       (.I(y_OBUF[4]),
        .O(y[4]));
  OBUF \y_OBUF[5]_inst 
       (.I(y_OBUF[5]),
        .O(y[5]));
  OBUF \y_OBUF[6]_inst 
       (.I(y_OBUF[6]),
        .O(y[6]));
  OBUF \y_OBUF[7]_inst 
       (.I(y_OBUF[7]),
        .O(y[7]));
  OBUF \z_OBUF[0]_inst 
       (.I(\<const1> ),
        .O(z[0]));
  OBUF \z_OBUF[1]_inst 
       (.I(\<const1> ),
        .O(z[1]));
  OBUF \z_OBUF[2]_inst 
       (.I(z_OBUF[2]),
        .O(z[2]));
  OBUF \z_OBUF[3]_inst 
       (.I(z_OBUF[3]),
        .O(z[3]));
  OBUF \z_OBUF[4]_inst 
       (.I(z_OBUF[4]),
        .O(z[4]));
  OBUF \z_OBUF[5]_inst 
       (.I(z_OBUF[5]),
        .O(z[5]));
  OBUF \z_OBUF[6]_inst 
       (.I(z_OBUF[6]),
        .O(z[6]));
  OBUF \z_OBUF[7]_inst 
       (.I(z_OBUF[7]),
        .O(z[7]));
endmodule
