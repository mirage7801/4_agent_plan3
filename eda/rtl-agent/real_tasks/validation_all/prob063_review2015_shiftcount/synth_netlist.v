// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:29:14 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_i6dwbpzh/synth_netlist.v
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
    shift_ena,
    count_ena,
    data,
    q);
  input clk;
  input shift_ena;
  input count_ena;
  input data;
  output [3:0]q;

  wire \<const0> ;
  wire VCC_1;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire count_ena;
  wire count_ena_IBUF;
  wire data;
  wire data_IBUF;
  wire [3:0]p_0_in;
  wire [3:0]q;
  wire \q[3]_i_1_n_0 ;
  wire [3:0]q_OBUF;
  wire shift_ena;
  wire shift_ena_IBUF;

  GND GND
       (.G(\<const0> ));
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
  IBUF count_ena_IBUF_inst
       (.I(count_ena),
        .O(count_ena_IBUF));
  IBUF data_IBUF_inst
       (.I(data),
        .O(data_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h8B)) 
    \q[0]_i_1 
       (.I0(data_IBUF),
        .I1(shift_ena_IBUF),
        .I2(q_OBUF[0]),
        .O(p_0_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hC9)) 
    \q[1]_i_1 
       (.I0(shift_ena_IBUF),
        .I1(q_OBUF[0]),
        .I2(q_OBUF[1]),
        .O(p_0_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hDC89)) 
    \q[2]_i_1 
       (.I0(shift_ena_IBUF),
        .I1(q_OBUF[1]),
        .I2(q_OBUF[0]),
        .I3(q_OBUF[2]),
        .O(p_0_in[2]));
  LUT2 #(
    .INIT(4'hE)) 
    \q[3]_i_1 
       (.I0(count_ena_IBUF),
        .I1(shift_ena_IBUF),
        .O(\q[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hDDDC8889)) 
    \q[3]_i_2 
       (.I0(shift_ena_IBUF),
        .I1(q_OBUF[2]),
        .I2(q_OBUF[0]),
        .I3(q_OBUF[1]),
        .I4(q_OBUF[3]),
        .O(p_0_in[3]));
  OBUF \q_OBUF[0]_inst 
       (.I(q_OBUF[0]),
        .O(q[0]));
  OBUF \q_OBUF[1]_inst 
       (.I(q_OBUF[1]),
        .O(q[1]));
  OBUF \q_OBUF[2]_inst 
       (.I(q_OBUF[2]),
        .O(q[2]));
  OBUF \q_OBUF[3]_inst 
       (.I(q_OBUF[3]),
        .O(q[3]));
  FDRE \q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[3]_i_1_n_0 ),
        .D(p_0_in[0]),
        .Q(q_OBUF[0]),
        .R(\<const0> ));
  FDRE \q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[3]_i_1_n_0 ),
        .D(p_0_in[1]),
        .Q(q_OBUF[1]),
        .R(\<const0> ));
  FDRE \q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[3]_i_1_n_0 ),
        .D(p_0_in[2]),
        .Q(q_OBUF[2]),
        .R(\<const0> ));
  FDRE \q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[3]_i_1_n_0 ),
        .D(p_0_in[3]),
        .Q(q_OBUF[3]),
        .R(\<const0> ));
  IBUF shift_ena_IBUF_inst
       (.I(shift_ena),
        .O(shift_ena_IBUF));
endmodule
