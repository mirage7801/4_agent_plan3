// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 21:07:46 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_l23ikg3v/synth_netlist.v
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
    sel,
    out);
  input [99:0]a;
  input [99:0]b;
  input sel;
  output [99:0]out;

  wire [99:0]a;
  wire [99:0]a_IBUF;
  wire [99:0]b;
  wire [99:0]b_IBUF;
  wire [99:0]out;
  wire [99:0]out_OBUF;
  wire sel;
  wire sel_IBUF;

  IBUF \a_IBUF[0]_inst 
       (.I(a[0]),
        .O(a_IBUF[0]));
  IBUF \a_IBUF[10]_inst 
       (.I(a[10]),
        .O(a_IBUF[10]));
  IBUF \a_IBUF[11]_inst 
       (.I(a[11]),
        .O(a_IBUF[11]));
  IBUF \a_IBUF[12]_inst 
       (.I(a[12]),
        .O(a_IBUF[12]));
  IBUF \a_IBUF[13]_inst 
       (.I(a[13]),
        .O(a_IBUF[13]));
  IBUF \a_IBUF[14]_inst 
       (.I(a[14]),
        .O(a_IBUF[14]));
  IBUF \a_IBUF[15]_inst 
       (.I(a[15]),
        .O(a_IBUF[15]));
  IBUF \a_IBUF[16]_inst 
       (.I(a[16]),
        .O(a_IBUF[16]));
  IBUF \a_IBUF[17]_inst 
       (.I(a[17]),
        .O(a_IBUF[17]));
  IBUF \a_IBUF[18]_inst 
       (.I(a[18]),
        .O(a_IBUF[18]));
  IBUF \a_IBUF[19]_inst 
       (.I(a[19]),
        .O(a_IBUF[19]));
  IBUF \a_IBUF[1]_inst 
       (.I(a[1]),
        .O(a_IBUF[1]));
  IBUF \a_IBUF[20]_inst 
       (.I(a[20]),
        .O(a_IBUF[20]));
  IBUF \a_IBUF[21]_inst 
       (.I(a[21]),
        .O(a_IBUF[21]));
  IBUF \a_IBUF[22]_inst 
       (.I(a[22]),
        .O(a_IBUF[22]));
  IBUF \a_IBUF[23]_inst 
       (.I(a[23]),
        .O(a_IBUF[23]));
  IBUF \a_IBUF[24]_inst 
       (.I(a[24]),
        .O(a_IBUF[24]));
  IBUF \a_IBUF[25]_inst 
       (.I(a[25]),
        .O(a_IBUF[25]));
  IBUF \a_IBUF[26]_inst 
       (.I(a[26]),
        .O(a_IBUF[26]));
  IBUF \a_IBUF[27]_inst 
       (.I(a[27]),
        .O(a_IBUF[27]));
  IBUF \a_IBUF[28]_inst 
       (.I(a[28]),
        .O(a_IBUF[28]));
  IBUF \a_IBUF[29]_inst 
       (.I(a[29]),
        .O(a_IBUF[29]));
  IBUF \a_IBUF[2]_inst 
       (.I(a[2]),
        .O(a_IBUF[2]));
  IBUF \a_IBUF[30]_inst 
       (.I(a[30]),
        .O(a_IBUF[30]));
  IBUF \a_IBUF[31]_inst 
       (.I(a[31]),
        .O(a_IBUF[31]));
  IBUF \a_IBUF[32]_inst 
       (.I(a[32]),
        .O(a_IBUF[32]));
  IBUF \a_IBUF[33]_inst 
       (.I(a[33]),
        .O(a_IBUF[33]));
  IBUF \a_IBUF[34]_inst 
       (.I(a[34]),
        .O(a_IBUF[34]));
  IBUF \a_IBUF[35]_inst 
       (.I(a[35]),
        .O(a_IBUF[35]));
  IBUF \a_IBUF[36]_inst 
       (.I(a[36]),
        .O(a_IBUF[36]));
  IBUF \a_IBUF[37]_inst 
       (.I(a[37]),
        .O(a_IBUF[37]));
  IBUF \a_IBUF[38]_inst 
       (.I(a[38]),
        .O(a_IBUF[38]));
  IBUF \a_IBUF[39]_inst 
       (.I(a[39]),
        .O(a_IBUF[39]));
  IBUF \a_IBUF[3]_inst 
       (.I(a[3]),
        .O(a_IBUF[3]));
  IBUF \a_IBUF[40]_inst 
       (.I(a[40]),
        .O(a_IBUF[40]));
  IBUF \a_IBUF[41]_inst 
       (.I(a[41]),
        .O(a_IBUF[41]));
  IBUF \a_IBUF[42]_inst 
       (.I(a[42]),
        .O(a_IBUF[42]));
  IBUF \a_IBUF[43]_inst 
       (.I(a[43]),
        .O(a_IBUF[43]));
  IBUF \a_IBUF[44]_inst 
       (.I(a[44]),
        .O(a_IBUF[44]));
  IBUF \a_IBUF[45]_inst 
       (.I(a[45]),
        .O(a_IBUF[45]));
  IBUF \a_IBUF[46]_inst 
       (.I(a[46]),
        .O(a_IBUF[46]));
  IBUF \a_IBUF[47]_inst 
       (.I(a[47]),
        .O(a_IBUF[47]));
  IBUF \a_IBUF[48]_inst 
       (.I(a[48]),
        .O(a_IBUF[48]));
  IBUF \a_IBUF[49]_inst 
       (.I(a[49]),
        .O(a_IBUF[49]));
  IBUF \a_IBUF[4]_inst 
       (.I(a[4]),
        .O(a_IBUF[4]));
  IBUF \a_IBUF[50]_inst 
       (.I(a[50]),
        .O(a_IBUF[50]));
  IBUF \a_IBUF[51]_inst 
       (.I(a[51]),
        .O(a_IBUF[51]));
  IBUF \a_IBUF[52]_inst 
       (.I(a[52]),
        .O(a_IBUF[52]));
  IBUF \a_IBUF[53]_inst 
       (.I(a[53]),
        .O(a_IBUF[53]));
  IBUF \a_IBUF[54]_inst 
       (.I(a[54]),
        .O(a_IBUF[54]));
  IBUF \a_IBUF[55]_inst 
       (.I(a[55]),
        .O(a_IBUF[55]));
  IBUF \a_IBUF[56]_inst 
       (.I(a[56]),
        .O(a_IBUF[56]));
  IBUF \a_IBUF[57]_inst 
       (.I(a[57]),
        .O(a_IBUF[57]));
  IBUF \a_IBUF[58]_inst 
       (.I(a[58]),
        .O(a_IBUF[58]));
  IBUF \a_IBUF[59]_inst 
       (.I(a[59]),
        .O(a_IBUF[59]));
  IBUF \a_IBUF[5]_inst 
       (.I(a[5]),
        .O(a_IBUF[5]));
  IBUF \a_IBUF[60]_inst 
       (.I(a[60]),
        .O(a_IBUF[60]));
  IBUF \a_IBUF[61]_inst 
       (.I(a[61]),
        .O(a_IBUF[61]));
  IBUF \a_IBUF[62]_inst 
       (.I(a[62]),
        .O(a_IBUF[62]));
  IBUF \a_IBUF[63]_inst 
       (.I(a[63]),
        .O(a_IBUF[63]));
  IBUF \a_IBUF[64]_inst 
       (.I(a[64]),
        .O(a_IBUF[64]));
  IBUF \a_IBUF[65]_inst 
       (.I(a[65]),
        .O(a_IBUF[65]));
  IBUF \a_IBUF[66]_inst 
       (.I(a[66]),
        .O(a_IBUF[66]));
  IBUF \a_IBUF[67]_inst 
       (.I(a[67]),
        .O(a_IBUF[67]));
  IBUF \a_IBUF[68]_inst 
       (.I(a[68]),
        .O(a_IBUF[68]));
  IBUF \a_IBUF[69]_inst 
       (.I(a[69]),
        .O(a_IBUF[69]));
  IBUF \a_IBUF[6]_inst 
       (.I(a[6]),
        .O(a_IBUF[6]));
  IBUF \a_IBUF[70]_inst 
       (.I(a[70]),
        .O(a_IBUF[70]));
  IBUF \a_IBUF[71]_inst 
       (.I(a[71]),
        .O(a_IBUF[71]));
  IBUF \a_IBUF[72]_inst 
       (.I(a[72]),
        .O(a_IBUF[72]));
  IBUF \a_IBUF[73]_inst 
       (.I(a[73]),
        .O(a_IBUF[73]));
  IBUF \a_IBUF[74]_inst 
       (.I(a[74]),
        .O(a_IBUF[74]));
  IBUF \a_IBUF[75]_inst 
       (.I(a[75]),
        .O(a_IBUF[75]));
  IBUF \a_IBUF[76]_inst 
       (.I(a[76]),
        .O(a_IBUF[76]));
  IBUF \a_IBUF[77]_inst 
       (.I(a[77]),
        .O(a_IBUF[77]));
  IBUF \a_IBUF[78]_inst 
       (.I(a[78]),
        .O(a_IBUF[78]));
  IBUF \a_IBUF[79]_inst 
       (.I(a[79]),
        .O(a_IBUF[79]));
  IBUF \a_IBUF[7]_inst 
       (.I(a[7]),
        .O(a_IBUF[7]));
  IBUF \a_IBUF[80]_inst 
       (.I(a[80]),
        .O(a_IBUF[80]));
  IBUF \a_IBUF[81]_inst 
       (.I(a[81]),
        .O(a_IBUF[81]));
  IBUF \a_IBUF[82]_inst 
       (.I(a[82]),
        .O(a_IBUF[82]));
  IBUF \a_IBUF[83]_inst 
       (.I(a[83]),
        .O(a_IBUF[83]));
  IBUF \a_IBUF[84]_inst 
       (.I(a[84]),
        .O(a_IBUF[84]));
  IBUF \a_IBUF[85]_inst 
       (.I(a[85]),
        .O(a_IBUF[85]));
  IBUF \a_IBUF[86]_inst 
       (.I(a[86]),
        .O(a_IBUF[86]));
  IBUF \a_IBUF[87]_inst 
       (.I(a[87]),
        .O(a_IBUF[87]));
  IBUF \a_IBUF[88]_inst 
       (.I(a[88]),
        .O(a_IBUF[88]));
  IBUF \a_IBUF[89]_inst 
       (.I(a[89]),
        .O(a_IBUF[89]));
  IBUF \a_IBUF[8]_inst 
       (.I(a[8]),
        .O(a_IBUF[8]));
  IBUF \a_IBUF[90]_inst 
       (.I(a[90]),
        .O(a_IBUF[90]));
  IBUF \a_IBUF[91]_inst 
       (.I(a[91]),
        .O(a_IBUF[91]));
  IBUF \a_IBUF[92]_inst 
       (.I(a[92]),
        .O(a_IBUF[92]));
  IBUF \a_IBUF[93]_inst 
       (.I(a[93]),
        .O(a_IBUF[93]));
  IBUF \a_IBUF[94]_inst 
       (.I(a[94]),
        .O(a_IBUF[94]));
  IBUF \a_IBUF[95]_inst 
       (.I(a[95]),
        .O(a_IBUF[95]));
  IBUF \a_IBUF[96]_inst 
       (.I(a[96]),
        .O(a_IBUF[96]));
  IBUF \a_IBUF[97]_inst 
       (.I(a[97]),
        .O(a_IBUF[97]));
  IBUF \a_IBUF[98]_inst 
       (.I(a[98]),
        .O(a_IBUF[98]));
  IBUF \a_IBUF[99]_inst 
       (.I(a[99]),
        .O(a_IBUF[99]));
  IBUF \a_IBUF[9]_inst 
       (.I(a[9]),
        .O(a_IBUF[9]));
  IBUF \b_IBUF[0]_inst 
       (.I(b[0]),
        .O(b_IBUF[0]));
  IBUF \b_IBUF[10]_inst 
       (.I(b[10]),
        .O(b_IBUF[10]));
  IBUF \b_IBUF[11]_inst 
       (.I(b[11]),
        .O(b_IBUF[11]));
  IBUF \b_IBUF[12]_inst 
       (.I(b[12]),
        .O(b_IBUF[12]));
  IBUF \b_IBUF[13]_inst 
       (.I(b[13]),
        .O(b_IBUF[13]));
  IBUF \b_IBUF[14]_inst 
       (.I(b[14]),
        .O(b_IBUF[14]));
  IBUF \b_IBUF[15]_inst 
       (.I(b[15]),
        .O(b_IBUF[15]));
  IBUF \b_IBUF[16]_inst 
       (.I(b[16]),
        .O(b_IBUF[16]));
  IBUF \b_IBUF[17]_inst 
       (.I(b[17]),
        .O(b_IBUF[17]));
  IBUF \b_IBUF[18]_inst 
       (.I(b[18]),
        .O(b_IBUF[18]));
  IBUF \b_IBUF[19]_inst 
       (.I(b[19]),
        .O(b_IBUF[19]));
  IBUF \b_IBUF[1]_inst 
       (.I(b[1]),
        .O(b_IBUF[1]));
  IBUF \b_IBUF[20]_inst 
       (.I(b[20]),
        .O(b_IBUF[20]));
  IBUF \b_IBUF[21]_inst 
       (.I(b[21]),
        .O(b_IBUF[21]));
  IBUF \b_IBUF[22]_inst 
       (.I(b[22]),
        .O(b_IBUF[22]));
  IBUF \b_IBUF[23]_inst 
       (.I(b[23]),
        .O(b_IBUF[23]));
  IBUF \b_IBUF[24]_inst 
       (.I(b[24]),
        .O(b_IBUF[24]));
  IBUF \b_IBUF[25]_inst 
       (.I(b[25]),
        .O(b_IBUF[25]));
  IBUF \b_IBUF[26]_inst 
       (.I(b[26]),
        .O(b_IBUF[26]));
  IBUF \b_IBUF[27]_inst 
       (.I(b[27]),
        .O(b_IBUF[27]));
  IBUF \b_IBUF[28]_inst 
       (.I(b[28]),
        .O(b_IBUF[28]));
  IBUF \b_IBUF[29]_inst 
       (.I(b[29]),
        .O(b_IBUF[29]));
  IBUF \b_IBUF[2]_inst 
       (.I(b[2]),
        .O(b_IBUF[2]));
  IBUF \b_IBUF[30]_inst 
       (.I(b[30]),
        .O(b_IBUF[30]));
  IBUF \b_IBUF[31]_inst 
       (.I(b[31]),
        .O(b_IBUF[31]));
  IBUF \b_IBUF[32]_inst 
       (.I(b[32]),
        .O(b_IBUF[32]));
  IBUF \b_IBUF[33]_inst 
       (.I(b[33]),
        .O(b_IBUF[33]));
  IBUF \b_IBUF[34]_inst 
       (.I(b[34]),
        .O(b_IBUF[34]));
  IBUF \b_IBUF[35]_inst 
       (.I(b[35]),
        .O(b_IBUF[35]));
  IBUF \b_IBUF[36]_inst 
       (.I(b[36]),
        .O(b_IBUF[36]));
  IBUF \b_IBUF[37]_inst 
       (.I(b[37]),
        .O(b_IBUF[37]));
  IBUF \b_IBUF[38]_inst 
       (.I(b[38]),
        .O(b_IBUF[38]));
  IBUF \b_IBUF[39]_inst 
       (.I(b[39]),
        .O(b_IBUF[39]));
  IBUF \b_IBUF[3]_inst 
       (.I(b[3]),
        .O(b_IBUF[3]));
  IBUF \b_IBUF[40]_inst 
       (.I(b[40]),
        .O(b_IBUF[40]));
  IBUF \b_IBUF[41]_inst 
       (.I(b[41]),
        .O(b_IBUF[41]));
  IBUF \b_IBUF[42]_inst 
       (.I(b[42]),
        .O(b_IBUF[42]));
  IBUF \b_IBUF[43]_inst 
       (.I(b[43]),
        .O(b_IBUF[43]));
  IBUF \b_IBUF[44]_inst 
       (.I(b[44]),
        .O(b_IBUF[44]));
  IBUF \b_IBUF[45]_inst 
       (.I(b[45]),
        .O(b_IBUF[45]));
  IBUF \b_IBUF[46]_inst 
       (.I(b[46]),
        .O(b_IBUF[46]));
  IBUF \b_IBUF[47]_inst 
       (.I(b[47]),
        .O(b_IBUF[47]));
  IBUF \b_IBUF[48]_inst 
       (.I(b[48]),
        .O(b_IBUF[48]));
  IBUF \b_IBUF[49]_inst 
       (.I(b[49]),
        .O(b_IBUF[49]));
  IBUF \b_IBUF[4]_inst 
       (.I(b[4]),
        .O(b_IBUF[4]));
  IBUF \b_IBUF[50]_inst 
       (.I(b[50]),
        .O(b_IBUF[50]));
  IBUF \b_IBUF[51]_inst 
       (.I(b[51]),
        .O(b_IBUF[51]));
  IBUF \b_IBUF[52]_inst 
       (.I(b[52]),
        .O(b_IBUF[52]));
  IBUF \b_IBUF[53]_inst 
       (.I(b[53]),
        .O(b_IBUF[53]));
  IBUF \b_IBUF[54]_inst 
       (.I(b[54]),
        .O(b_IBUF[54]));
  IBUF \b_IBUF[55]_inst 
       (.I(b[55]),
        .O(b_IBUF[55]));
  IBUF \b_IBUF[56]_inst 
       (.I(b[56]),
        .O(b_IBUF[56]));
  IBUF \b_IBUF[57]_inst 
       (.I(b[57]),
        .O(b_IBUF[57]));
  IBUF \b_IBUF[58]_inst 
       (.I(b[58]),
        .O(b_IBUF[58]));
  IBUF \b_IBUF[59]_inst 
       (.I(b[59]),
        .O(b_IBUF[59]));
  IBUF \b_IBUF[5]_inst 
       (.I(b[5]),
        .O(b_IBUF[5]));
  IBUF \b_IBUF[60]_inst 
       (.I(b[60]),
        .O(b_IBUF[60]));
  IBUF \b_IBUF[61]_inst 
       (.I(b[61]),
        .O(b_IBUF[61]));
  IBUF \b_IBUF[62]_inst 
       (.I(b[62]),
        .O(b_IBUF[62]));
  IBUF \b_IBUF[63]_inst 
       (.I(b[63]),
        .O(b_IBUF[63]));
  IBUF \b_IBUF[64]_inst 
       (.I(b[64]),
        .O(b_IBUF[64]));
  IBUF \b_IBUF[65]_inst 
       (.I(b[65]),
        .O(b_IBUF[65]));
  IBUF \b_IBUF[66]_inst 
       (.I(b[66]),
        .O(b_IBUF[66]));
  IBUF \b_IBUF[67]_inst 
       (.I(b[67]),
        .O(b_IBUF[67]));
  IBUF \b_IBUF[68]_inst 
       (.I(b[68]),
        .O(b_IBUF[68]));
  IBUF \b_IBUF[69]_inst 
       (.I(b[69]),
        .O(b_IBUF[69]));
  IBUF \b_IBUF[6]_inst 
       (.I(b[6]),
        .O(b_IBUF[6]));
  IBUF \b_IBUF[70]_inst 
       (.I(b[70]),
        .O(b_IBUF[70]));
  IBUF \b_IBUF[71]_inst 
       (.I(b[71]),
        .O(b_IBUF[71]));
  IBUF \b_IBUF[72]_inst 
       (.I(b[72]),
        .O(b_IBUF[72]));
  IBUF \b_IBUF[73]_inst 
       (.I(b[73]),
        .O(b_IBUF[73]));
  IBUF \b_IBUF[74]_inst 
       (.I(b[74]),
        .O(b_IBUF[74]));
  IBUF \b_IBUF[75]_inst 
       (.I(b[75]),
        .O(b_IBUF[75]));
  IBUF \b_IBUF[76]_inst 
       (.I(b[76]),
        .O(b_IBUF[76]));
  IBUF \b_IBUF[77]_inst 
       (.I(b[77]),
        .O(b_IBUF[77]));
  IBUF \b_IBUF[78]_inst 
       (.I(b[78]),
        .O(b_IBUF[78]));
  IBUF \b_IBUF[79]_inst 
       (.I(b[79]),
        .O(b_IBUF[79]));
  IBUF \b_IBUF[7]_inst 
       (.I(b[7]),
        .O(b_IBUF[7]));
  IBUF \b_IBUF[80]_inst 
       (.I(b[80]),
        .O(b_IBUF[80]));
  IBUF \b_IBUF[81]_inst 
       (.I(b[81]),
        .O(b_IBUF[81]));
  IBUF \b_IBUF[82]_inst 
       (.I(b[82]),
        .O(b_IBUF[82]));
  IBUF \b_IBUF[83]_inst 
       (.I(b[83]),
        .O(b_IBUF[83]));
  IBUF \b_IBUF[84]_inst 
       (.I(b[84]),
        .O(b_IBUF[84]));
  IBUF \b_IBUF[85]_inst 
       (.I(b[85]),
        .O(b_IBUF[85]));
  IBUF \b_IBUF[86]_inst 
       (.I(b[86]),
        .O(b_IBUF[86]));
  IBUF \b_IBUF[87]_inst 
       (.I(b[87]),
        .O(b_IBUF[87]));
  IBUF \b_IBUF[88]_inst 
       (.I(b[88]),
        .O(b_IBUF[88]));
  IBUF \b_IBUF[89]_inst 
       (.I(b[89]),
        .O(b_IBUF[89]));
  IBUF \b_IBUF[8]_inst 
       (.I(b[8]),
        .O(b_IBUF[8]));
  IBUF \b_IBUF[90]_inst 
       (.I(b[90]),
        .O(b_IBUF[90]));
  IBUF \b_IBUF[91]_inst 
       (.I(b[91]),
        .O(b_IBUF[91]));
  IBUF \b_IBUF[92]_inst 
       (.I(b[92]),
        .O(b_IBUF[92]));
  IBUF \b_IBUF[93]_inst 
       (.I(b[93]),
        .O(b_IBUF[93]));
  IBUF \b_IBUF[94]_inst 
       (.I(b[94]),
        .O(b_IBUF[94]));
  IBUF \b_IBUF[95]_inst 
       (.I(b[95]),
        .O(b_IBUF[95]));
  IBUF \b_IBUF[96]_inst 
       (.I(b[96]),
        .O(b_IBUF[96]));
  IBUF \b_IBUF[97]_inst 
       (.I(b[97]),
        .O(b_IBUF[97]));
  IBUF \b_IBUF[98]_inst 
       (.I(b[98]),
        .O(b_IBUF[98]));
  IBUF \b_IBUF[99]_inst 
       (.I(b[99]),
        .O(b_IBUF[99]));
  IBUF \b_IBUF[9]_inst 
       (.I(b[9]),
        .O(b_IBUF[9]));
  OBUF \out_OBUF[0]_inst 
       (.I(out_OBUF[0]),
        .O(out[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[0]_inst_i_1 
       (.I0(b_IBUF[0]),
        .I1(a_IBUF[0]),
        .I2(sel_IBUF),
        .O(out_OBUF[0]));
  OBUF \out_OBUF[10]_inst 
       (.I(out_OBUF[10]),
        .O(out[10]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[10]_inst_i_1 
       (.I0(b_IBUF[10]),
        .I1(a_IBUF[10]),
        .I2(sel_IBUF),
        .O(out_OBUF[10]));
  OBUF \out_OBUF[11]_inst 
       (.I(out_OBUF[11]),
        .O(out[11]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[11]_inst_i_1 
       (.I0(b_IBUF[11]),
        .I1(a_IBUF[11]),
        .I2(sel_IBUF),
        .O(out_OBUF[11]));
  OBUF \out_OBUF[12]_inst 
       (.I(out_OBUF[12]),
        .O(out[12]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[12]_inst_i_1 
       (.I0(b_IBUF[12]),
        .I1(a_IBUF[12]),
        .I2(sel_IBUF),
        .O(out_OBUF[12]));
  OBUF \out_OBUF[13]_inst 
       (.I(out_OBUF[13]),
        .O(out[13]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[13]_inst_i_1 
       (.I0(b_IBUF[13]),
        .I1(a_IBUF[13]),
        .I2(sel_IBUF),
        .O(out_OBUF[13]));
  OBUF \out_OBUF[14]_inst 
       (.I(out_OBUF[14]),
        .O(out[14]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[14]_inst_i_1 
       (.I0(b_IBUF[14]),
        .I1(a_IBUF[14]),
        .I2(sel_IBUF),
        .O(out_OBUF[14]));
  OBUF \out_OBUF[15]_inst 
       (.I(out_OBUF[15]),
        .O(out[15]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[15]_inst_i_1 
       (.I0(b_IBUF[15]),
        .I1(a_IBUF[15]),
        .I2(sel_IBUF),
        .O(out_OBUF[15]));
  OBUF \out_OBUF[16]_inst 
       (.I(out_OBUF[16]),
        .O(out[16]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[16]_inst_i_1 
       (.I0(b_IBUF[16]),
        .I1(a_IBUF[16]),
        .I2(sel_IBUF),
        .O(out_OBUF[16]));
  OBUF \out_OBUF[17]_inst 
       (.I(out_OBUF[17]),
        .O(out[17]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[17]_inst_i_1 
       (.I0(b_IBUF[17]),
        .I1(a_IBUF[17]),
        .I2(sel_IBUF),
        .O(out_OBUF[17]));
  OBUF \out_OBUF[18]_inst 
       (.I(out_OBUF[18]),
        .O(out[18]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[18]_inst_i_1 
       (.I0(b_IBUF[18]),
        .I1(a_IBUF[18]),
        .I2(sel_IBUF),
        .O(out_OBUF[18]));
  OBUF \out_OBUF[19]_inst 
       (.I(out_OBUF[19]),
        .O(out[19]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[19]_inst_i_1 
       (.I0(b_IBUF[19]),
        .I1(a_IBUF[19]),
        .I2(sel_IBUF),
        .O(out_OBUF[19]));
  OBUF \out_OBUF[1]_inst 
       (.I(out_OBUF[1]),
        .O(out[1]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[1]_inst_i_1 
       (.I0(b_IBUF[1]),
        .I1(a_IBUF[1]),
        .I2(sel_IBUF),
        .O(out_OBUF[1]));
  OBUF \out_OBUF[20]_inst 
       (.I(out_OBUF[20]),
        .O(out[20]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[20]_inst_i_1 
       (.I0(b_IBUF[20]),
        .I1(a_IBUF[20]),
        .I2(sel_IBUF),
        .O(out_OBUF[20]));
  OBUF \out_OBUF[21]_inst 
       (.I(out_OBUF[21]),
        .O(out[21]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[21]_inst_i_1 
       (.I0(b_IBUF[21]),
        .I1(a_IBUF[21]),
        .I2(sel_IBUF),
        .O(out_OBUF[21]));
  OBUF \out_OBUF[22]_inst 
       (.I(out_OBUF[22]),
        .O(out[22]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[22]_inst_i_1 
       (.I0(b_IBUF[22]),
        .I1(a_IBUF[22]),
        .I2(sel_IBUF),
        .O(out_OBUF[22]));
  OBUF \out_OBUF[23]_inst 
       (.I(out_OBUF[23]),
        .O(out[23]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[23]_inst_i_1 
       (.I0(b_IBUF[23]),
        .I1(a_IBUF[23]),
        .I2(sel_IBUF),
        .O(out_OBUF[23]));
  OBUF \out_OBUF[24]_inst 
       (.I(out_OBUF[24]),
        .O(out[24]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[24]_inst_i_1 
       (.I0(b_IBUF[24]),
        .I1(a_IBUF[24]),
        .I2(sel_IBUF),
        .O(out_OBUF[24]));
  OBUF \out_OBUF[25]_inst 
       (.I(out_OBUF[25]),
        .O(out[25]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[25]_inst_i_1 
       (.I0(b_IBUF[25]),
        .I1(a_IBUF[25]),
        .I2(sel_IBUF),
        .O(out_OBUF[25]));
  OBUF \out_OBUF[26]_inst 
       (.I(out_OBUF[26]),
        .O(out[26]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[26]_inst_i_1 
       (.I0(b_IBUF[26]),
        .I1(a_IBUF[26]),
        .I2(sel_IBUF),
        .O(out_OBUF[26]));
  OBUF \out_OBUF[27]_inst 
       (.I(out_OBUF[27]),
        .O(out[27]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[27]_inst_i_1 
       (.I0(b_IBUF[27]),
        .I1(a_IBUF[27]),
        .I2(sel_IBUF),
        .O(out_OBUF[27]));
  OBUF \out_OBUF[28]_inst 
       (.I(out_OBUF[28]),
        .O(out[28]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[28]_inst_i_1 
       (.I0(b_IBUF[28]),
        .I1(a_IBUF[28]),
        .I2(sel_IBUF),
        .O(out_OBUF[28]));
  OBUF \out_OBUF[29]_inst 
       (.I(out_OBUF[29]),
        .O(out[29]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[29]_inst_i_1 
       (.I0(b_IBUF[29]),
        .I1(a_IBUF[29]),
        .I2(sel_IBUF),
        .O(out_OBUF[29]));
  OBUF \out_OBUF[2]_inst 
       (.I(out_OBUF[2]),
        .O(out[2]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[2]_inst_i_1 
       (.I0(b_IBUF[2]),
        .I1(a_IBUF[2]),
        .I2(sel_IBUF),
        .O(out_OBUF[2]));
  OBUF \out_OBUF[30]_inst 
       (.I(out_OBUF[30]),
        .O(out[30]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[30]_inst_i_1 
       (.I0(b_IBUF[30]),
        .I1(a_IBUF[30]),
        .I2(sel_IBUF),
        .O(out_OBUF[30]));
  OBUF \out_OBUF[31]_inst 
       (.I(out_OBUF[31]),
        .O(out[31]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[31]_inst_i_1 
       (.I0(b_IBUF[31]),
        .I1(a_IBUF[31]),
        .I2(sel_IBUF),
        .O(out_OBUF[31]));
  OBUF \out_OBUF[32]_inst 
       (.I(out_OBUF[32]),
        .O(out[32]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[32]_inst_i_1 
       (.I0(b_IBUF[32]),
        .I1(a_IBUF[32]),
        .I2(sel_IBUF),
        .O(out_OBUF[32]));
  OBUF \out_OBUF[33]_inst 
       (.I(out_OBUF[33]),
        .O(out[33]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[33]_inst_i_1 
       (.I0(b_IBUF[33]),
        .I1(a_IBUF[33]),
        .I2(sel_IBUF),
        .O(out_OBUF[33]));
  OBUF \out_OBUF[34]_inst 
       (.I(out_OBUF[34]),
        .O(out[34]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[34]_inst_i_1 
       (.I0(b_IBUF[34]),
        .I1(a_IBUF[34]),
        .I2(sel_IBUF),
        .O(out_OBUF[34]));
  OBUF \out_OBUF[35]_inst 
       (.I(out_OBUF[35]),
        .O(out[35]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[35]_inst_i_1 
       (.I0(b_IBUF[35]),
        .I1(a_IBUF[35]),
        .I2(sel_IBUF),
        .O(out_OBUF[35]));
  OBUF \out_OBUF[36]_inst 
       (.I(out_OBUF[36]),
        .O(out[36]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[36]_inst_i_1 
       (.I0(b_IBUF[36]),
        .I1(a_IBUF[36]),
        .I2(sel_IBUF),
        .O(out_OBUF[36]));
  OBUF \out_OBUF[37]_inst 
       (.I(out_OBUF[37]),
        .O(out[37]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[37]_inst_i_1 
       (.I0(b_IBUF[37]),
        .I1(a_IBUF[37]),
        .I2(sel_IBUF),
        .O(out_OBUF[37]));
  OBUF \out_OBUF[38]_inst 
       (.I(out_OBUF[38]),
        .O(out[38]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[38]_inst_i_1 
       (.I0(b_IBUF[38]),
        .I1(a_IBUF[38]),
        .I2(sel_IBUF),
        .O(out_OBUF[38]));
  OBUF \out_OBUF[39]_inst 
       (.I(out_OBUF[39]),
        .O(out[39]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[39]_inst_i_1 
       (.I0(b_IBUF[39]),
        .I1(a_IBUF[39]),
        .I2(sel_IBUF),
        .O(out_OBUF[39]));
  OBUF \out_OBUF[3]_inst 
       (.I(out_OBUF[3]),
        .O(out[3]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[3]_inst_i_1 
       (.I0(b_IBUF[3]),
        .I1(a_IBUF[3]),
        .I2(sel_IBUF),
        .O(out_OBUF[3]));
  OBUF \out_OBUF[40]_inst 
       (.I(out_OBUF[40]),
        .O(out[40]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[40]_inst_i_1 
       (.I0(b_IBUF[40]),
        .I1(a_IBUF[40]),
        .I2(sel_IBUF),
        .O(out_OBUF[40]));
  OBUF \out_OBUF[41]_inst 
       (.I(out_OBUF[41]),
        .O(out[41]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[41]_inst_i_1 
       (.I0(b_IBUF[41]),
        .I1(a_IBUF[41]),
        .I2(sel_IBUF),
        .O(out_OBUF[41]));
  OBUF \out_OBUF[42]_inst 
       (.I(out_OBUF[42]),
        .O(out[42]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[42]_inst_i_1 
       (.I0(b_IBUF[42]),
        .I1(a_IBUF[42]),
        .I2(sel_IBUF),
        .O(out_OBUF[42]));
  OBUF \out_OBUF[43]_inst 
       (.I(out_OBUF[43]),
        .O(out[43]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[43]_inst_i_1 
       (.I0(b_IBUF[43]),
        .I1(a_IBUF[43]),
        .I2(sel_IBUF),
        .O(out_OBUF[43]));
  OBUF \out_OBUF[44]_inst 
       (.I(out_OBUF[44]),
        .O(out[44]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[44]_inst_i_1 
       (.I0(b_IBUF[44]),
        .I1(a_IBUF[44]),
        .I2(sel_IBUF),
        .O(out_OBUF[44]));
  OBUF \out_OBUF[45]_inst 
       (.I(out_OBUF[45]),
        .O(out[45]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[45]_inst_i_1 
       (.I0(b_IBUF[45]),
        .I1(a_IBUF[45]),
        .I2(sel_IBUF),
        .O(out_OBUF[45]));
  OBUF \out_OBUF[46]_inst 
       (.I(out_OBUF[46]),
        .O(out[46]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[46]_inst_i_1 
       (.I0(b_IBUF[46]),
        .I1(a_IBUF[46]),
        .I2(sel_IBUF),
        .O(out_OBUF[46]));
  OBUF \out_OBUF[47]_inst 
       (.I(out_OBUF[47]),
        .O(out[47]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[47]_inst_i_1 
       (.I0(b_IBUF[47]),
        .I1(a_IBUF[47]),
        .I2(sel_IBUF),
        .O(out_OBUF[47]));
  OBUF \out_OBUF[48]_inst 
       (.I(out_OBUF[48]),
        .O(out[48]));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[48]_inst_i_1 
       (.I0(b_IBUF[48]),
        .I1(a_IBUF[48]),
        .I2(sel_IBUF),
        .O(out_OBUF[48]));
  OBUF \out_OBUF[49]_inst 
       (.I(out_OBUF[49]),
        .O(out[49]));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[49]_inst_i_1 
       (.I0(b_IBUF[49]),
        .I1(a_IBUF[49]),
        .I2(sel_IBUF),
        .O(out_OBUF[49]));
  OBUF \out_OBUF[4]_inst 
       (.I(out_OBUF[4]),
        .O(out[4]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[4]_inst_i_1 
       (.I0(b_IBUF[4]),
        .I1(a_IBUF[4]),
        .I2(sel_IBUF),
        .O(out_OBUF[4]));
  OBUF \out_OBUF[50]_inst 
       (.I(out_OBUF[50]),
        .O(out[50]));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[50]_inst_i_1 
       (.I0(b_IBUF[50]),
        .I1(a_IBUF[50]),
        .I2(sel_IBUF),
        .O(out_OBUF[50]));
  OBUF \out_OBUF[51]_inst 
       (.I(out_OBUF[51]),
        .O(out[51]));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[51]_inst_i_1 
       (.I0(b_IBUF[51]),
        .I1(a_IBUF[51]),
        .I2(sel_IBUF),
        .O(out_OBUF[51]));
  OBUF \out_OBUF[52]_inst 
       (.I(out_OBUF[52]),
        .O(out[52]));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[52]_inst_i_1 
       (.I0(b_IBUF[52]),
        .I1(a_IBUF[52]),
        .I2(sel_IBUF),
        .O(out_OBUF[52]));
  OBUF \out_OBUF[53]_inst 
       (.I(out_OBUF[53]),
        .O(out[53]));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[53]_inst_i_1 
       (.I0(b_IBUF[53]),
        .I1(a_IBUF[53]),
        .I2(sel_IBUF),
        .O(out_OBUF[53]));
  OBUF \out_OBUF[54]_inst 
       (.I(out_OBUF[54]),
        .O(out[54]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[54]_inst_i_1 
       (.I0(b_IBUF[54]),
        .I1(a_IBUF[54]),
        .I2(sel_IBUF),
        .O(out_OBUF[54]));
  OBUF \out_OBUF[55]_inst 
       (.I(out_OBUF[55]),
        .O(out[55]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[55]_inst_i_1 
       (.I0(b_IBUF[55]),
        .I1(a_IBUF[55]),
        .I2(sel_IBUF),
        .O(out_OBUF[55]));
  OBUF \out_OBUF[56]_inst 
       (.I(out_OBUF[56]),
        .O(out[56]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[56]_inst_i_1 
       (.I0(b_IBUF[56]),
        .I1(a_IBUF[56]),
        .I2(sel_IBUF),
        .O(out_OBUF[56]));
  OBUF \out_OBUF[57]_inst 
       (.I(out_OBUF[57]),
        .O(out[57]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[57]_inst_i_1 
       (.I0(b_IBUF[57]),
        .I1(a_IBUF[57]),
        .I2(sel_IBUF),
        .O(out_OBUF[57]));
  OBUF \out_OBUF[58]_inst 
       (.I(out_OBUF[58]),
        .O(out[58]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[58]_inst_i_1 
       (.I0(b_IBUF[58]),
        .I1(a_IBUF[58]),
        .I2(sel_IBUF),
        .O(out_OBUF[58]));
  OBUF \out_OBUF[59]_inst 
       (.I(out_OBUF[59]),
        .O(out[59]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[59]_inst_i_1 
       (.I0(b_IBUF[59]),
        .I1(a_IBUF[59]),
        .I2(sel_IBUF),
        .O(out_OBUF[59]));
  OBUF \out_OBUF[5]_inst 
       (.I(out_OBUF[5]),
        .O(out[5]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[5]_inst_i_1 
       (.I0(b_IBUF[5]),
        .I1(a_IBUF[5]),
        .I2(sel_IBUF),
        .O(out_OBUF[5]));
  OBUF \out_OBUF[60]_inst 
       (.I(out_OBUF[60]),
        .O(out[60]));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[60]_inst_i_1 
       (.I0(b_IBUF[60]),
        .I1(a_IBUF[60]),
        .I2(sel_IBUF),
        .O(out_OBUF[60]));
  OBUF \out_OBUF[61]_inst 
       (.I(out_OBUF[61]),
        .O(out[61]));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[61]_inst_i_1 
       (.I0(b_IBUF[61]),
        .I1(a_IBUF[61]),
        .I2(sel_IBUF),
        .O(out_OBUF[61]));
  OBUF \out_OBUF[62]_inst 
       (.I(out_OBUF[62]),
        .O(out[62]));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[62]_inst_i_1 
       (.I0(b_IBUF[62]),
        .I1(a_IBUF[62]),
        .I2(sel_IBUF),
        .O(out_OBUF[62]));
  OBUF \out_OBUF[63]_inst 
       (.I(out_OBUF[63]),
        .O(out[63]));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[63]_inst_i_1 
       (.I0(b_IBUF[63]),
        .I1(a_IBUF[63]),
        .I2(sel_IBUF),
        .O(out_OBUF[63]));
  OBUF \out_OBUF[64]_inst 
       (.I(out_OBUF[64]),
        .O(out[64]));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[64]_inst_i_1 
       (.I0(b_IBUF[64]),
        .I1(a_IBUF[64]),
        .I2(sel_IBUF),
        .O(out_OBUF[64]));
  OBUF \out_OBUF[65]_inst 
       (.I(out_OBUF[65]),
        .O(out[65]));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[65]_inst_i_1 
       (.I0(b_IBUF[65]),
        .I1(a_IBUF[65]),
        .I2(sel_IBUF),
        .O(out_OBUF[65]));
  OBUF \out_OBUF[66]_inst 
       (.I(out_OBUF[66]),
        .O(out[66]));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[66]_inst_i_1 
       (.I0(b_IBUF[66]),
        .I1(a_IBUF[66]),
        .I2(sel_IBUF),
        .O(out_OBUF[66]));
  OBUF \out_OBUF[67]_inst 
       (.I(out_OBUF[67]),
        .O(out[67]));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[67]_inst_i_1 
       (.I0(b_IBUF[67]),
        .I1(a_IBUF[67]),
        .I2(sel_IBUF),
        .O(out_OBUF[67]));
  OBUF \out_OBUF[68]_inst 
       (.I(out_OBUF[68]),
        .O(out[68]));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[68]_inst_i_1 
       (.I0(b_IBUF[68]),
        .I1(a_IBUF[68]),
        .I2(sel_IBUF),
        .O(out_OBUF[68]));
  OBUF \out_OBUF[69]_inst 
       (.I(out_OBUF[69]),
        .O(out[69]));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[69]_inst_i_1 
       (.I0(b_IBUF[69]),
        .I1(a_IBUF[69]),
        .I2(sel_IBUF),
        .O(out_OBUF[69]));
  OBUF \out_OBUF[6]_inst 
       (.I(out_OBUF[6]),
        .O(out[6]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[6]_inst_i_1 
       (.I0(b_IBUF[6]),
        .I1(a_IBUF[6]),
        .I2(sel_IBUF),
        .O(out_OBUF[6]));
  OBUF \out_OBUF[70]_inst 
       (.I(out_OBUF[70]),
        .O(out[70]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[70]_inst_i_1 
       (.I0(b_IBUF[70]),
        .I1(a_IBUF[70]),
        .I2(sel_IBUF),
        .O(out_OBUF[70]));
  OBUF \out_OBUF[71]_inst 
       (.I(out_OBUF[71]),
        .O(out[71]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[71]_inst_i_1 
       (.I0(b_IBUF[71]),
        .I1(a_IBUF[71]),
        .I2(sel_IBUF),
        .O(out_OBUF[71]));
  OBUF \out_OBUF[72]_inst 
       (.I(out_OBUF[72]),
        .O(out[72]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[72]_inst_i_1 
       (.I0(b_IBUF[72]),
        .I1(a_IBUF[72]),
        .I2(sel_IBUF),
        .O(out_OBUF[72]));
  OBUF \out_OBUF[73]_inst 
       (.I(out_OBUF[73]),
        .O(out[73]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[73]_inst_i_1 
       (.I0(b_IBUF[73]),
        .I1(a_IBUF[73]),
        .I2(sel_IBUF),
        .O(out_OBUF[73]));
  OBUF \out_OBUF[74]_inst 
       (.I(out_OBUF[74]),
        .O(out[74]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[74]_inst_i_1 
       (.I0(b_IBUF[74]),
        .I1(a_IBUF[74]),
        .I2(sel_IBUF),
        .O(out_OBUF[74]));
  OBUF \out_OBUF[75]_inst 
       (.I(out_OBUF[75]),
        .O(out[75]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[75]_inst_i_1 
       (.I0(b_IBUF[75]),
        .I1(a_IBUF[75]),
        .I2(sel_IBUF),
        .O(out_OBUF[75]));
  OBUF \out_OBUF[76]_inst 
       (.I(out_OBUF[76]),
        .O(out[76]));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[76]_inst_i_1 
       (.I0(b_IBUF[76]),
        .I1(a_IBUF[76]),
        .I2(sel_IBUF),
        .O(out_OBUF[76]));
  OBUF \out_OBUF[77]_inst 
       (.I(out_OBUF[77]),
        .O(out[77]));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[77]_inst_i_1 
       (.I0(b_IBUF[77]),
        .I1(a_IBUF[77]),
        .I2(sel_IBUF),
        .O(out_OBUF[77]));
  OBUF \out_OBUF[78]_inst 
       (.I(out_OBUF[78]),
        .O(out[78]));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[78]_inst_i_1 
       (.I0(b_IBUF[78]),
        .I1(a_IBUF[78]),
        .I2(sel_IBUF),
        .O(out_OBUF[78]));
  OBUF \out_OBUF[79]_inst 
       (.I(out_OBUF[79]),
        .O(out[79]));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[79]_inst_i_1 
       (.I0(b_IBUF[79]),
        .I1(a_IBUF[79]),
        .I2(sel_IBUF),
        .O(out_OBUF[79]));
  OBUF \out_OBUF[7]_inst 
       (.I(out_OBUF[7]),
        .O(out[7]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[7]_inst_i_1 
       (.I0(b_IBUF[7]),
        .I1(a_IBUF[7]),
        .I2(sel_IBUF),
        .O(out_OBUF[7]));
  OBUF \out_OBUF[80]_inst 
       (.I(out_OBUF[80]),
        .O(out[80]));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[80]_inst_i_1 
       (.I0(b_IBUF[80]),
        .I1(a_IBUF[80]),
        .I2(sel_IBUF),
        .O(out_OBUF[80]));
  OBUF \out_OBUF[81]_inst 
       (.I(out_OBUF[81]),
        .O(out[81]));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[81]_inst_i_1 
       (.I0(b_IBUF[81]),
        .I1(a_IBUF[81]),
        .I2(sel_IBUF),
        .O(out_OBUF[81]));
  OBUF \out_OBUF[82]_inst 
       (.I(out_OBUF[82]),
        .O(out[82]));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[82]_inst_i_1 
       (.I0(b_IBUF[82]),
        .I1(a_IBUF[82]),
        .I2(sel_IBUF),
        .O(out_OBUF[82]));
  OBUF \out_OBUF[83]_inst 
       (.I(out_OBUF[83]),
        .O(out[83]));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[83]_inst_i_1 
       (.I0(b_IBUF[83]),
        .I1(a_IBUF[83]),
        .I2(sel_IBUF),
        .O(out_OBUF[83]));
  OBUF \out_OBUF[84]_inst 
       (.I(out_OBUF[84]),
        .O(out[84]));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[84]_inst_i_1 
       (.I0(b_IBUF[84]),
        .I1(a_IBUF[84]),
        .I2(sel_IBUF),
        .O(out_OBUF[84]));
  OBUF \out_OBUF[85]_inst 
       (.I(out_OBUF[85]),
        .O(out[85]));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[85]_inst_i_1 
       (.I0(b_IBUF[85]),
        .I1(a_IBUF[85]),
        .I2(sel_IBUF),
        .O(out_OBUF[85]));
  OBUF \out_OBUF[86]_inst 
       (.I(out_OBUF[86]),
        .O(out[86]));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[86]_inst_i_1 
       (.I0(b_IBUF[86]),
        .I1(a_IBUF[86]),
        .I2(sel_IBUF),
        .O(out_OBUF[86]));
  OBUF \out_OBUF[87]_inst 
       (.I(out_OBUF[87]),
        .O(out[87]));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[87]_inst_i_1 
       (.I0(b_IBUF[87]),
        .I1(a_IBUF[87]),
        .I2(sel_IBUF),
        .O(out_OBUF[87]));
  OBUF \out_OBUF[88]_inst 
       (.I(out_OBUF[88]),
        .O(out[88]));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[88]_inst_i_1 
       (.I0(b_IBUF[88]),
        .I1(a_IBUF[88]),
        .I2(sel_IBUF),
        .O(out_OBUF[88]));
  OBUF \out_OBUF[89]_inst 
       (.I(out_OBUF[89]),
        .O(out[89]));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[89]_inst_i_1 
       (.I0(b_IBUF[89]),
        .I1(a_IBUF[89]),
        .I2(sel_IBUF),
        .O(out_OBUF[89]));
  OBUF \out_OBUF[8]_inst 
       (.I(out_OBUF[8]),
        .O(out[8]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[8]_inst_i_1 
       (.I0(b_IBUF[8]),
        .I1(a_IBUF[8]),
        .I2(sel_IBUF),
        .O(out_OBUF[8]));
  OBUF \out_OBUF[90]_inst 
       (.I(out_OBUF[90]),
        .O(out[90]));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[90]_inst_i_1 
       (.I0(b_IBUF[90]),
        .I1(a_IBUF[90]),
        .I2(sel_IBUF),
        .O(out_OBUF[90]));
  OBUF \out_OBUF[91]_inst 
       (.I(out_OBUF[91]),
        .O(out[91]));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[91]_inst_i_1 
       (.I0(b_IBUF[91]),
        .I1(a_IBUF[91]),
        .I2(sel_IBUF),
        .O(out_OBUF[91]));
  OBUF \out_OBUF[92]_inst 
       (.I(out_OBUF[92]),
        .O(out[92]));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[92]_inst_i_1 
       (.I0(b_IBUF[92]),
        .I1(a_IBUF[92]),
        .I2(sel_IBUF),
        .O(out_OBUF[92]));
  OBUF \out_OBUF[93]_inst 
       (.I(out_OBUF[93]),
        .O(out[93]));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[93]_inst_i_1 
       (.I0(b_IBUF[93]),
        .I1(a_IBUF[93]),
        .I2(sel_IBUF),
        .O(out_OBUF[93]));
  OBUF \out_OBUF[94]_inst 
       (.I(out_OBUF[94]),
        .O(out[94]));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[94]_inst_i_1 
       (.I0(b_IBUF[94]),
        .I1(a_IBUF[94]),
        .I2(sel_IBUF),
        .O(out_OBUF[94]));
  OBUF \out_OBUF[95]_inst 
       (.I(out_OBUF[95]),
        .O(out[95]));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[95]_inst_i_1 
       (.I0(b_IBUF[95]),
        .I1(a_IBUF[95]),
        .I2(sel_IBUF),
        .O(out_OBUF[95]));
  OBUF \out_OBUF[96]_inst 
       (.I(out_OBUF[96]),
        .O(out[96]));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[96]_inst_i_1 
       (.I0(b_IBUF[96]),
        .I1(a_IBUF[96]),
        .I2(sel_IBUF),
        .O(out_OBUF[96]));
  OBUF \out_OBUF[97]_inst 
       (.I(out_OBUF[97]),
        .O(out[97]));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[97]_inst_i_1 
       (.I0(b_IBUF[97]),
        .I1(a_IBUF[97]),
        .I2(sel_IBUF),
        .O(out_OBUF[97]));
  OBUF \out_OBUF[98]_inst 
       (.I(out_OBUF[98]),
        .O(out[98]));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[98]_inst_i_1 
       (.I0(b_IBUF[98]),
        .I1(a_IBUF[98]),
        .I2(sel_IBUF),
        .O(out_OBUF[98]));
  OBUF \out_OBUF[99]_inst 
       (.I(out_OBUF[99]),
        .O(out[99]));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[99]_inst_i_1 
       (.I0(b_IBUF[99]),
        .I1(a_IBUF[99]),
        .I2(sel_IBUF),
        .O(out_OBUF[99]));
  OBUF \out_OBUF[9]_inst 
       (.I(out_OBUF[9]),
        .O(out[9]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \out_OBUF[9]_inst_i_1 
       (.I0(b_IBUF[9]),
        .I1(a_IBUF[9]),
        .I2(sel_IBUF),
        .O(out_OBUF[9]));
  IBUF sel_IBUF_inst
       (.I(sel),
        .O(sel_IBUF));
endmodule
