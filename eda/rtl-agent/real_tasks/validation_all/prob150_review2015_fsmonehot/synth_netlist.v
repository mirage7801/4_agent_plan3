// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Thu Oct  8 00:20:39 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_1p2o85_3/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* B0 = "4" *) (* B1 = "5" *) (* B2 = "6" *) 
(* B3 = "7" *) (* Count = "8" *) (* S = "0" *) 
(* S1 = "1" *) (* S11 = "2" *) (* S110 = "3" *) 
(* Wait = "9" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (d,
    done_counting,
    ack,
    state,
    B3_next,
    S_next,
    S1_next,
    Count_next,
    Wait_next,
    done,
    counting,
    shift_ena);
  input d;
  input done_counting;
  input ack;
  input [9:0]state;
  output B3_next;
  output S_next;
  output S1_next;
  output Count_next;
  output Wait_next;
  output done;
  output counting;
  output shift_ena;

  wire B3_next;
  wire B3_next_OBUF;
  wire Count_next;
  wire Count_next_OBUF;
  wire S1_next;
  wire S1_next_OBUF;
  wire S_next;
  wire S_next_OBUF;
  wire Wait_next;
  wire Wait_next_OBUF;
  wire ack;
  wire ack_IBUF;
  wire counting;
  wire counting_OBUF;
  wire d;
  wire d_IBUF;
  wire done;
  wire done_OBUF;
  wire done_counting;
  wire done_counting_IBUF;
  wire shift_ena;
  wire shift_ena_OBUF;
  wire [9:0]state;
  wire [7:0]state_IBUF;

  OBUF B3_next_OBUF_inst
       (.I(B3_next_OBUF),
        .O(B3_next));
  OBUF Count_next_OBUF_inst
       (.I(Count_next_OBUF),
        .O(Count_next));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hBA)) 
    Count_next_OBUF_inst_i_1
       (.I0(state_IBUF[7]),
        .I1(done_counting_IBUF),
        .I2(counting_OBUF),
        .O(Count_next_OBUF));
  OBUF S1_next_OBUF_inst
       (.I(S1_next_OBUF),
        .O(S1_next));
  LUT2 #(
    .INIT(4'h8)) 
    S1_next_OBUF_inst_i_1
       (.I0(state_IBUF[0]),
        .I1(d_IBUF),
        .O(S1_next_OBUF));
  OBUF S_next_OBUF_inst
       (.I(S_next_OBUF),
        .O(S_next));
  LUT6 #(
    .INIT(64'h8888FFFF8888FFF8)) 
    S_next_OBUF_inst_i_1
       (.I0(done_OBUF),
        .I1(ack_IBUF),
        .I2(state_IBUF[0]),
        .I3(state_IBUF[1]),
        .I4(d_IBUF),
        .I5(state_IBUF[3]),
        .O(S_next_OBUF));
  OBUF Wait_next_OBUF_inst
       (.I(Wait_next_OBUF),
        .O(Wait_next));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h8F88)) 
    Wait_next_OBUF_inst_i_1
       (.I0(done_counting_IBUF),
        .I1(counting_OBUF),
        .I2(ack_IBUF),
        .I3(done_OBUF),
        .O(Wait_next_OBUF));
  IBUF ack_IBUF_inst
       (.I(ack),
        .O(ack_IBUF));
  OBUF counting_OBUF_inst
       (.I(counting_OBUF),
        .O(counting));
  IBUF d_IBUF_inst
       (.I(d),
        .O(d_IBUF));
  OBUF done_OBUF_inst
       (.I(done_OBUF),
        .O(done));
  IBUF done_counting_IBUF_inst
       (.I(done_counting),
        .O(done_counting_IBUF));
  OBUF shift_ena_OBUF_inst
       (.I(shift_ena_OBUF),
        .O(shift_ena));
  LUT4 #(
    .INIT(16'hFFFE)) 
    shift_ena_OBUF_inst_i_1
       (.I0(state_IBUF[5]),
        .I1(state_IBUF[4]),
        .I2(state_IBUF[7]),
        .I3(B3_next_OBUF),
        .O(shift_ena_OBUF));
  IBUF \state_IBUF[0]_inst 
       (.I(state[0]),
        .O(state_IBUF[0]));
  IBUF \state_IBUF[1]_inst 
       (.I(state[1]),
        .O(state_IBUF[1]));
  IBUF \state_IBUF[3]_inst 
       (.I(state[3]),
        .O(state_IBUF[3]));
  IBUF \state_IBUF[4]_inst 
       (.I(state[4]),
        .O(state_IBUF[4]));
  IBUF \state_IBUF[5]_inst 
       (.I(state[5]),
        .O(state_IBUF[5]));
  IBUF \state_IBUF[6]_inst 
       (.I(state[6]),
        .O(B3_next_OBUF));
  IBUF \state_IBUF[7]_inst 
       (.I(state[7]),
        .O(state_IBUF[7]));
  IBUF \state_IBUF[8]_inst 
       (.I(state[8]),
        .O(counting_OBUF));
  IBUF \state_IBUF[9]_inst 
       (.I(state[9]),
        .O(done_OBUF));
endmodule
