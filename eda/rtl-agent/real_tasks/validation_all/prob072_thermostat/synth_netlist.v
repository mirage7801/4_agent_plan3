// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:42:48 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_izv1_uu_/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (mode,
    too_cold,
    too_hot,
    fan_on,
    heater,
    aircon,
    fan);
  input mode;
  input too_cold;
  input too_hot;
  input fan_on;
  output heater;
  output aircon;
  output fan;

  wire aircon;
  wire aircon_OBUF;
  wire fan;
  wire fan_OBUF;
  wire fan_on;
  wire fan_on_IBUF;
  wire heater;
  wire heater_OBUF;
  wire mode;
  wire mode_IBUF;
  wire too_cold;
  wire too_cold_IBUF;
  wire too_hot;
  wire too_hot_IBUF;

  OBUF aircon_OBUF_inst
       (.I(aircon_OBUF),
        .O(aircon));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h2)) 
    aircon_OBUF_inst_i_1
       (.I0(too_hot_IBUF),
        .I1(mode_IBUF),
        .O(aircon_OBUF));
  OBUF fan_OBUF_inst
       (.I(fan_OBUF),
        .O(fan));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hFFE2)) 
    fan_OBUF_inst_i_1
       (.I0(too_hot_IBUF),
        .I1(mode_IBUF),
        .I2(too_cold_IBUF),
        .I3(fan_on_IBUF),
        .O(fan_OBUF));
  IBUF fan_on_IBUF_inst
       (.I(fan_on),
        .O(fan_on_IBUF));
  OBUF heater_OBUF_inst
       (.I(heater_OBUF),
        .O(heater));
  LUT2 #(
    .INIT(4'h8)) 
    heater_OBUF_inst_i_1
       (.I0(mode_IBUF),
        .I1(too_cold_IBUF),
        .O(heater_OBUF));
  IBUF mode_IBUF_inst
       (.I(mode),
        .O(mode_IBUF));
  IBUF too_cold_IBUF_inst
       (.I(too_cold),
        .O(too_cold_IBUF));
  IBUF too_hot_IBUF_inst
       (.I(too_hot),
        .O(too_hot_IBUF));
endmodule
