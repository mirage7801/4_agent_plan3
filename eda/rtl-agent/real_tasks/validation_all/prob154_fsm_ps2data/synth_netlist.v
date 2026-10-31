// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Thu Oct  8 00:25:31 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_ccbfph3o/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* BYTE1 = "0" *) (* BYTE2 = "1" *) (* BYTE3 = "2" *) 
(* DONE = "3" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (clk,
    in,
    reset,
    out_bytes,
    done);
  input clk;
  input [7:0]in;
  input reset;
  output [23:0]out_bytes;
  output done;

  wire \<const0> ;
  wire \<const1> ;
  wire \FSM_onehot_state[0]_i_1_n_0 ;
  wire \FSM_onehot_state[1]_i_1_n_0 ;
  wire \FSM_onehot_state_reg_n_0_[0] ;
  wire \FSM_onehot_state_reg_n_0_[1] ;
  wire \FSM_onehot_state_reg_n_0_[2] ;
  wire VCC_2;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire done;
  wire done_OBUF;
  wire [7:0]in;
  wire [7:0]in_IBUF;
  wire [23:0]out_bytes;
  wire [23:0]out_bytes_OBUF;
  wire reset;
  wire reset_IBUF;

  LUT3 #(
    .INIT(8'h32)) 
    \FSM_onehot_state[0]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(in_IBUF[3]),
        .I2(done_OBUF),
        .O(\FSM_onehot_state[0]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hC8)) 
    \FSM_onehot_state[1]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(in_IBUF[3]),
        .I2(done_OBUF),
        .O(\FSM_onehot_state[1]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "BYTE3:0100,DONE:1000,BYTE1:0001,BYTE2:0010" *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state[0]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[0] ),
        .S(reset_IBUF));
  (* FSM_ENCODED_STATES = "BYTE3:0100,DONE:1000,BYTE1:0001,BYTE2:0010" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state[1]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[1] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "BYTE3:0100,DONE:1000,BYTE1:0001,BYTE2:0010" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state_reg_n_0_[1] ),
        .Q(\FSM_onehot_state_reg_n_0_[2] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "BYTE3:0100,DONE:1000,BYTE1:0001,BYTE2:0010" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state_reg_n_0_[2] ),
        .Q(done_OBUF),
        .R(reset_IBUF));
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  VCC VCC_1
       (.P(VCC_2));
  (* XILINX_LEGACY_PRIM = "BUFG" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:CE" *) 
  BUFGCE #(
    .CE_TYPE("ASYNC"),
    .SIM_DEVICE("ULTRASCALE_PLUS")) 
    clk_IBUF_BUFG_inst
       (.CE(VCC_2),
        .I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  OBUF done_OBUF_inst
       (.I(done_OBUF),
        .O(done));
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
  OBUF \out_bytes_OBUF[0]_inst 
       (.I(out_bytes_OBUF[0]),
        .O(out_bytes[0]));
  OBUF \out_bytes_OBUF[10]_inst 
       (.I(out_bytes_OBUF[10]),
        .O(out_bytes[10]));
  OBUF \out_bytes_OBUF[11]_inst 
       (.I(out_bytes_OBUF[11]),
        .O(out_bytes[11]));
  OBUF \out_bytes_OBUF[12]_inst 
       (.I(out_bytes_OBUF[12]),
        .O(out_bytes[12]));
  OBUF \out_bytes_OBUF[13]_inst 
       (.I(out_bytes_OBUF[13]),
        .O(out_bytes[13]));
  OBUF \out_bytes_OBUF[14]_inst 
       (.I(out_bytes_OBUF[14]),
        .O(out_bytes[14]));
  OBUF \out_bytes_OBUF[15]_inst 
       (.I(out_bytes_OBUF[15]),
        .O(out_bytes[15]));
  OBUF \out_bytes_OBUF[16]_inst 
       (.I(out_bytes_OBUF[16]),
        .O(out_bytes[16]));
  OBUF \out_bytes_OBUF[17]_inst 
       (.I(out_bytes_OBUF[17]),
        .O(out_bytes[17]));
  OBUF \out_bytes_OBUF[18]_inst 
       (.I(out_bytes_OBUF[18]),
        .O(out_bytes[18]));
  OBUF \out_bytes_OBUF[19]_inst 
       (.I(out_bytes_OBUF[19]),
        .O(out_bytes[19]));
  OBUF \out_bytes_OBUF[1]_inst 
       (.I(out_bytes_OBUF[1]),
        .O(out_bytes[1]));
  OBUF \out_bytes_OBUF[20]_inst 
       (.I(out_bytes_OBUF[20]),
        .O(out_bytes[20]));
  OBUF \out_bytes_OBUF[21]_inst 
       (.I(out_bytes_OBUF[21]),
        .O(out_bytes[21]));
  OBUF \out_bytes_OBUF[22]_inst 
       (.I(out_bytes_OBUF[22]),
        .O(out_bytes[22]));
  OBUF \out_bytes_OBUF[23]_inst 
       (.I(out_bytes_OBUF[23]),
        .O(out_bytes[23]));
  OBUF \out_bytes_OBUF[2]_inst 
       (.I(out_bytes_OBUF[2]),
        .O(out_bytes[2]));
  OBUF \out_bytes_OBUF[3]_inst 
       (.I(out_bytes_OBUF[3]),
        .O(out_bytes[3]));
  OBUF \out_bytes_OBUF[4]_inst 
       (.I(out_bytes_OBUF[4]),
        .O(out_bytes[4]));
  OBUF \out_bytes_OBUF[5]_inst 
       (.I(out_bytes_OBUF[5]),
        .O(out_bytes[5]));
  OBUF \out_bytes_OBUF[6]_inst 
       (.I(out_bytes_OBUF[6]),
        .O(out_bytes[6]));
  OBUF \out_bytes_OBUF[7]_inst 
       (.I(out_bytes_OBUF[7]),
        .O(out_bytes[7]));
  OBUF \out_bytes_OBUF[8]_inst 
       (.I(out_bytes_OBUF[8]),
        .O(out_bytes[8]));
  OBUF \out_bytes_OBUF[9]_inst 
       (.I(out_bytes_OBUF[9]),
        .O(out_bytes[9]));
  FDRE \out_bytes_r_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF[0]),
        .Q(out_bytes_OBUF[0]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_bytes_OBUF[2]),
        .Q(out_bytes_OBUF[10]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_bytes_OBUF[3]),
        .Q(out_bytes_OBUF[11]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_bytes_OBUF[4]),
        .Q(out_bytes_OBUF[12]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_bytes_OBUF[5]),
        .Q(out_bytes_OBUF[13]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_bytes_OBUF[6]),
        .Q(out_bytes_OBUF[14]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_bytes_OBUF[7]),
        .Q(out_bytes_OBUF[15]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_bytes_OBUF[8]),
        .Q(out_bytes_OBUF[16]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_bytes_OBUF[9]),
        .Q(out_bytes_OBUF[17]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_bytes_OBUF[10]),
        .Q(out_bytes_OBUF[18]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_bytes_OBUF[11]),
        .Q(out_bytes_OBUF[19]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF[1]),
        .Q(out_bytes_OBUF[1]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_bytes_OBUF[12]),
        .Q(out_bytes_OBUF[20]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_bytes_OBUF[13]),
        .Q(out_bytes_OBUF[21]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_bytes_OBUF[14]),
        .Q(out_bytes_OBUF[22]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_bytes_OBUF[15]),
        .Q(out_bytes_OBUF[23]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF[2]),
        .Q(out_bytes_OBUF[2]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF[3]),
        .Q(out_bytes_OBUF[3]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF[4]),
        .Q(out_bytes_OBUF[4]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF[5]),
        .Q(out_bytes_OBUF[5]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF[6]),
        .Q(out_bytes_OBUF[6]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF[7]),
        .Q(out_bytes_OBUF[7]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_bytes_OBUF[0]),
        .Q(out_bytes_OBUF[8]),
        .R(\<const0> ));
  FDRE \out_bytes_r_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_bytes_OBUF[1]),
        .Q(out_bytes_OBUF[9]),
        .R(\<const0> ));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
endmodule
