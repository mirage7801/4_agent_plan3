// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Thu Oct  8 00:21:47 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_mfvkvvfj/synth_netlist.v
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
    reset,
    data,
    shift_ena,
    counting,
    done_counting,
    done,
    ack);
  input clk;
  input reset;
  input data;
  output shift_ena;
  output counting;
  input done_counting;
  output done;
  input ack;

  wire \<const1> ;
  wire \FSM_onehot_state[0]_i_1_n_0 ;
  wire \FSM_onehot_state[1]_i_1_n_0 ;
  wire \FSM_onehot_state[2]_i_1_n_0 ;
  wire \FSM_onehot_state[4]_i_1_n_0 ;
  wire \FSM_onehot_state[5]_i_1_n_0 ;
  wire \FSM_onehot_state[7]_i_1_n_0 ;
  wire \FSM_onehot_state[8]_i_1_n_0 ;
  wire \FSM_onehot_state_reg_n_0_[0] ;
  wire \FSM_onehot_state_reg_n_0_[1] ;
  wire \FSM_onehot_state_reg_n_0_[2] ;
  wire \FSM_onehot_state_reg_n_0_[3] ;
  wire \FSM_onehot_state_reg_n_0_[4] ;
  wire \FSM_onehot_state_reg_n_0_[5] ;
  wire \FSM_onehot_state_reg_n_0_[6] ;
  wire VCC_2;
  wire ack;
  wire ack_IBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire counting;
  wire counting_OBUF;
  wire data;
  wire data_IBUF;
  wire done;
  wire done_OBUF;
  wire done_counting;
  wire done_counting_IBUF;
  wire p_0_in;
  wire reset;
  wire reset_IBUF;
  wire shift_ena;
  wire shift_ena_OBUF;

  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \FSM_onehot_state[0]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[4] ),
        .I1(data_IBUF),
        .O(\FSM_onehot_state[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \FSM_onehot_state[1]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(data_IBUF),
        .O(\FSM_onehot_state[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8888FFFF8888FFF8)) 
    \FSM_onehot_state[2]_i_1 
       (.I0(done_OBUF),
        .I1(ack_IBUF),
        .I2(\FSM_onehot_state_reg_n_0_[5] ),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .I4(data_IBUF),
        .I5(\FSM_onehot_state_reg_n_0_[2] ),
        .O(\FSM_onehot_state[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hC8)) 
    \FSM_onehot_state[4]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[4] ),
        .I1(data_IBUF),
        .I2(\FSM_onehot_state_reg_n_0_[5] ),
        .O(\FSM_onehot_state[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \FSM_onehot_state[5]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[2] ),
        .I1(data_IBUF),
        .O(\FSM_onehot_state[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hBA)) 
    \FSM_onehot_state[7]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[6] ),
        .I1(done_counting_IBUF),
        .I2(counting_OBUF),
        .O(\FSM_onehot_state[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h8F88)) 
    \FSM_onehot_state[8]_i_1 
       (.I0(done_counting_IBUF),
        .I1(counting_OBUF),
        .I2(ack_IBUF),
        .I3(done_OBUF),
        .O(\FSM_onehot_state[8]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "S110:0000000001,B0:0000000010,S11:0000010000,S1:0000100000,S:0000000100,B3:0001000000,Wait:0100000000,Count:0010000000,B2:1000000000,B1:0000001000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state[0]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[0] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "S110:0000000001,B0:0000000010,S11:0000010000,S1:0000100000,S:0000000100,B3:0001000000,Wait:0100000000,Count:0010000000,B2:1000000000,B1:0000001000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state[1]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[1] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "S110:0000000001,B0:0000000010,S11:0000010000,S1:0000100000,S:0000000100,B3:0001000000,Wait:0100000000,Count:0010000000,B2:1000000000,B1:0000001000" *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state[2]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[2] ),
        .S(reset_IBUF));
  (* FSM_ENCODED_STATES = "S110:0000000001,B0:0000000010,S11:0000010000,S1:0000100000,S:0000000100,B3:0001000000,Wait:0100000000,Count:0010000000,B2:1000000000,B1:0000001000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state_reg_n_0_[1] ),
        .Q(\FSM_onehot_state_reg_n_0_[3] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "S110:0000000001,B0:0000000010,S11:0000010000,S1:0000100000,S:0000000100,B3:0001000000,Wait:0100000000,Count:0010000000,B2:1000000000,B1:0000001000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state[4]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[4] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "S110:0000000001,B0:0000000010,S11:0000010000,S1:0000100000,S:0000000100,B3:0001000000,Wait:0100000000,Count:0010000000,B2:1000000000,B1:0000001000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state[5]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[5] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "S110:0000000001,B0:0000000010,S11:0000010000,S1:0000100000,S:0000000100,B3:0001000000,Wait:0100000000,Count:0010000000,B2:1000000000,B1:0000001000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(p_0_in),
        .Q(\FSM_onehot_state_reg_n_0_[6] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "S110:0000000001,B0:0000000010,S11:0000010000,S1:0000100000,S:0000000100,B3:0001000000,Wait:0100000000,Count:0010000000,B2:1000000000,B1:0000001000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state[7]_i_1_n_0 ),
        .Q(counting_OBUF),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "S110:0000000001,B0:0000000010,S11:0000010000,S1:0000100000,S:0000000100,B3:0001000000,Wait:0100000000,Count:0010000000,B2:1000000000,B1:0000001000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state[8]_i_1_n_0 ),
        .Q(done_OBUF),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "S110:0000000001,B0:0000000010,S11:0000010000,S1:0000100000,S:0000000100,B3:0001000000,Wait:0100000000,Count:0010000000,B2:1000000000,B1:0000001000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state_reg_n_0_[3] ),
        .Q(p_0_in),
        .R(reset_IBUF));
  VCC VCC
       (.P(\<const1> ));
  VCC VCC_1
       (.P(VCC_2));
  IBUF ack_IBUF_inst
       (.I(ack),
        .O(ack_IBUF));
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
  OBUF counting_OBUF_inst
       (.I(counting_OBUF),
        .O(counting));
  IBUF data_IBUF_inst
       (.I(data),
        .O(data_IBUF));
  OBUF done_OBUF_inst
       (.I(done_OBUF),
        .O(done));
  IBUF done_counting_IBUF_inst
       (.I(done_counting),
        .O(done_counting_IBUF));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  OBUF shift_ena_OBUF_inst
       (.I(shift_ena_OBUF),
        .O(shift_ena));
  LUT4 #(
    .INIT(16'hFFFE)) 
    shift_ena_OBUF_inst_i_1
       (.I0(\FSM_onehot_state_reg_n_0_[6] ),
        .I1(\FSM_onehot_state_reg_n_0_[1] ),
        .I2(\FSM_onehot_state_reg_n_0_[3] ),
        .I3(p_0_in),
        .O(shift_ena_OBUF));
endmodule
