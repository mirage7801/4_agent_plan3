// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:28:43 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_rwi8bu2d/synth_netlist.v
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
    ena,
    data,
    q);
  input clk;
  input load;
  input [1:0]ena;
  input [99:0]data;
  output [99:0]q;

  wire \<const0> ;
  wire VCC_1;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [99:0]data;
  wire [99:0]data_IBUF;
  wire [1:0]ena;
  wire [1:0]ena_IBUF;
  wire load;
  wire load_IBUF;
  wire [99:0]q;
  wire \q[0]_i_1_n_0 ;
  wire \q[10]_i_1_n_0 ;
  wire \q[11]_i_1_n_0 ;
  wire \q[12]_i_1_n_0 ;
  wire \q[13]_i_1_n_0 ;
  wire \q[14]_i_1_n_0 ;
  wire \q[15]_i_1_n_0 ;
  wire \q[16]_i_1_n_0 ;
  wire \q[17]_i_1_n_0 ;
  wire \q[18]_i_1_n_0 ;
  wire \q[19]_i_1_n_0 ;
  wire \q[1]_i_1_n_0 ;
  wire \q[20]_i_1_n_0 ;
  wire \q[21]_i_1_n_0 ;
  wire \q[22]_i_1_n_0 ;
  wire \q[23]_i_1_n_0 ;
  wire \q[24]_i_1_n_0 ;
  wire \q[25]_i_1_n_0 ;
  wire \q[26]_i_1_n_0 ;
  wire \q[27]_i_1_n_0 ;
  wire \q[28]_i_1_n_0 ;
  wire \q[29]_i_1_n_0 ;
  wire \q[2]_i_1_n_0 ;
  wire \q[30]_i_1_n_0 ;
  wire \q[31]_i_1_n_0 ;
  wire \q[32]_i_1_n_0 ;
  wire \q[33]_i_1_n_0 ;
  wire \q[34]_i_1_n_0 ;
  wire \q[35]_i_1_n_0 ;
  wire \q[36]_i_1_n_0 ;
  wire \q[37]_i_1_n_0 ;
  wire \q[38]_i_1_n_0 ;
  wire \q[39]_i_1_n_0 ;
  wire \q[3]_i_1_n_0 ;
  wire \q[40]_i_1_n_0 ;
  wire \q[41]_i_1_n_0 ;
  wire \q[42]_i_1_n_0 ;
  wire \q[43]_i_1_n_0 ;
  wire \q[44]_i_1_n_0 ;
  wire \q[45]_i_1_n_0 ;
  wire \q[46]_i_1_n_0 ;
  wire \q[47]_i_1_n_0 ;
  wire \q[48]_i_1_n_0 ;
  wire \q[49]_i_1_n_0 ;
  wire \q[4]_i_1_n_0 ;
  wire \q[50]_i_1_n_0 ;
  wire \q[51]_i_1_n_0 ;
  wire \q[52]_i_1_n_0 ;
  wire \q[53]_i_1_n_0 ;
  wire \q[54]_i_1_n_0 ;
  wire \q[55]_i_1_n_0 ;
  wire \q[56]_i_1_n_0 ;
  wire \q[57]_i_1_n_0 ;
  wire \q[58]_i_1_n_0 ;
  wire \q[59]_i_1_n_0 ;
  wire \q[5]_i_1_n_0 ;
  wire \q[60]_i_1_n_0 ;
  wire \q[61]_i_1_n_0 ;
  wire \q[62]_i_1_n_0 ;
  wire \q[63]_i_1_n_0 ;
  wire \q[64]_i_1_n_0 ;
  wire \q[65]_i_1_n_0 ;
  wire \q[66]_i_1_n_0 ;
  wire \q[67]_i_1_n_0 ;
  wire \q[68]_i_1_n_0 ;
  wire \q[69]_i_1_n_0 ;
  wire \q[6]_i_1_n_0 ;
  wire \q[70]_i_1_n_0 ;
  wire \q[71]_i_1_n_0 ;
  wire \q[72]_i_1_n_0 ;
  wire \q[73]_i_1_n_0 ;
  wire \q[74]_i_1_n_0 ;
  wire \q[75]_i_1_n_0 ;
  wire \q[76]_i_1_n_0 ;
  wire \q[77]_i_1_n_0 ;
  wire \q[78]_i_1_n_0 ;
  wire \q[79]_i_1_n_0 ;
  wire \q[7]_i_1_n_0 ;
  wire \q[80]_i_1_n_0 ;
  wire \q[81]_i_1_n_0 ;
  wire \q[82]_i_1_n_0 ;
  wire \q[83]_i_1_n_0 ;
  wire \q[84]_i_1_n_0 ;
  wire \q[85]_i_1_n_0 ;
  wire \q[86]_i_1_n_0 ;
  wire \q[87]_i_1_n_0 ;
  wire \q[88]_i_1_n_0 ;
  wire \q[89]_i_1_n_0 ;
  wire \q[8]_i_1_n_0 ;
  wire \q[90]_i_1_n_0 ;
  wire \q[91]_i_1_n_0 ;
  wire \q[92]_i_1_n_0 ;
  wire \q[93]_i_1_n_0 ;
  wire \q[94]_i_1_n_0 ;
  wire \q[95]_i_1_n_0 ;
  wire \q[96]_i_1_n_0 ;
  wire \q[97]_i_1_n_0 ;
  wire \q[98]_i_1_n_0 ;
  wire \q[99]_i_1_n_0 ;
  wire \q[99]_i_2_n_0 ;
  wire \q[9]_i_1_n_0 ;
  wire [99:0]q_OBUF;

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
  IBUF \data_IBUF[0]_inst 
       (.I(data[0]),
        .O(data_IBUF[0]));
  IBUF \data_IBUF[10]_inst 
       (.I(data[10]),
        .O(data_IBUF[10]));
  IBUF \data_IBUF[11]_inst 
       (.I(data[11]),
        .O(data_IBUF[11]));
  IBUF \data_IBUF[12]_inst 
       (.I(data[12]),
        .O(data_IBUF[12]));
  IBUF \data_IBUF[13]_inst 
       (.I(data[13]),
        .O(data_IBUF[13]));
  IBUF \data_IBUF[14]_inst 
       (.I(data[14]),
        .O(data_IBUF[14]));
  IBUF \data_IBUF[15]_inst 
       (.I(data[15]),
        .O(data_IBUF[15]));
  IBUF \data_IBUF[16]_inst 
       (.I(data[16]),
        .O(data_IBUF[16]));
  IBUF \data_IBUF[17]_inst 
       (.I(data[17]),
        .O(data_IBUF[17]));
  IBUF \data_IBUF[18]_inst 
       (.I(data[18]),
        .O(data_IBUF[18]));
  IBUF \data_IBUF[19]_inst 
       (.I(data[19]),
        .O(data_IBUF[19]));
  IBUF \data_IBUF[1]_inst 
       (.I(data[1]),
        .O(data_IBUF[1]));
  IBUF \data_IBUF[20]_inst 
       (.I(data[20]),
        .O(data_IBUF[20]));
  IBUF \data_IBUF[21]_inst 
       (.I(data[21]),
        .O(data_IBUF[21]));
  IBUF \data_IBUF[22]_inst 
       (.I(data[22]),
        .O(data_IBUF[22]));
  IBUF \data_IBUF[23]_inst 
       (.I(data[23]),
        .O(data_IBUF[23]));
  IBUF \data_IBUF[24]_inst 
       (.I(data[24]),
        .O(data_IBUF[24]));
  IBUF \data_IBUF[25]_inst 
       (.I(data[25]),
        .O(data_IBUF[25]));
  IBUF \data_IBUF[26]_inst 
       (.I(data[26]),
        .O(data_IBUF[26]));
  IBUF \data_IBUF[27]_inst 
       (.I(data[27]),
        .O(data_IBUF[27]));
  IBUF \data_IBUF[28]_inst 
       (.I(data[28]),
        .O(data_IBUF[28]));
  IBUF \data_IBUF[29]_inst 
       (.I(data[29]),
        .O(data_IBUF[29]));
  IBUF \data_IBUF[2]_inst 
       (.I(data[2]),
        .O(data_IBUF[2]));
  IBUF \data_IBUF[30]_inst 
       (.I(data[30]),
        .O(data_IBUF[30]));
  IBUF \data_IBUF[31]_inst 
       (.I(data[31]),
        .O(data_IBUF[31]));
  IBUF \data_IBUF[32]_inst 
       (.I(data[32]),
        .O(data_IBUF[32]));
  IBUF \data_IBUF[33]_inst 
       (.I(data[33]),
        .O(data_IBUF[33]));
  IBUF \data_IBUF[34]_inst 
       (.I(data[34]),
        .O(data_IBUF[34]));
  IBUF \data_IBUF[35]_inst 
       (.I(data[35]),
        .O(data_IBUF[35]));
  IBUF \data_IBUF[36]_inst 
       (.I(data[36]),
        .O(data_IBUF[36]));
  IBUF \data_IBUF[37]_inst 
       (.I(data[37]),
        .O(data_IBUF[37]));
  IBUF \data_IBUF[38]_inst 
       (.I(data[38]),
        .O(data_IBUF[38]));
  IBUF \data_IBUF[39]_inst 
       (.I(data[39]),
        .O(data_IBUF[39]));
  IBUF \data_IBUF[3]_inst 
       (.I(data[3]),
        .O(data_IBUF[3]));
  IBUF \data_IBUF[40]_inst 
       (.I(data[40]),
        .O(data_IBUF[40]));
  IBUF \data_IBUF[41]_inst 
       (.I(data[41]),
        .O(data_IBUF[41]));
  IBUF \data_IBUF[42]_inst 
       (.I(data[42]),
        .O(data_IBUF[42]));
  IBUF \data_IBUF[43]_inst 
       (.I(data[43]),
        .O(data_IBUF[43]));
  IBUF \data_IBUF[44]_inst 
       (.I(data[44]),
        .O(data_IBUF[44]));
  IBUF \data_IBUF[45]_inst 
       (.I(data[45]),
        .O(data_IBUF[45]));
  IBUF \data_IBUF[46]_inst 
       (.I(data[46]),
        .O(data_IBUF[46]));
  IBUF \data_IBUF[47]_inst 
       (.I(data[47]),
        .O(data_IBUF[47]));
  IBUF \data_IBUF[48]_inst 
       (.I(data[48]),
        .O(data_IBUF[48]));
  IBUF \data_IBUF[49]_inst 
       (.I(data[49]),
        .O(data_IBUF[49]));
  IBUF \data_IBUF[4]_inst 
       (.I(data[4]),
        .O(data_IBUF[4]));
  IBUF \data_IBUF[50]_inst 
       (.I(data[50]),
        .O(data_IBUF[50]));
  IBUF \data_IBUF[51]_inst 
       (.I(data[51]),
        .O(data_IBUF[51]));
  IBUF \data_IBUF[52]_inst 
       (.I(data[52]),
        .O(data_IBUF[52]));
  IBUF \data_IBUF[53]_inst 
       (.I(data[53]),
        .O(data_IBUF[53]));
  IBUF \data_IBUF[54]_inst 
       (.I(data[54]),
        .O(data_IBUF[54]));
  IBUF \data_IBUF[55]_inst 
       (.I(data[55]),
        .O(data_IBUF[55]));
  IBUF \data_IBUF[56]_inst 
       (.I(data[56]),
        .O(data_IBUF[56]));
  IBUF \data_IBUF[57]_inst 
       (.I(data[57]),
        .O(data_IBUF[57]));
  IBUF \data_IBUF[58]_inst 
       (.I(data[58]),
        .O(data_IBUF[58]));
  IBUF \data_IBUF[59]_inst 
       (.I(data[59]),
        .O(data_IBUF[59]));
  IBUF \data_IBUF[5]_inst 
       (.I(data[5]),
        .O(data_IBUF[5]));
  IBUF \data_IBUF[60]_inst 
       (.I(data[60]),
        .O(data_IBUF[60]));
  IBUF \data_IBUF[61]_inst 
       (.I(data[61]),
        .O(data_IBUF[61]));
  IBUF \data_IBUF[62]_inst 
       (.I(data[62]),
        .O(data_IBUF[62]));
  IBUF \data_IBUF[63]_inst 
       (.I(data[63]),
        .O(data_IBUF[63]));
  IBUF \data_IBUF[64]_inst 
       (.I(data[64]),
        .O(data_IBUF[64]));
  IBUF \data_IBUF[65]_inst 
       (.I(data[65]),
        .O(data_IBUF[65]));
  IBUF \data_IBUF[66]_inst 
       (.I(data[66]),
        .O(data_IBUF[66]));
  IBUF \data_IBUF[67]_inst 
       (.I(data[67]),
        .O(data_IBUF[67]));
  IBUF \data_IBUF[68]_inst 
       (.I(data[68]),
        .O(data_IBUF[68]));
  IBUF \data_IBUF[69]_inst 
       (.I(data[69]),
        .O(data_IBUF[69]));
  IBUF \data_IBUF[6]_inst 
       (.I(data[6]),
        .O(data_IBUF[6]));
  IBUF \data_IBUF[70]_inst 
       (.I(data[70]),
        .O(data_IBUF[70]));
  IBUF \data_IBUF[71]_inst 
       (.I(data[71]),
        .O(data_IBUF[71]));
  IBUF \data_IBUF[72]_inst 
       (.I(data[72]),
        .O(data_IBUF[72]));
  IBUF \data_IBUF[73]_inst 
       (.I(data[73]),
        .O(data_IBUF[73]));
  IBUF \data_IBUF[74]_inst 
       (.I(data[74]),
        .O(data_IBUF[74]));
  IBUF \data_IBUF[75]_inst 
       (.I(data[75]),
        .O(data_IBUF[75]));
  IBUF \data_IBUF[76]_inst 
       (.I(data[76]),
        .O(data_IBUF[76]));
  IBUF \data_IBUF[77]_inst 
       (.I(data[77]),
        .O(data_IBUF[77]));
  IBUF \data_IBUF[78]_inst 
       (.I(data[78]),
        .O(data_IBUF[78]));
  IBUF \data_IBUF[79]_inst 
       (.I(data[79]),
        .O(data_IBUF[79]));
  IBUF \data_IBUF[7]_inst 
       (.I(data[7]),
        .O(data_IBUF[7]));
  IBUF \data_IBUF[80]_inst 
       (.I(data[80]),
        .O(data_IBUF[80]));
  IBUF \data_IBUF[81]_inst 
       (.I(data[81]),
        .O(data_IBUF[81]));
  IBUF \data_IBUF[82]_inst 
       (.I(data[82]),
        .O(data_IBUF[82]));
  IBUF \data_IBUF[83]_inst 
       (.I(data[83]),
        .O(data_IBUF[83]));
  IBUF \data_IBUF[84]_inst 
       (.I(data[84]),
        .O(data_IBUF[84]));
  IBUF \data_IBUF[85]_inst 
       (.I(data[85]),
        .O(data_IBUF[85]));
  IBUF \data_IBUF[86]_inst 
       (.I(data[86]),
        .O(data_IBUF[86]));
  IBUF \data_IBUF[87]_inst 
       (.I(data[87]),
        .O(data_IBUF[87]));
  IBUF \data_IBUF[88]_inst 
       (.I(data[88]),
        .O(data_IBUF[88]));
  IBUF \data_IBUF[89]_inst 
       (.I(data[89]),
        .O(data_IBUF[89]));
  IBUF \data_IBUF[8]_inst 
       (.I(data[8]),
        .O(data_IBUF[8]));
  IBUF \data_IBUF[90]_inst 
       (.I(data[90]),
        .O(data_IBUF[90]));
  IBUF \data_IBUF[91]_inst 
       (.I(data[91]),
        .O(data_IBUF[91]));
  IBUF \data_IBUF[92]_inst 
       (.I(data[92]),
        .O(data_IBUF[92]));
  IBUF \data_IBUF[93]_inst 
       (.I(data[93]),
        .O(data_IBUF[93]));
  IBUF \data_IBUF[94]_inst 
       (.I(data[94]),
        .O(data_IBUF[94]));
  IBUF \data_IBUF[95]_inst 
       (.I(data[95]),
        .O(data_IBUF[95]));
  IBUF \data_IBUF[96]_inst 
       (.I(data[96]),
        .O(data_IBUF[96]));
  IBUF \data_IBUF[97]_inst 
       (.I(data[97]),
        .O(data_IBUF[97]));
  IBUF \data_IBUF[98]_inst 
       (.I(data[98]),
        .O(data_IBUF[98]));
  IBUF \data_IBUF[99]_inst 
       (.I(data[99]),
        .O(data_IBUF[99]));
  IBUF \data_IBUF[9]_inst 
       (.I(data[9]),
        .O(data_IBUF[9]));
  IBUF \ena_IBUF[0]_inst 
       (.I(ena[0]),
        .O(ena_IBUF[0]));
  IBUF \ena_IBUF[1]_inst 
       (.I(ena[1]),
        .O(ena_IBUF[1]));
  IBUF load_IBUF_inst
       (.I(load),
        .O(load_IBUF));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[0]_i_1 
       (.I0(data_IBUF[0]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[1]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[99]),
        .O(\q[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[10]_i_1 
       (.I0(data_IBUF[10]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[11]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[9]),
        .O(\q[10]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[11]_i_1 
       (.I0(data_IBUF[11]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[12]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[10]),
        .O(\q[11]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[12]_i_1 
       (.I0(data_IBUF[12]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[13]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[11]),
        .O(\q[12]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[13]_i_1 
       (.I0(data_IBUF[13]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[14]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[12]),
        .O(\q[13]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[14]_i_1 
       (.I0(data_IBUF[14]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[15]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[13]),
        .O(\q[14]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[15]_i_1 
       (.I0(data_IBUF[15]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[16]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[14]),
        .O(\q[15]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[16]_i_1 
       (.I0(data_IBUF[16]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[17]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[15]),
        .O(\q[16]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[17]_i_1 
       (.I0(data_IBUF[17]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[18]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[16]),
        .O(\q[17]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[18]_i_1 
       (.I0(data_IBUF[18]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[19]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[17]),
        .O(\q[18]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[19]_i_1 
       (.I0(data_IBUF[19]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[20]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[18]),
        .O(\q[19]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[1]_i_1 
       (.I0(data_IBUF[1]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[2]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[0]),
        .O(\q[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[20]_i_1 
       (.I0(data_IBUF[20]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[21]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[19]),
        .O(\q[20]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[21]_i_1 
       (.I0(data_IBUF[21]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[22]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[20]),
        .O(\q[21]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[22]_i_1 
       (.I0(data_IBUF[22]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[23]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[21]),
        .O(\q[22]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[23]_i_1 
       (.I0(data_IBUF[23]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[24]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[22]),
        .O(\q[23]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[24]_i_1 
       (.I0(data_IBUF[24]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[25]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[23]),
        .O(\q[24]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[25]_i_1 
       (.I0(data_IBUF[25]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[26]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[24]),
        .O(\q[25]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[26]_i_1 
       (.I0(data_IBUF[26]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[27]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[25]),
        .O(\q[26]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[27]_i_1 
       (.I0(data_IBUF[27]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[28]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[26]),
        .O(\q[27]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[28]_i_1 
       (.I0(data_IBUF[28]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[29]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[27]),
        .O(\q[28]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[29]_i_1 
       (.I0(data_IBUF[29]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[30]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[28]),
        .O(\q[29]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[2]_i_1 
       (.I0(data_IBUF[2]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[3]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[1]),
        .O(\q[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[30]_i_1 
       (.I0(data_IBUF[30]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[31]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[29]),
        .O(\q[30]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[31]_i_1 
       (.I0(data_IBUF[31]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[32]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[30]),
        .O(\q[31]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[32]_i_1 
       (.I0(data_IBUF[32]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[33]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[31]),
        .O(\q[32]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[33]_i_1 
       (.I0(data_IBUF[33]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[34]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[32]),
        .O(\q[33]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[34]_i_1 
       (.I0(data_IBUF[34]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[35]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[33]),
        .O(\q[34]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[35]_i_1 
       (.I0(data_IBUF[35]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[36]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[34]),
        .O(\q[35]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[36]_i_1 
       (.I0(data_IBUF[36]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[37]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[35]),
        .O(\q[36]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[37]_i_1 
       (.I0(data_IBUF[37]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[38]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[36]),
        .O(\q[37]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[38]_i_1 
       (.I0(data_IBUF[38]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[39]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[37]),
        .O(\q[38]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[39]_i_1 
       (.I0(data_IBUF[39]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[40]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[38]),
        .O(\q[39]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[3]_i_1 
       (.I0(data_IBUF[3]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[4]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[2]),
        .O(\q[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[40]_i_1 
       (.I0(data_IBUF[40]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[41]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[39]),
        .O(\q[40]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[41]_i_1 
       (.I0(data_IBUF[41]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[42]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[40]),
        .O(\q[41]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[42]_i_1 
       (.I0(data_IBUF[42]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[43]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[41]),
        .O(\q[42]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[43]_i_1 
       (.I0(data_IBUF[43]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[44]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[42]),
        .O(\q[43]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[44]_i_1 
       (.I0(data_IBUF[44]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[45]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[43]),
        .O(\q[44]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[45]_i_1 
       (.I0(data_IBUF[45]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[46]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[44]),
        .O(\q[45]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[46]_i_1 
       (.I0(data_IBUF[46]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[47]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[45]),
        .O(\q[46]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[47]_i_1 
       (.I0(data_IBUF[47]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[48]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[46]),
        .O(\q[47]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[48]_i_1 
       (.I0(data_IBUF[48]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[49]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[47]),
        .O(\q[48]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[49]_i_1 
       (.I0(data_IBUF[49]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[50]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[48]),
        .O(\q[49]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[4]_i_1 
       (.I0(data_IBUF[4]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[5]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[3]),
        .O(\q[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[50]_i_1 
       (.I0(data_IBUF[50]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[51]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[49]),
        .O(\q[50]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[51]_i_1 
       (.I0(data_IBUF[51]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[52]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[50]),
        .O(\q[51]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[52]_i_1 
       (.I0(data_IBUF[52]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[53]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[51]),
        .O(\q[52]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[53]_i_1 
       (.I0(data_IBUF[53]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[54]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[52]),
        .O(\q[53]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[54]_i_1 
       (.I0(data_IBUF[54]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[55]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[53]),
        .O(\q[54]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[55]_i_1 
       (.I0(data_IBUF[55]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[56]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[54]),
        .O(\q[55]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[56]_i_1 
       (.I0(data_IBUF[56]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[57]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[55]),
        .O(\q[56]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[57]_i_1 
       (.I0(data_IBUF[57]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[58]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[56]),
        .O(\q[57]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[58]_i_1 
       (.I0(data_IBUF[58]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[59]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[57]),
        .O(\q[58]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[59]_i_1 
       (.I0(data_IBUF[59]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[60]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[58]),
        .O(\q[59]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[5]_i_1 
       (.I0(data_IBUF[5]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[6]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[4]),
        .O(\q[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[60]_i_1 
       (.I0(data_IBUF[60]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[61]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[59]),
        .O(\q[60]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[61]_i_1 
       (.I0(data_IBUF[61]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[62]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[60]),
        .O(\q[61]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[62]_i_1 
       (.I0(data_IBUF[62]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[63]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[61]),
        .O(\q[62]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[63]_i_1 
       (.I0(data_IBUF[63]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[64]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[62]),
        .O(\q[63]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[64]_i_1 
       (.I0(data_IBUF[64]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[65]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[63]),
        .O(\q[64]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[65]_i_1 
       (.I0(data_IBUF[65]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[66]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[64]),
        .O(\q[65]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[66]_i_1 
       (.I0(data_IBUF[66]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[67]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[65]),
        .O(\q[66]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[67]_i_1 
       (.I0(data_IBUF[67]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[68]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[66]),
        .O(\q[67]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[68]_i_1 
       (.I0(data_IBUF[68]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[69]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[67]),
        .O(\q[68]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[69]_i_1 
       (.I0(data_IBUF[69]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[70]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[68]),
        .O(\q[69]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[6]_i_1 
       (.I0(data_IBUF[6]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[7]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[5]),
        .O(\q[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[70]_i_1 
       (.I0(data_IBUF[70]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[71]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[69]),
        .O(\q[70]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[71]_i_1 
       (.I0(data_IBUF[71]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[72]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[70]),
        .O(\q[71]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[72]_i_1 
       (.I0(data_IBUF[72]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[73]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[71]),
        .O(\q[72]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[73]_i_1 
       (.I0(data_IBUF[73]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[74]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[72]),
        .O(\q[73]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[74]_i_1 
       (.I0(data_IBUF[74]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[75]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[73]),
        .O(\q[74]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[75]_i_1 
       (.I0(data_IBUF[75]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[76]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[74]),
        .O(\q[75]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[76]_i_1 
       (.I0(data_IBUF[76]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[77]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[75]),
        .O(\q[76]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[77]_i_1 
       (.I0(data_IBUF[77]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[78]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[76]),
        .O(\q[77]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[78]_i_1 
       (.I0(data_IBUF[78]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[79]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[77]),
        .O(\q[78]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[79]_i_1 
       (.I0(data_IBUF[79]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[80]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[78]),
        .O(\q[79]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[7]_i_1 
       (.I0(data_IBUF[7]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[8]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[6]),
        .O(\q[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[80]_i_1 
       (.I0(data_IBUF[80]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[81]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[79]),
        .O(\q[80]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[81]_i_1 
       (.I0(data_IBUF[81]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[82]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[80]),
        .O(\q[81]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[82]_i_1 
       (.I0(data_IBUF[82]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[83]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[81]),
        .O(\q[82]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[83]_i_1 
       (.I0(data_IBUF[83]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[84]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[82]),
        .O(\q[83]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[84]_i_1 
       (.I0(data_IBUF[84]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[85]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[83]),
        .O(\q[84]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[85]_i_1 
       (.I0(data_IBUF[85]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[86]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[84]),
        .O(\q[85]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[86]_i_1 
       (.I0(data_IBUF[86]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[87]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[85]),
        .O(\q[86]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[87]_i_1 
       (.I0(data_IBUF[87]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[88]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[86]),
        .O(\q[87]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[88]_i_1 
       (.I0(data_IBUF[88]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[89]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[87]),
        .O(\q[88]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[89]_i_1 
       (.I0(data_IBUF[89]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[90]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[88]),
        .O(\q[89]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[8]_i_1 
       (.I0(data_IBUF[8]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[9]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[7]),
        .O(\q[8]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[90]_i_1 
       (.I0(data_IBUF[90]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[91]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[89]),
        .O(\q[90]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[91]_i_1 
       (.I0(data_IBUF[91]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[92]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[90]),
        .O(\q[91]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[92]_i_1 
       (.I0(data_IBUF[92]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[93]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[91]),
        .O(\q[92]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[93]_i_1 
       (.I0(data_IBUF[93]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[94]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[92]),
        .O(\q[93]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[94]_i_1 
       (.I0(data_IBUF[94]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[95]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[93]),
        .O(\q[94]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[95]_i_1 
       (.I0(data_IBUF[95]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[96]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[94]),
        .O(\q[95]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[96]_i_1 
       (.I0(data_IBUF[96]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[97]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[95]),
        .O(\q[96]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[97]_i_1 
       (.I0(data_IBUF[97]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[98]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[96]),
        .O(\q[97]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[98]_i_1 
       (.I0(data_IBUF[98]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[99]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[97]),
        .O(\q[98]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hF6)) 
    \q[99]_i_1 
       (.I0(ena_IBUF[0]),
        .I1(ena_IBUF[1]),
        .I2(load_IBUF),
        .O(\q[99]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[99]_i_2 
       (.I0(data_IBUF[99]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[0]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[98]),
        .O(\q[99]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hBBB8BBBB8B888888)) 
    \q[9]_i_1 
       (.I0(data_IBUF[9]),
        .I1(load_IBUF),
        .I2(ena_IBUF[1]),
        .I3(q_OBUF[10]),
        .I4(ena_IBUF[0]),
        .I5(q_OBUF[8]),
        .O(\q[9]_i_1_n_0 ));
  OBUF \q_OBUF[0]_inst 
       (.I(q_OBUF[0]),
        .O(q[0]));
  OBUF \q_OBUF[10]_inst 
       (.I(q_OBUF[10]),
        .O(q[10]));
  OBUF \q_OBUF[11]_inst 
       (.I(q_OBUF[11]),
        .O(q[11]));
  OBUF \q_OBUF[12]_inst 
       (.I(q_OBUF[12]),
        .O(q[12]));
  OBUF \q_OBUF[13]_inst 
       (.I(q_OBUF[13]),
        .O(q[13]));
  OBUF \q_OBUF[14]_inst 
       (.I(q_OBUF[14]),
        .O(q[14]));
  OBUF \q_OBUF[15]_inst 
       (.I(q_OBUF[15]),
        .O(q[15]));
  OBUF \q_OBUF[16]_inst 
       (.I(q_OBUF[16]),
        .O(q[16]));
  OBUF \q_OBUF[17]_inst 
       (.I(q_OBUF[17]),
        .O(q[17]));
  OBUF \q_OBUF[18]_inst 
       (.I(q_OBUF[18]),
        .O(q[18]));
  OBUF \q_OBUF[19]_inst 
       (.I(q_OBUF[19]),
        .O(q[19]));
  OBUF \q_OBUF[1]_inst 
       (.I(q_OBUF[1]),
        .O(q[1]));
  OBUF \q_OBUF[20]_inst 
       (.I(q_OBUF[20]),
        .O(q[20]));
  OBUF \q_OBUF[21]_inst 
       (.I(q_OBUF[21]),
        .O(q[21]));
  OBUF \q_OBUF[22]_inst 
       (.I(q_OBUF[22]),
        .O(q[22]));
  OBUF \q_OBUF[23]_inst 
       (.I(q_OBUF[23]),
        .O(q[23]));
  OBUF \q_OBUF[24]_inst 
       (.I(q_OBUF[24]),
        .O(q[24]));
  OBUF \q_OBUF[25]_inst 
       (.I(q_OBUF[25]),
        .O(q[25]));
  OBUF \q_OBUF[26]_inst 
       (.I(q_OBUF[26]),
        .O(q[26]));
  OBUF \q_OBUF[27]_inst 
       (.I(q_OBUF[27]),
        .O(q[27]));
  OBUF \q_OBUF[28]_inst 
       (.I(q_OBUF[28]),
        .O(q[28]));
  OBUF \q_OBUF[29]_inst 
       (.I(q_OBUF[29]),
        .O(q[29]));
  OBUF \q_OBUF[2]_inst 
       (.I(q_OBUF[2]),
        .O(q[2]));
  OBUF \q_OBUF[30]_inst 
       (.I(q_OBUF[30]),
        .O(q[30]));
  OBUF \q_OBUF[31]_inst 
       (.I(q_OBUF[31]),
        .O(q[31]));
  OBUF \q_OBUF[32]_inst 
       (.I(q_OBUF[32]),
        .O(q[32]));
  OBUF \q_OBUF[33]_inst 
       (.I(q_OBUF[33]),
        .O(q[33]));
  OBUF \q_OBUF[34]_inst 
       (.I(q_OBUF[34]),
        .O(q[34]));
  OBUF \q_OBUF[35]_inst 
       (.I(q_OBUF[35]),
        .O(q[35]));
  OBUF \q_OBUF[36]_inst 
       (.I(q_OBUF[36]),
        .O(q[36]));
  OBUF \q_OBUF[37]_inst 
       (.I(q_OBUF[37]),
        .O(q[37]));
  OBUF \q_OBUF[38]_inst 
       (.I(q_OBUF[38]),
        .O(q[38]));
  OBUF \q_OBUF[39]_inst 
       (.I(q_OBUF[39]),
        .O(q[39]));
  OBUF \q_OBUF[3]_inst 
       (.I(q_OBUF[3]),
        .O(q[3]));
  OBUF \q_OBUF[40]_inst 
       (.I(q_OBUF[40]),
        .O(q[40]));
  OBUF \q_OBUF[41]_inst 
       (.I(q_OBUF[41]),
        .O(q[41]));
  OBUF \q_OBUF[42]_inst 
       (.I(q_OBUF[42]),
        .O(q[42]));
  OBUF \q_OBUF[43]_inst 
       (.I(q_OBUF[43]),
        .O(q[43]));
  OBUF \q_OBUF[44]_inst 
       (.I(q_OBUF[44]),
        .O(q[44]));
  OBUF \q_OBUF[45]_inst 
       (.I(q_OBUF[45]),
        .O(q[45]));
  OBUF \q_OBUF[46]_inst 
       (.I(q_OBUF[46]),
        .O(q[46]));
  OBUF \q_OBUF[47]_inst 
       (.I(q_OBUF[47]),
        .O(q[47]));
  OBUF \q_OBUF[48]_inst 
       (.I(q_OBUF[48]),
        .O(q[48]));
  OBUF \q_OBUF[49]_inst 
       (.I(q_OBUF[49]),
        .O(q[49]));
  OBUF \q_OBUF[4]_inst 
       (.I(q_OBUF[4]),
        .O(q[4]));
  OBUF \q_OBUF[50]_inst 
       (.I(q_OBUF[50]),
        .O(q[50]));
  OBUF \q_OBUF[51]_inst 
       (.I(q_OBUF[51]),
        .O(q[51]));
  OBUF \q_OBUF[52]_inst 
       (.I(q_OBUF[52]),
        .O(q[52]));
  OBUF \q_OBUF[53]_inst 
       (.I(q_OBUF[53]),
        .O(q[53]));
  OBUF \q_OBUF[54]_inst 
       (.I(q_OBUF[54]),
        .O(q[54]));
  OBUF \q_OBUF[55]_inst 
       (.I(q_OBUF[55]),
        .O(q[55]));
  OBUF \q_OBUF[56]_inst 
       (.I(q_OBUF[56]),
        .O(q[56]));
  OBUF \q_OBUF[57]_inst 
       (.I(q_OBUF[57]),
        .O(q[57]));
  OBUF \q_OBUF[58]_inst 
       (.I(q_OBUF[58]),
        .O(q[58]));
  OBUF \q_OBUF[59]_inst 
       (.I(q_OBUF[59]),
        .O(q[59]));
  OBUF \q_OBUF[5]_inst 
       (.I(q_OBUF[5]),
        .O(q[5]));
  OBUF \q_OBUF[60]_inst 
       (.I(q_OBUF[60]),
        .O(q[60]));
  OBUF \q_OBUF[61]_inst 
       (.I(q_OBUF[61]),
        .O(q[61]));
  OBUF \q_OBUF[62]_inst 
       (.I(q_OBUF[62]),
        .O(q[62]));
  OBUF \q_OBUF[63]_inst 
       (.I(q_OBUF[63]),
        .O(q[63]));
  OBUF \q_OBUF[64]_inst 
       (.I(q_OBUF[64]),
        .O(q[64]));
  OBUF \q_OBUF[65]_inst 
       (.I(q_OBUF[65]),
        .O(q[65]));
  OBUF \q_OBUF[66]_inst 
       (.I(q_OBUF[66]),
        .O(q[66]));
  OBUF \q_OBUF[67]_inst 
       (.I(q_OBUF[67]),
        .O(q[67]));
  OBUF \q_OBUF[68]_inst 
       (.I(q_OBUF[68]),
        .O(q[68]));
  OBUF \q_OBUF[69]_inst 
       (.I(q_OBUF[69]),
        .O(q[69]));
  OBUF \q_OBUF[6]_inst 
       (.I(q_OBUF[6]),
        .O(q[6]));
  OBUF \q_OBUF[70]_inst 
       (.I(q_OBUF[70]),
        .O(q[70]));
  OBUF \q_OBUF[71]_inst 
       (.I(q_OBUF[71]),
        .O(q[71]));
  OBUF \q_OBUF[72]_inst 
       (.I(q_OBUF[72]),
        .O(q[72]));
  OBUF \q_OBUF[73]_inst 
       (.I(q_OBUF[73]),
        .O(q[73]));
  OBUF \q_OBUF[74]_inst 
       (.I(q_OBUF[74]),
        .O(q[74]));
  OBUF \q_OBUF[75]_inst 
       (.I(q_OBUF[75]),
        .O(q[75]));
  OBUF \q_OBUF[76]_inst 
       (.I(q_OBUF[76]),
        .O(q[76]));
  OBUF \q_OBUF[77]_inst 
       (.I(q_OBUF[77]),
        .O(q[77]));
  OBUF \q_OBUF[78]_inst 
       (.I(q_OBUF[78]),
        .O(q[78]));
  OBUF \q_OBUF[79]_inst 
       (.I(q_OBUF[79]),
        .O(q[79]));
  OBUF \q_OBUF[7]_inst 
       (.I(q_OBUF[7]),
        .O(q[7]));
  OBUF \q_OBUF[80]_inst 
       (.I(q_OBUF[80]),
        .O(q[80]));
  OBUF \q_OBUF[81]_inst 
       (.I(q_OBUF[81]),
        .O(q[81]));
  OBUF \q_OBUF[82]_inst 
       (.I(q_OBUF[82]),
        .O(q[82]));
  OBUF \q_OBUF[83]_inst 
       (.I(q_OBUF[83]),
        .O(q[83]));
  OBUF \q_OBUF[84]_inst 
       (.I(q_OBUF[84]),
        .O(q[84]));
  OBUF \q_OBUF[85]_inst 
       (.I(q_OBUF[85]),
        .O(q[85]));
  OBUF \q_OBUF[86]_inst 
       (.I(q_OBUF[86]),
        .O(q[86]));
  OBUF \q_OBUF[87]_inst 
       (.I(q_OBUF[87]),
        .O(q[87]));
  OBUF \q_OBUF[88]_inst 
       (.I(q_OBUF[88]),
        .O(q[88]));
  OBUF \q_OBUF[89]_inst 
       (.I(q_OBUF[89]),
        .O(q[89]));
  OBUF \q_OBUF[8]_inst 
       (.I(q_OBUF[8]),
        .O(q[8]));
  OBUF \q_OBUF[90]_inst 
       (.I(q_OBUF[90]),
        .O(q[90]));
  OBUF \q_OBUF[91]_inst 
       (.I(q_OBUF[91]),
        .O(q[91]));
  OBUF \q_OBUF[92]_inst 
       (.I(q_OBUF[92]),
        .O(q[92]));
  OBUF \q_OBUF[93]_inst 
       (.I(q_OBUF[93]),
        .O(q[93]));
  OBUF \q_OBUF[94]_inst 
       (.I(q_OBUF[94]),
        .O(q[94]));
  OBUF \q_OBUF[95]_inst 
       (.I(q_OBUF[95]),
        .O(q[95]));
  OBUF \q_OBUF[96]_inst 
       (.I(q_OBUF[96]),
        .O(q[96]));
  OBUF \q_OBUF[97]_inst 
       (.I(q_OBUF[97]),
        .O(q[97]));
  OBUF \q_OBUF[98]_inst 
       (.I(q_OBUF[98]),
        .O(q[98]));
  OBUF \q_OBUF[99]_inst 
       (.I(q_OBUF[99]),
        .O(q[99]));
  OBUF \q_OBUF[9]_inst 
       (.I(q_OBUF[9]),
        .O(q[9]));
  FDRE \q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[0]_i_1_n_0 ),
        .Q(q_OBUF[0]),
        .R(\<const0> ));
  FDRE \q_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[10]_i_1_n_0 ),
        .Q(q_OBUF[10]),
        .R(\<const0> ));
  FDRE \q_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[11]_i_1_n_0 ),
        .Q(q_OBUF[11]),
        .R(\<const0> ));
  FDRE \q_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[12]_i_1_n_0 ),
        .Q(q_OBUF[12]),
        .R(\<const0> ));
  FDRE \q_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[13]_i_1_n_0 ),
        .Q(q_OBUF[13]),
        .R(\<const0> ));
  FDRE \q_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[14]_i_1_n_0 ),
        .Q(q_OBUF[14]),
        .R(\<const0> ));
  FDRE \q_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[15]_i_1_n_0 ),
        .Q(q_OBUF[15]),
        .R(\<const0> ));
  FDRE \q_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[16]_i_1_n_0 ),
        .Q(q_OBUF[16]),
        .R(\<const0> ));
  FDRE \q_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[17]_i_1_n_0 ),
        .Q(q_OBUF[17]),
        .R(\<const0> ));
  FDRE \q_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[18]_i_1_n_0 ),
        .Q(q_OBUF[18]),
        .R(\<const0> ));
  FDRE \q_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[19]_i_1_n_0 ),
        .Q(q_OBUF[19]),
        .R(\<const0> ));
  FDRE \q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[1]_i_1_n_0 ),
        .Q(q_OBUF[1]),
        .R(\<const0> ));
  FDRE \q_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[20]_i_1_n_0 ),
        .Q(q_OBUF[20]),
        .R(\<const0> ));
  FDRE \q_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[21]_i_1_n_0 ),
        .Q(q_OBUF[21]),
        .R(\<const0> ));
  FDRE \q_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[22]_i_1_n_0 ),
        .Q(q_OBUF[22]),
        .R(\<const0> ));
  FDRE \q_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[23]_i_1_n_0 ),
        .Q(q_OBUF[23]),
        .R(\<const0> ));
  FDRE \q_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[24]_i_1_n_0 ),
        .Q(q_OBUF[24]),
        .R(\<const0> ));
  FDRE \q_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[25]_i_1_n_0 ),
        .Q(q_OBUF[25]),
        .R(\<const0> ));
  FDRE \q_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[26]_i_1_n_0 ),
        .Q(q_OBUF[26]),
        .R(\<const0> ));
  FDRE \q_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[27]_i_1_n_0 ),
        .Q(q_OBUF[27]),
        .R(\<const0> ));
  FDRE \q_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[28]_i_1_n_0 ),
        .Q(q_OBUF[28]),
        .R(\<const0> ));
  FDRE \q_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[29]_i_1_n_0 ),
        .Q(q_OBUF[29]),
        .R(\<const0> ));
  FDRE \q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[2]_i_1_n_0 ),
        .Q(q_OBUF[2]),
        .R(\<const0> ));
  FDRE \q_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[30]_i_1_n_0 ),
        .Q(q_OBUF[30]),
        .R(\<const0> ));
  FDRE \q_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[31]_i_1_n_0 ),
        .Q(q_OBUF[31]),
        .R(\<const0> ));
  FDRE \q_reg[32] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[32]_i_1_n_0 ),
        .Q(q_OBUF[32]),
        .R(\<const0> ));
  FDRE \q_reg[33] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[33]_i_1_n_0 ),
        .Q(q_OBUF[33]),
        .R(\<const0> ));
  FDRE \q_reg[34] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[34]_i_1_n_0 ),
        .Q(q_OBUF[34]),
        .R(\<const0> ));
  FDRE \q_reg[35] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[35]_i_1_n_0 ),
        .Q(q_OBUF[35]),
        .R(\<const0> ));
  FDRE \q_reg[36] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[36]_i_1_n_0 ),
        .Q(q_OBUF[36]),
        .R(\<const0> ));
  FDRE \q_reg[37] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[37]_i_1_n_0 ),
        .Q(q_OBUF[37]),
        .R(\<const0> ));
  FDRE \q_reg[38] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[38]_i_1_n_0 ),
        .Q(q_OBUF[38]),
        .R(\<const0> ));
  FDRE \q_reg[39] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[39]_i_1_n_0 ),
        .Q(q_OBUF[39]),
        .R(\<const0> ));
  FDRE \q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[3]_i_1_n_0 ),
        .Q(q_OBUF[3]),
        .R(\<const0> ));
  FDRE \q_reg[40] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[40]_i_1_n_0 ),
        .Q(q_OBUF[40]),
        .R(\<const0> ));
  FDRE \q_reg[41] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[41]_i_1_n_0 ),
        .Q(q_OBUF[41]),
        .R(\<const0> ));
  FDRE \q_reg[42] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[42]_i_1_n_0 ),
        .Q(q_OBUF[42]),
        .R(\<const0> ));
  FDRE \q_reg[43] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[43]_i_1_n_0 ),
        .Q(q_OBUF[43]),
        .R(\<const0> ));
  FDRE \q_reg[44] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[44]_i_1_n_0 ),
        .Q(q_OBUF[44]),
        .R(\<const0> ));
  FDRE \q_reg[45] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[45]_i_1_n_0 ),
        .Q(q_OBUF[45]),
        .R(\<const0> ));
  FDRE \q_reg[46] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[46]_i_1_n_0 ),
        .Q(q_OBUF[46]),
        .R(\<const0> ));
  FDRE \q_reg[47] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[47]_i_1_n_0 ),
        .Q(q_OBUF[47]),
        .R(\<const0> ));
  FDRE \q_reg[48] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[48]_i_1_n_0 ),
        .Q(q_OBUF[48]),
        .R(\<const0> ));
  FDRE \q_reg[49] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[49]_i_1_n_0 ),
        .Q(q_OBUF[49]),
        .R(\<const0> ));
  FDRE \q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[4]_i_1_n_0 ),
        .Q(q_OBUF[4]),
        .R(\<const0> ));
  FDRE \q_reg[50] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[50]_i_1_n_0 ),
        .Q(q_OBUF[50]),
        .R(\<const0> ));
  FDRE \q_reg[51] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[51]_i_1_n_0 ),
        .Q(q_OBUF[51]),
        .R(\<const0> ));
  FDRE \q_reg[52] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[52]_i_1_n_0 ),
        .Q(q_OBUF[52]),
        .R(\<const0> ));
  FDRE \q_reg[53] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[53]_i_1_n_0 ),
        .Q(q_OBUF[53]),
        .R(\<const0> ));
  FDRE \q_reg[54] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[54]_i_1_n_0 ),
        .Q(q_OBUF[54]),
        .R(\<const0> ));
  FDRE \q_reg[55] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[55]_i_1_n_0 ),
        .Q(q_OBUF[55]),
        .R(\<const0> ));
  FDRE \q_reg[56] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[56]_i_1_n_0 ),
        .Q(q_OBUF[56]),
        .R(\<const0> ));
  FDRE \q_reg[57] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[57]_i_1_n_0 ),
        .Q(q_OBUF[57]),
        .R(\<const0> ));
  FDRE \q_reg[58] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[58]_i_1_n_0 ),
        .Q(q_OBUF[58]),
        .R(\<const0> ));
  FDRE \q_reg[59] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[59]_i_1_n_0 ),
        .Q(q_OBUF[59]),
        .R(\<const0> ));
  FDRE \q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[5]_i_1_n_0 ),
        .Q(q_OBUF[5]),
        .R(\<const0> ));
  FDRE \q_reg[60] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[60]_i_1_n_0 ),
        .Q(q_OBUF[60]),
        .R(\<const0> ));
  FDRE \q_reg[61] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[61]_i_1_n_0 ),
        .Q(q_OBUF[61]),
        .R(\<const0> ));
  FDRE \q_reg[62] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[62]_i_1_n_0 ),
        .Q(q_OBUF[62]),
        .R(\<const0> ));
  FDRE \q_reg[63] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[63]_i_1_n_0 ),
        .Q(q_OBUF[63]),
        .R(\<const0> ));
  FDRE \q_reg[64] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[64]_i_1_n_0 ),
        .Q(q_OBUF[64]),
        .R(\<const0> ));
  FDRE \q_reg[65] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[65]_i_1_n_0 ),
        .Q(q_OBUF[65]),
        .R(\<const0> ));
  FDRE \q_reg[66] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[66]_i_1_n_0 ),
        .Q(q_OBUF[66]),
        .R(\<const0> ));
  FDRE \q_reg[67] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[67]_i_1_n_0 ),
        .Q(q_OBUF[67]),
        .R(\<const0> ));
  FDRE \q_reg[68] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[68]_i_1_n_0 ),
        .Q(q_OBUF[68]),
        .R(\<const0> ));
  FDRE \q_reg[69] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[69]_i_1_n_0 ),
        .Q(q_OBUF[69]),
        .R(\<const0> ));
  FDRE \q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[6]_i_1_n_0 ),
        .Q(q_OBUF[6]),
        .R(\<const0> ));
  FDRE \q_reg[70] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[70]_i_1_n_0 ),
        .Q(q_OBUF[70]),
        .R(\<const0> ));
  FDRE \q_reg[71] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[71]_i_1_n_0 ),
        .Q(q_OBUF[71]),
        .R(\<const0> ));
  FDRE \q_reg[72] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[72]_i_1_n_0 ),
        .Q(q_OBUF[72]),
        .R(\<const0> ));
  FDRE \q_reg[73] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[73]_i_1_n_0 ),
        .Q(q_OBUF[73]),
        .R(\<const0> ));
  FDRE \q_reg[74] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[74]_i_1_n_0 ),
        .Q(q_OBUF[74]),
        .R(\<const0> ));
  FDRE \q_reg[75] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[75]_i_1_n_0 ),
        .Q(q_OBUF[75]),
        .R(\<const0> ));
  FDRE \q_reg[76] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[76]_i_1_n_0 ),
        .Q(q_OBUF[76]),
        .R(\<const0> ));
  FDRE \q_reg[77] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[77]_i_1_n_0 ),
        .Q(q_OBUF[77]),
        .R(\<const0> ));
  FDRE \q_reg[78] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[78]_i_1_n_0 ),
        .Q(q_OBUF[78]),
        .R(\<const0> ));
  FDRE \q_reg[79] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[79]_i_1_n_0 ),
        .Q(q_OBUF[79]),
        .R(\<const0> ));
  FDRE \q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[7]_i_1_n_0 ),
        .Q(q_OBUF[7]),
        .R(\<const0> ));
  FDRE \q_reg[80] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[80]_i_1_n_0 ),
        .Q(q_OBUF[80]),
        .R(\<const0> ));
  FDRE \q_reg[81] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[81]_i_1_n_0 ),
        .Q(q_OBUF[81]),
        .R(\<const0> ));
  FDRE \q_reg[82] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[82]_i_1_n_0 ),
        .Q(q_OBUF[82]),
        .R(\<const0> ));
  FDRE \q_reg[83] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[83]_i_1_n_0 ),
        .Q(q_OBUF[83]),
        .R(\<const0> ));
  FDRE \q_reg[84] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[84]_i_1_n_0 ),
        .Q(q_OBUF[84]),
        .R(\<const0> ));
  FDRE \q_reg[85] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[85]_i_1_n_0 ),
        .Q(q_OBUF[85]),
        .R(\<const0> ));
  FDRE \q_reg[86] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[86]_i_1_n_0 ),
        .Q(q_OBUF[86]),
        .R(\<const0> ));
  FDRE \q_reg[87] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[87]_i_1_n_0 ),
        .Q(q_OBUF[87]),
        .R(\<const0> ));
  FDRE \q_reg[88] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[88]_i_1_n_0 ),
        .Q(q_OBUF[88]),
        .R(\<const0> ));
  FDRE \q_reg[89] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[89]_i_1_n_0 ),
        .Q(q_OBUF[89]),
        .R(\<const0> ));
  FDRE \q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[8]_i_1_n_0 ),
        .Q(q_OBUF[8]),
        .R(\<const0> ));
  FDRE \q_reg[90] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[90]_i_1_n_0 ),
        .Q(q_OBUF[90]),
        .R(\<const0> ));
  FDRE \q_reg[91] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[91]_i_1_n_0 ),
        .Q(q_OBUF[91]),
        .R(\<const0> ));
  FDRE \q_reg[92] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[92]_i_1_n_0 ),
        .Q(q_OBUF[92]),
        .R(\<const0> ));
  FDRE \q_reg[93] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[93]_i_1_n_0 ),
        .Q(q_OBUF[93]),
        .R(\<const0> ));
  FDRE \q_reg[94] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[94]_i_1_n_0 ),
        .Q(q_OBUF[94]),
        .R(\<const0> ));
  FDRE \q_reg[95] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[95]_i_1_n_0 ),
        .Q(q_OBUF[95]),
        .R(\<const0> ));
  FDRE \q_reg[96] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[96]_i_1_n_0 ),
        .Q(q_OBUF[96]),
        .R(\<const0> ));
  FDRE \q_reg[97] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[97]_i_1_n_0 ),
        .Q(q_OBUF[97]),
        .R(\<const0> ));
  FDRE \q_reg[98] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[98]_i_1_n_0 ),
        .Q(q_OBUF[98]),
        .R(\<const0> ));
  FDRE \q_reg[99] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[99]_i_2_n_0 ),
        .Q(q_OBUF[99]),
        .R(\<const0> ));
  FDRE \q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\q[99]_i_1_n_0 ),
        .D(\q[9]_i_1_n_0 ),
        .Q(q_OBUF[9]),
        .R(\<const0> ));
endmodule
