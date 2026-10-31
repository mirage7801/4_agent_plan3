// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Sun Oct 25 16:36:48 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_l7ziyxm2/synth_netlist.v
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
    load,
    data,
    tc);
  input clk;
  input load;
  input [9:0]data;
  output tc;

  wire \<const0> ;
  wire VCC_1;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire \count_value[5]_i_2_n_0 ;
  wire \count_value[9]_i_1_n_0 ;
  wire \count_value[9]_i_3_n_0 ;
  wire [9:0]count_value_reg;
  wire [9:0]data;
  wire [9:0]data_IBUF;
  wire load;
  wire load_IBUF;
  wire [9:0]p_0_in;
  wire tc;
  wire tc_OBUF;
  wire tc_OBUF_inst_i_2_n_0;

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
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h8B)) 
    \count_value[0]_i_1 
       (.I0(data_IBUF[0]),
        .I1(load_IBUF),
        .I2(count_value_reg[0]),
        .O(p_0_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hB88B)) 
    \count_value[1]_i_1 
       (.I0(data_IBUF[1]),
        .I1(load_IBUF),
        .I2(count_value_reg[0]),
        .I3(count_value_reg[1]),
        .O(p_0_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hBBB8888B)) 
    \count_value[2]_i_1 
       (.I0(data_IBUF[2]),
        .I1(load_IBUF),
        .I2(count_value_reg[0]),
        .I3(count_value_reg[1]),
        .I4(count_value_reg[2]),
        .O(p_0_in[2]));
  LUT6 #(
    .INIT(64'hBBBBBBB88888888B)) 
    \count_value[3]_i_1 
       (.I0(data_IBUF[3]),
        .I1(load_IBUF),
        .I2(count_value_reg[2]),
        .I3(count_value_reg[1]),
        .I4(count_value_reg[0]),
        .I5(count_value_reg[3]),
        .O(p_0_in[3]));
  LUT5 #(
    .INIT(32'hB8B8B88B)) 
    \count_value[4]_i_1 
       (.I0(data_IBUF[4]),
        .I1(load_IBUF),
        .I2(count_value_reg[4]),
        .I3(\count_value[5]_i_2_n_0 ),
        .I4(count_value_reg[3]),
        .O(p_0_in[4]));
  LUT6 #(
    .INIT(64'hB8B8B8B8B8B8B88B)) 
    \count_value[5]_i_1 
       (.I0(data_IBUF[5]),
        .I1(load_IBUF),
        .I2(count_value_reg[5]),
        .I3(count_value_reg[3]),
        .I4(count_value_reg[4]),
        .I5(\count_value[5]_i_2_n_0 ),
        .O(p_0_in[5]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \count_value[5]_i_2 
       (.I0(count_value_reg[2]),
        .I1(count_value_reg[1]),
        .I2(count_value_reg[0]),
        .O(\count_value[5]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h8BB8)) 
    \count_value[6]_i_1 
       (.I0(data_IBUF[6]),
        .I1(load_IBUF),
        .I2(count_value_reg[6]),
        .I3(tc_OBUF_inst_i_2_n_0),
        .O(p_0_in[6]));
  LUT5 #(
    .INIT(32'hB88BB8B8)) 
    \count_value[7]_i_1 
       (.I0(data_IBUF[7]),
        .I1(load_IBUF),
        .I2(count_value_reg[7]),
        .I3(count_value_reg[6]),
        .I4(tc_OBUF_inst_i_2_n_0),
        .O(p_0_in[7]));
  LUT6 #(
    .INIT(64'hB8B8B8B8B88BB8B8)) 
    \count_value[8]_i_1 
       (.I0(data_IBUF[8]),
        .I1(load_IBUF),
        .I2(count_value_reg[8]),
        .I3(count_value_reg[7]),
        .I4(tc_OBUF_inst_i_2_n_0),
        .I5(count_value_reg[6]),
        .O(p_0_in[8]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFEFF)) 
    \count_value[9]_i_1 
       (.I0(load_IBUF),
        .I1(count_value_reg[9]),
        .I2(count_value_reg[7]),
        .I3(tc_OBUF_inst_i_2_n_0),
        .I4(count_value_reg[6]),
        .I5(count_value_reg[8]),
        .O(\count_value[9]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB88BB8B8)) 
    \count_value[9]_i_2 
       (.I0(data_IBUF[9]),
        .I1(load_IBUF),
        .I2(count_value_reg[9]),
        .I3(count_value_reg[8]),
        .I4(\count_value[9]_i_3_n_0 ),
        .O(p_0_in[9]));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \count_value[9]_i_3 
       (.I0(count_value_reg[6]),
        .I1(count_value_reg[3]),
        .I2(count_value_reg[4]),
        .I3(\count_value[5]_i_2_n_0 ),
        .I4(count_value_reg[5]),
        .I5(count_value_reg[7]),
        .O(\count_value[9]_i_3_n_0 ));
  FDRE \count_value_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\count_value[9]_i_1_n_0 ),
        .D(p_0_in[0]),
        .Q(count_value_reg[0]),
        .R(\<const0> ));
  FDRE \count_value_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\count_value[9]_i_1_n_0 ),
        .D(p_0_in[1]),
        .Q(count_value_reg[1]),
        .R(\<const0> ));
  FDRE \count_value_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\count_value[9]_i_1_n_0 ),
        .D(p_0_in[2]),
        .Q(count_value_reg[2]),
        .R(\<const0> ));
  FDRE \count_value_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\count_value[9]_i_1_n_0 ),
        .D(p_0_in[3]),
        .Q(count_value_reg[3]),
        .R(\<const0> ));
  FDRE \count_value_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\count_value[9]_i_1_n_0 ),
        .D(p_0_in[4]),
        .Q(count_value_reg[4]),
        .R(\<const0> ));
  FDRE \count_value_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\count_value[9]_i_1_n_0 ),
        .D(p_0_in[5]),
        .Q(count_value_reg[5]),
        .R(\<const0> ));
  FDRE \count_value_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\count_value[9]_i_1_n_0 ),
        .D(p_0_in[6]),
        .Q(count_value_reg[6]),
        .R(\<const0> ));
  FDRE \count_value_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\count_value[9]_i_1_n_0 ),
        .D(p_0_in[7]),
        .Q(count_value_reg[7]),
        .R(\<const0> ));
  FDRE \count_value_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\count_value[9]_i_1_n_0 ),
        .D(p_0_in[8]),
        .Q(count_value_reg[8]),
        .R(\<const0> ));
  FDRE \count_value_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\count_value[9]_i_1_n_0 ),
        .D(p_0_in[9]),
        .Q(count_value_reg[9]),
        .R(\<const0> ));
  IBUF \data_IBUF[0]_inst 
       (.I(data[0]),
        .O(data_IBUF[0]));
  IBUF \data_IBUF[1]_inst 
       (.I(data[1]),
        .O(data_IBUF[1]));
  IBUF \data_IBUF[2]_inst 
       (.I(data[2]),
        .O(data_IBUF[2]));
  IBUF \data_IBUF[3]_inst 
       (.I(data[3]),
        .O(data_IBUF[3]));
  IBUF \data_IBUF[4]_inst 
       (.I(data[4]),
        .O(data_IBUF[4]));
  IBUF \data_IBUF[5]_inst 
       (.I(data[5]),
        .O(data_IBUF[5]));
  IBUF \data_IBUF[6]_inst 
       (.I(data[6]),
        .O(data_IBUF[6]));
  IBUF \data_IBUF[7]_inst 
       (.I(data[7]),
        .O(data_IBUF[7]));
  IBUF \data_IBUF[8]_inst 
       (.I(data[8]),
        .O(data_IBUF[8]));
  IBUF \data_IBUF[9]_inst 
       (.I(data[9]),
        .O(data_IBUF[9]));
  IBUF load_IBUF_inst
       (.I(load),
        .O(load_IBUF));
  OBUF tc_OBUF_inst
       (.I(tc_OBUF),
        .O(tc));
  LUT5 #(
    .INIT(32'h00000010)) 
    tc_OBUF_inst_i_1
       (.I0(count_value_reg[8]),
        .I1(count_value_reg[6]),
        .I2(tc_OBUF_inst_i_2_n_0),
        .I3(count_value_reg[7]),
        .I4(count_value_reg[9]),
        .O(tc_OBUF));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    tc_OBUF_inst_i_2
       (.I0(count_value_reg[3]),
        .I1(count_value_reg[4]),
        .I2(count_value_reg[2]),
        .I3(count_value_reg[1]),
        .I4(count_value_reg[0]),
        .I5(count_value_reg[5]),
        .O(tc_OBUF_inst_i_2_n_0));
endmodule
