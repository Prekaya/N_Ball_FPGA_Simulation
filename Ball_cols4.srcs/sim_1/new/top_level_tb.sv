`default_nettype none    // catch typos!
`timescale 1ns / 100ps 

// test fir31 module
// input samples are read from fir31.samples
// output samples are written to fir31.output
module top_level_tb();
	logic clk,rst_in;
  	logic [3:0] vga_r, vga_b, vga_g;
	logic vga_hs, vga_vs;
	logic [15:0] sw;
  

  initial begin
    // initialize state, assert reset for one clock cycle
    clk = 0;
    sw[0] = 1;
    sw[1] = 1;
    sw[2] = 0;
    sw[3] = 0;
    rst_in = 1;
    #10
    rst_in = 0;
  end

  // clk has 50% duty cycle, 10ns period
  always #5 clk = ~clk;
  top_level my_top_level(.sw(sw),.clk_100mhz(clk),.btnc(rst_in),.vga_r(vga_r),.vga_g(vga_g),.vga_hs(vga_hs),.vga_vs(vga_vs));
  
  always @(posedge clk) begin
    
  end
  
endmodule