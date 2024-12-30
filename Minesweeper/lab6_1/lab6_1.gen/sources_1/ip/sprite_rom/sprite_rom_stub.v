// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Fri Dec 13 03:43:04 2024
// Host        : DESKTOP-3OBC3CP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/dant0/Desktop/lab6/lab6_1/lab6_1.gen/sources_1/ip/sprite_rom/sprite_rom_stub.v
// Design      : sprite_rom
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s50csga324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2022.2" *)
module sprite_rom(a, spo)
/* synthesis syn_black_box black_box_pad_pin="a[11:0],spo[11:0]" */;
  input [11:0]a;
  output [11:0]spo;
endmodule
