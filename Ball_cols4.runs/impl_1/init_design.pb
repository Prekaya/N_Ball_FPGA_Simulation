
v
Command: %s
53*	vivadotcl2E
1link_design -top top_level -part xc7a100tcsg324-12default:defaultZ4-113h px? 
g
#Design is defaulting to srcset: %s
437*	planAhead2
	sources_12default:defaultZ12-437h px? 
j
&Design is defaulting to constrset: %s
434*	planAhead2
	constrs_12default:defaultZ12-434h px? 
W
Loading part %s157*device2$
xc7a100tcsg324-12default:defaultZ21-403h px? 
?
-Reading design checkpoint '%s' for cell '%s'
275*project2p
\c:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/clk_wiz_65/clk_wiz_65.dcp2default:default2

clkdivider2default:defaultZ1-454h px? 
?
-Reading design checkpoint '%s' for cell '%s'
275*project2v
bc:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/frame_blk_mem/frame_blk_mem.dcp2default:default2
mybram12default:defaultZ1-454h px? 
?
-Reading design checkpoint '%s' for cell '%s'
275*project2|
hc:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0.dcp2default:default2
myf2default:defaultZ1-454h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0462default:default2
610.2812default:default2
0.0002default:defaultZ17-268h px? 
g
-Analyzing %s Unisim elements for replacement
17*netlist2
9152default:defaultZ29-17h px? 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
12default:defaultZ29-28h px? 
?
?Netlist '%s' is not ideal for floorplanning, since the cellview '%s' contains a large number of primitives.  Please consider enabling hierarchy in synthesis if you want to do floorplanning.
310*netlist2
	top_level2default:default2
	top_level2default:defaultZ29-101h px? 
x
Netlist was created with %s %s291*project2
Vivado2default:default2
2019.22default:defaultZ1-479h px? 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px? 
?
LRemoving redundant IBUF, %s, from the path connected to top-level port: %s 
35*opt20
clkdivider/inst/clkin1_ibufg2default:default2

clk_100mhz2default:defaultZ31-35h px? 
?
?Could not create '%s' constraint because net '%s' is not directly connected to top level port. Synthesis is ignored for %s but preserved for implementation.
528*constraints2 
IBUF_LOW_PWR2default:default2(
clkdivider/clk_in12default:default2 
IBUF_LOW_PWR2default:default8Z18-550h px? 
?
$Parsing XDC File [%s] for cell '%s'
848*designutils2x
bc:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/clk_wiz_65/clk_wiz_65_board.xdc2default:default2%
clkdivider/inst	2default:default8Z20-848h px? 
?
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2x
bc:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/clk_wiz_65/clk_wiz_65_board.xdc2default:default2%
clkdivider/inst	2default:default8Z20-847h px? 
?
$Parsing XDC File [%s] for cell '%s'
848*designutils2r
\c:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/clk_wiz_65/clk_wiz_65.xdc2default:default2%
clkdivider/inst	2default:default8Z20-848h px? 
?
%Done setting XDC timing constraints.
35*timing2r
\c:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/clk_wiz_65/clk_wiz_65.xdc2default:default2
572default:default8@Z38-35h px? 
?
Deriving generated clocks
2*timing2r
\c:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/clk_wiz_65/clk_wiz_65.xdc2default:default2
572default:default8@Z38-2h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2 
get_clocks: 2default:default2
00:00:102default:default2
00:00:102default:default2
1310.4262default:default2
578.0782default:defaultZ17-268h px? 
?
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2r
\c:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/clk_wiz_65/clk_wiz_65.xdc2default:default2%
clkdivider/inst	2default:default8Z20-847h px? 
?
$Parsing XDC File [%s] for cell '%s'
848*designutils2~
hc:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0.xdc2default:default2
myf/U0	2default:default8Z20-848h px? 
?
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2~
hc:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0.xdc2default:default2
myf/U0	2default:default8Z20-847h px? 
?
Parsing XDC File [%s]
179*designutils2t
^C:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/constrs_1/imports/Desktop/nexys4_ddr.xdc2default:default8Z20-179h px? 
?
Finished Parsing XDC File [%s]
178*designutils2t
^C:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/constrs_1/imports/Desktop/nexys4_ddr.xdc2default:default8Z20-178h px? 
?
$Parsing XDC File [%s] for cell '%s'
848*designutils2?
oc:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_clocks.xdc2default:default2
myf/U0	2default:default8Z20-848h px? 
?
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2?
oc:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_clocks.xdc2default:default2
myf/U0	2default:default8Z20-847h px? 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0042default:default2
1310.4262default:default2
0.0002default:defaultZ17-268h px? 
?
!Unisim Transformation Summary:
%s111*project2?
?  A total of 612 instances were transformed.
  RAM16X1D => RAM32X1D (RAMD32(x2)): 100 instances
  RAM16X1S => RAM32X1S (RAMS32): 104 instances
  RAM32X1D => RAM32X1D (RAMD32(x2)): 100 instances
  RAM32X1S => RAM32X1S (RAMS32): 104 instances
  RAM64X1D => RAM64X1D (RAMD64E(x2)): 100 instances
  RAM64X1S => RAM64X1S (RAMS64E): 104 instances
2default:defaultZ1-111h px? 
?
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
122default:default2
32default:default2
02default:default2
02default:defaultZ4-41h px? 
]
%s completed successfully
29*	vivadotcl2
link_design2default:defaultZ4-42h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2!
link_design: 2default:default2
00:00:172default:default2
00:00:182default:default2
1310.4262default:default2
1012.3872default:defaultZ17-268h px? 


End Record