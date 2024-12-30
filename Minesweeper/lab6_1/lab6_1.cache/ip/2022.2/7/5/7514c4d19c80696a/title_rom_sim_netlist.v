// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Fri Dec 13 04:31:09 2024
// Host        : DESKTOP-3OBC3CP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ title_rom_sim_netlist.v
// Design      : title_rom
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s50csga324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "title_rom,dist_mem_gen_v8_0_13,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2022.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (a,
    spo);
  input [14:0]a;
  output [11:0]spo;

  wire [14:0]a;
  wire [11:0]spo;
  wire [11:0]NLW_U0_dpo_UNCONNECTED;
  wire [11:0]NLW_U0_qdpo_UNCONNECTED;
  wire [11:0]NLW_U0_qspo_UNCONNECTED;

  (* C_FAMILY = "spartan7" *) 
  (* C_HAS_D = "0" *) 
  (* C_HAS_DPO = "0" *) 
  (* C_HAS_DPRA = "0" *) 
  (* C_HAS_I_CE = "0" *) 
  (* C_HAS_QDPO = "0" *) 
  (* C_HAS_QDPO_CE = "0" *) 
  (* C_HAS_QDPO_CLK = "0" *) 
  (* C_HAS_QDPO_RST = "0" *) 
  (* C_HAS_QDPO_SRST = "0" *) 
  (* C_HAS_WE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_PIPELINE_STAGES = "0" *) 
  (* C_QCE_JOINED = "0" *) 
  (* C_QUALIFY_WE = "0" *) 
  (* C_REG_DPRA_INPUT = "0" *) 
  (* c_addr_width = "15" *) 
  (* c_default_data = "0" *) 
  (* c_depth = "18880" *) 
  (* c_elaboration_dir = "./" *) 
  (* c_has_clk = "0" *) 
  (* c_has_qspo = "0" *) 
  (* c_has_qspo_ce = "0" *) 
  (* c_has_qspo_rst = "0" *) 
  (* c_has_qspo_srst = "0" *) 
  (* c_has_spo = "1" *) 
  (* c_mem_init_file = "title_rom.mif" *) 
  (* c_parser_type = "1" *) 
  (* c_read_mif = "1" *) 
  (* c_reg_a_d_inputs = "0" *) 
  (* c_sync_enable = "1" *) 
  (* c_width = "12" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_dist_mem_gen_v8_0_13 U0
       (.a({a[14:2],1'b0,1'b0}),
        .clk(1'b0),
        .d({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dpo(NLW_U0_dpo_UNCONNECTED[11:0]),
        .dpra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .i_ce(1'b1),
        .qdpo(NLW_U0_qdpo_UNCONNECTED[11:0]),
        .qdpo_ce(1'b1),
        .qdpo_clk(1'b0),
        .qdpo_rst(1'b0),
        .qdpo_srst(1'b0),
        .qspo(NLW_U0_qspo_UNCONNECTED[11:0]),
        .qspo_ce(1'b1),
        .qspo_rst(1'b0),
        .qspo_srst(1'b0),
        .spo(spo),
        .we(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2022.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
M9ERyrMNmk2Jjyg6ZCGYQpTqx5C+74+ICn/vAQ5KoRuxJNbql8tHJjFcOe3FAJX14Nokq4wtfvZP
2sPXAs/eYYzjjbnt4nx8oZRRPy0XyDpvba/qxyqBSxjChIoPMDwpXnxi+chZJU5N1zCNt9FZPAep
nLCjMCkQTlKbP3cUJIY=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
FBAg02qOh8M8uZkNvwWHoY3ELncwvHjjgL2y2qLN7xuxxaPQj3LdyD/IETTPdSjNCB/rhpJxbT1y
U5fbF28Hkp+bzDuxeTWPX251wMhiEmdm4jhyMl2z+GRf2Z6VJ4bVM5bieaJvsbjuyQ9Az6TDmueI
14citDEbyRCyJD9EiVckdS2mZcTl37oVFebKnIeJGmNjOc2XrcM84JVJIG5iv3ryS2hAG9/84hEr
u3DYC+xS2w5swJXVSf0zV+w8xZulS3PTPLELIM8O+SEFdHetZKnrgG1aJ7V5xu0RniGAsyVwVbgu
M1jPqNLyU+9kyETKfG9jcGEIM2I2gUfmOvRs+g==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
TYvdYOtu2OcY/hp0LCFlgwGgJeLJ5MSBDPjuyI3760LiXtklDVs7CUFlvRRXMgAzbHlMXbiHp/Xl
cvmN035ayt8D8gPWRXxnbQf3kRlW6EIFwFMZ1inL9b5f47gsuvCP6MaKiTg0W7+/ZeHbM4jHXvRe
b8HXvQvK5kVwtayEwt0=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
GkcGg32vdV7ZS9x4Uw9v3hZEcxD5hMmQXUqa6shDPbzqUGIxrKpTOb9W4Sgi8rq+qw7QpAZp2JW/
MkYAH1WikFlf+XWG57y55EFV7oRoKQDh2Yz0sZEwVhwTGwSAqfnjrmPITofdG5eiey1ySGprEKsT
mqWAV+ZN7TkQkKup0Ukf1O+8giYKT/7UibTRqG/CT9dgU/4atPgYh2QjNMVrsAH/uzDxh7stQMYe
nkjZBkpLWOq7mxEXTKVtYAD/8G5qCJELRcvCuUKYz4Une1wDj+L/vwRK3IAdWKQ+/5mvj0q5XEm7
IKu5HYvalbySwRWzaB00uobXZorNhfwSv45jHg==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
JnT3Bfv/DUBx2mIm4+jpmHjzhKoX4mNpcc/lgscv3iYrJw8Uble396hMwPsVZ+kkAsmYtegNCiTG
Z7kqnoNeWHv+Grdizsq0QM9S2KJ5EoZhjelE+3Cii/ztNHf7Y3c0nBPnioUQ5YmWk7vgoQl3SJ3d
vwD3G0c+fGJBRpi14hTJOB2wtu4EeWcJ1f+01LjKINeucLlwacjnN0tElyRgCNKfsRDAQiMqwKqg
XCleeNY0cyLXGI30pXMpnbLizYlNKgVD6DSeNaby0dhW4phR0a+9xteo8l8eRVzTO+VSOcYSy8rU
6Uj2y0Up19vcq91C+/YeHlh24VwNI2TJeUEDwQ==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_07", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
AWr8D+IaT/X0jMJSrwmWnhWOjt0+8oyULINYaH7QGBLgqKCVtf8rqo68R3/TZ8gTkN73fZOx0QCU
3WEp7Ga1gUsqEgy+2zGlncYhOzx62FJm4Pm7S6LbE1qdg3/9Pp55JLaf1ouYlZccQJ+yawj0HgL4
zR0T347Zg2aIFxQZ28icCuJbxAZsZgAT30scXsTMMvXlQQ9NI21OjirKgHRn3dldIjpkL+BrVBkQ
Q7MMiTBhpCn/c+WXk4H9BPc3vMrVoh6r5oo+e1858Hk7osyxNI9zuACaGwdAatsW756kQBMsQoUj
TmJksSfucjrHVSuLFffpztOARH3LXrhZcCZdoQ==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
fPVwMHnHe1L8weZTnbBxjlAabwZZnO4DZSHaO7tHGHAw6U+w+7Rc3BwfQXtiTyGXP15rvoLhvVpo
i1Tzs4zrV1X8vlWrxhS6XA2VO4RFkpCjmnHpvdgnW9mpk7w90QOEZIWZQST/o15t0wDT/kv4J36r
Ho59mVFCGQQSSYx0209u6sG2rNpJ5HtWMM+tDEDHUArucrBmPOoZSq0VSQsTHtjJQxr3U5fv9l6q
aEBWkjnLJ6zqLkt12B3q7V3iFORPpz6XNMqA6wzArzWirzgTCw3CduiSAgbNgoGmV4eNrVb2DfOT
5V4ni19GigMG1fHCD9dNPWGiRCWpY6iiN6iE1w==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
NkQB16Pku9sdGFuAkY+DjFhWzKYvb26AsK/VO1//MS5ztnK+V9d/0K8nVee9kGDNC4zorSd1NjRc
Jkj/JJm1k/9QiQQwOSB/94zKWUyVH2Rvw3UOuaTu9pWRQsIdmPNwXBKCOF5L17HHGaNqYzvHF7YY
REIp6VR4HcyLq2beYXn09Mq0f84obUr7+CMgh8i1SaLa/ydMPS9xsm1i0NFB3qcEC0dDq6xklwsX
s198UBI5mBJTEUKi38eytWXzQPFTmqdlD3Qn4CgstxSdoLrFHchISqt+L62U4xU6aVyYXmVaeebF
I1F3MAXQZwZwGETW7RW9t/+3pJtkjPfPtdnqu/Sg+zP+vLjSV/NcONctKnTj86/z+TTehoSH8ccr
BsjV0PhAtR3+RTr3VGkKJoUNeE8yFQIHlES8UamuSNMh5XrbmcbFx22MZ9gLOa350ytm1N124jNF
V860l5gGbt/8NcGf8I3EVPrYblJ5ZLGsZkVg1cKBMUys1yMm6Ci2Mruc

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
JDELzo7luYHcwIl8sAAMR3hvm1tr+ZaD3VKTvYj1uwYFwuIPCkUfjVi8OMAgp3Hh/R1wDZSeoY7T
xpO0sKF9MsovKwwArnByLL8zZflfJIe5AmC+jE5a8qUxydp4liMdOypRTLu6U6EUYUwSj6VOR0Uj
deCoQCr/gVZ2GdNKF5sKZsGXZSvx1Wag70BiGs69qhgUvVVlpbqpNRSB0DR/2IuSKCHhkucLXiTk
zVS7zC7GiyNYE6l/Yu5Ov25Cl+lY5cMZkqKvIFm90UiTBNYk4No5ofXnH/E0rNcbydv0BvWDmgKt
NXVratbi0ztKLb27z2lw5ZZzXCihB41kx4VjqA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 17264)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
