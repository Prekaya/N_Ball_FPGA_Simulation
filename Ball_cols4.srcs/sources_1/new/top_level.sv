`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2021 04:21:31 PM
// Design Name: 
// Module Name: top_level
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_level(
	input wire clk_100mhz, input wire btnc, input wire [15:0]sw, 
	output logic[3:0] vga_r, output logic[3:0] vga_b, output logic[3:0] vga_g,
   	output logic vga_hs, output logic vga_vs, output logic [15:0]led);
   	
  	//program constants
   	parameter white = 12'hFFF;
	parameter disp_w  = 20'sd1024;
   	parameter disp_h = 20'sd768;
   	parameter nth_ball = 20'sd99; //number of balls - 1 so, 0 is 1 ball 1 is to balls and so on
   	parameter frac_bits = 5;
   
   	parameter radius = 20'sd6; // radius of balls
   	parameter radius2 = radius*radius;
   	parameter diameter2 = 4*radius*radius*1024;//scale diameter^2 for fractional math
   	parameter no_pix = 4*radius*radius;
	parameter div_mod = 2*radius;
	parameter spring_c = 20'sd9;
	parameter w_bits = 19;
	parameter n_bits = w_bits+frac_bits;
	parameter g_d = 20'sd8;
	parameter friction = 20'sd2;
	
   	
   	//wall info scaled for fractional math
   	parameter left_wall = (20'sd0+radius)*32;
    parameter right_wall = (20'sd1024-radius)*32;
	parameter bot_wall = (20'sd768-radius)*32;
	parameter top_wall = (20'sd0+radius)*32;
	parameter zero = 20'sd0;
	
	//program state
	parameter resting = 5'd0;
	parameter initializex = 5'd1;
	parameter initializey = 5'd2;
	parameter initializecol = 5'd3;
	parameter calc_col_disp = 5'd4;
	parameter calc_col_visp = 5'd5;
	parameter calc_col_mag_big = 5'd6;
	parameter calc_col_mag = 5'd7;
	parameter calc_col_dot_big = 5'd8;
	parameter calc_col_dot = 5'd9;
	parameter calc_interact = 5'd10;
	parameter calc_dots_uni = 5'd11;
	parameter done_divide = 5'd12;
	parameter calc_inc_colx = 5'd13;
	parameter calc_inc_coly = 5'd14;
	parameter calc_col_fx = 5'd15;
	parameter calc_col_fy = 5'd16;
	parameter calc_friction = 5'd27;
	parameter next_ball = 5'd17;
	parameter calc_wall_colx = 5'd18;
	parameter calc_wall_coly = 5'd19;
	parameter calc_wall_fx = 5'd20;
	parameter calc_wall_fy = 5'd21;
	parameter move_balls = 5'd22;
	parameter clear_bram = 5'd23;
	parameter hvcountt = 5'd26;
	parameter point_bram = 5'd24;
	parameter change_brams = 5'd25;
	
	//bram state
	parameter bram1 = 1'b0;
	parameter bram2 = 1'b1;
	
   	//inputs signals
	logic rst_in, rst_in2, clk_65mhz;
	
	//default values
	logic signed [n_bits:0] xps0 [nth_ball:0], yps0 [nth_ball:0];
	logic signed [n_bits:0] xvs0 [nth_ball:0], yvs0 [nth_ball:0];
	logic signed [n_bits:0] col_fxs0 [nth_ball:0], col_fys0 [nth_ball:0];
	
	//simulation values
	logic signed [n_bits:0] xps [nth_ball:0], yps [nth_ball:0];
	logic signed [w_bits:0] xhcount, yvcount;
	logic signed [n_bits:0] xvs [nth_ball:0], yvs [nth_ball:0];
	logic signed [n_bits:0] col_fxs [nth_ball:0], col_fys [nth_ball:0];
	logic signed [n_bits:0] frictionx, frictiony;
	logic signed [n_bits:0] wall_colx [nth_ball:0], wall_coly [nth_ball:0];
	logic signed [n_bits:0] wall_fxs [nth_ball:0], wall_fys [nth_ball:0];
	logic signed [n_bits:0]  disp_x, disp_y, visp_x , visp_y, mag, dot, dot_uni, test, test2;
	logic signed [2*n_bits:0] mag_big, inccol_fxs, inccol_fys, dot_big, div_check ;
	
	//VGA Signals
	logic [10:0] hcount;
	logic [9:0] vcount;
    logic [11:0] rgb;
	logic hsync, vsync, blank;
	logic b, hs, vs, vsb;
	logic empty, full;
	
	//bram control
	logic data_to_bram, data_to_brama1, data_to_brama2;
	logic data_from_brama,data_from_bramb, data_from_brama1, data_from_brama2, data_from_bramb1, data_from_bramb2 ;
	logic [2*n_bits:0] addra1, addrb1, addra2, addrb2, addr, clear_addr, write_addr;
	logic signed [n_bits:0] n_ci [no_pix:0], d_ci [no_pix:0];
	logic write1, write2, write;
	
	//state machine controls and bram state
   	logic [4:0] state;
   	logic cur_bram, next_bram, this_bram;
   	logic [19:0] i, n;
   	
   	frame_blk_mem mybram1(
		.addra(addra1), .clka(clk_100mhz), .dina(data_to_brama1), .douta(data_from_brama1), .ena(1), .wea(write1),
		.addrb(addrb1), .clkb(clk_65mhz), .dinb(0), .doutb(data_from_bramb1), .enb(1), .web(0));
    frame_blk_mem mybram2(
		.addra(addra2), .clka(clk_100mhz), .dina(data_to_brama2), .douta(data_from_brama2), .ena(1), .wea(write2),
		.addrb(addrb2), .clkb(clk_65mhz), .dinb(0), .doutb(data_from_bramb2), .enb(1), .web(0));
    
   	clk_wiz_65 clkdivider(.clk_in1(clk_100mhz), .clk_out1(clk_65mhz));
   	
    xvga xvga1(.vclock_in(clk_65mhz),.hcount_out(hcount),.vcount_out(vcount), .hsync_out(hsync),.vsync_out(vsync),.blank_out(blank));
	
	debouncer db1(.rst_in(rst_in),.clk_in(clk_100mhz),.noisy_in(btnc),.clean_out(rst_in));
	debouncer db2(.rst_in(rst_in2),.clk_in(clk_65mhz),.noisy_in(btnc),.clean_out(rst_in2));
    
    fifo_generator_0 myf(.rst(rst_in),.din(vs),.wr_clk(clk_65mhz),.wr_en(1),.rd_en(1),.rd_clk(clk_100mhz),.dout(vsb), .empty(empty), .full(full));
	always_comb begin
		integer signed ind;
		//shape descriptioon relative to position
		//i.e. white pixels around a position to draw a circle
		for (ind = 0; ind < no_pix; ind = ind + 1) begin
			d_ci[ind][n_bits:frac_bits] = ind%div_mod + (ind/div_mod)*disp_w - radius*(1+disp_w);
			n_ci[ind] = (((ind%div_mod - radius)*(ind%div_mod - radius)) + ((ind/div_mod - radius)*(ind/div_mod - radius))) < radius2;
		end
		d_ci[no_pix][n_bits:frac_bits] = no_pix%div_mod + (no_pix/div_mod)*disp_w - radius*(1+disp_w);
		n_ci[no_pix] = 0;
		
		//initiale velocities and positions
		for (ind = 0; ind <= nth_ball; ind = ind + 1) begin
				xps0[ind] = 0; yps0[ind] = 0;
				xvs0[ind] = 0; yvs0[ind] = 0;
				col_fxs0[ind] = 0; col_fys0[ind] = 0;
		end
		
		for (ind = 0; ind <= nth_ball; ind = ind + 1) begin
			xps0[ind][n_bits:frac_bits] = 20'sd10 + (20*(ind%20));
			yps0[ind][n_bits:frac_bits] = 20'sd10 + (20*(ind/20));
 			xvs0[ind][n_bits:frac_bits] = (ind%3);
			yvs0[ind][n_bits:frac_bits] = 2*(ind%2);
		end
		//xvs0[2][n_bits:frac_bits] = -20'sd2;
		//yps0[2][n_bits:frac_bits] = 20'sd14;
		//xps0[2][n_bits:frac_bits] = 20'sd40;
		/*xps0[0][n_bits:frac_bits] = 20'sd10; xps0[1][n_bits:frac_bits] = 20'sd14; xps0[2][n_bits:frac_bits] = 20'sd14;
		yps0[0][n_bits:frac_bits] = 20'sd10; yps0[1][n_bits:frac_bits] = 20'sd20;
 		xvs0[0][n_bits:frac_bits] = 0; xvs0[1][n_bits:frac_bits] = 0;
		yvs0[0][n_bits:frac_bits] = 0; yvs0[1][n_bits:frac_bits] = -20'sd2;*/
	end
	
   	always_ff @(posedge clk_100mhz)begin
		if (rst_in) begin
			state <= resting;
		end else begin
			case(state)
				resting:
				begin
					i <= 0;
					n <= 0;
					clear_addr <= 0;
					write_addr <= 0;
					state <= initializex;
					cur_bram <= bram1;
				end
				
				//initializing values
				initializex:
				begin
					xps[i] <= xps0[i];
					xvs[i] <= xvs0[i];
					i <= (i == nth_ball)?0:i+1;
					state <= (i == nth_ball)?initializey:initializex;
				end
				
				initializey:
				begin
					yps[i] <= yps0[i];
					yvs[i] <= yvs0[i];
					i <= (i == nth_ball)?0:i+1;
					state <= (i == nth_ball)?initializecol:initializey;
				end
				
				initializecol:
				begin
					col_fxs[i] <= col_fxs0[i];
					col_fys[i] <= col_fys0[i];
					i <= (i == nth_ball)?0:i+1;
					state <= (i == nth_ball)?calc_col_disp:initializecol;
				end
				
				//displacement and relative velocity vectors for dot product
				calc_col_disp:
				begin
					disp_x <= (xps[n]-xps[i]);
					disp_y <= (yps[n]-yps[i]);
					state <= (sw[0]/*&&(hcount==0)&&(vcount==0)*/)?calc_col_visp:clear_bram;
				end
				
				calc_col_visp:
				begin
					visp_x <= (xvs[i]-xvs[n]);
					visp_y <= (yvs[i]-yvs[n]);
					state <= calc_col_mag_big;
				end
				
				//magnitude and dot product of displacement and relative velocity
				calc_col_mag_big:
				begin
					mag_big <= (disp_x*disp_x) + (disp_y*disp_y);
					state <= calc_col_dot_big;
				end
				
				calc_col_dot_big:
				begin
					dot_big <= (visp_x*disp_x) +(visp_y*disp_y);
					dot_uni <= 0;
					state <= calc_interact;
				end
				
				//skip if their too far from each other or moving away from each other 
				calc_interact:
				begin
					inccol_fxs <= 0;
					inccol_fys <= 0;
					state <= ((mag_big <= diameter2) &&(mag_big>0)&& (dot_big>0) && (i!=n))?calc_col_mag:calc_col_fx;
				end
				
				calc_col_mag:
				begin
					mag <= mag_big>>5;
					state <= calc_col_dot;
				end
				
				calc_col_dot:
				begin
					dot <= dot_big>>5;
					dot_uni <= 0;
					state <= calc_dots_uni;
				end
				
				//dot/distance^2 accounts for the unit vector and the dot product 
				//divide over several clock cycles by adding until close
				//how close you get too the answer also ddetermines energy loss 
				//stop a little before you actual have the right value and your collisisons lose some velocity
				//get to the exact value and you gain a little bit of energy due to rounding errors
				//energy loss is usually preferable
				calc_dots_uni:
				begin
					dot_uni <= dot_uni+1;
					div_check <= ((dot_uni+2)*mag);
					state <= done_divide;
				end
				
				done_divide:
				begin
					state <= (div_check>dot_big)?calc_inc_colx:calc_dots_uni;
				end
				
				calc_inc_colx:
				begin
					inccol_fxs <= -(disp_x*dot_uni);
					state <= calc_inc_coly;
				end
				
				calc_inc_coly:
				begin
					inccol_fys <= -(disp_y*dot_uni);
					state <= calc_col_fx;
				end
				
				calc_col_fx: 
				begin
					col_fxs[i] <= col_fxs[i] + (inccol_fxs>>5);
					state <= calc_col_fy;
				end
					
				calc_col_fy: 
				begin	
					col_fys[i] <= col_fys[i] + (inccol_fys>>5);
					state <= next_ball;
				end
				
				next_ball:
				begin
					i <= (i == nth_ball && n == nth_ball)?0:((n == nth_ball)?i+1:i);
					n <= (i == nth_ball && n == nth_ball)?0:((n == nth_ball)?0:n+1);
					state <= (i == nth_ball && n == nth_ball)?calc_wall_colx:calc_col_disp;
				end
				
				//check wall collisioons
				calc_wall_colx:
				begin
					wall_colx[i] <= (((xps[i]) >= right_wall) && (xvs[i] > 0)) || (((xps[i]) <= left_wall) && (xvs[i] < 0));
					i <= (i == nth_ball)?0:i+1;
					state <= (i == nth_ball)?calc_wall_coly:calc_wall_colx;
				end
				
				calc_wall_coly:
				begin
					wall_coly[i] <= (((yps[i]) <= top_wall) && (yvs[i] < 0)) || (((yps[i]) >= bot_wall) && (yvs[i] > 0));
					i <= (i == nth_ball)?0:i+1;
					state <= (i == nth_ball)?calc_wall_fx:calc_wall_coly;
				end
				
				//reflect velocities by apply -2*cur_velocity as a force
				calc_wall_fx:
				begin
					wall_fxs[i] <= (wall_colx[i])?(xvs[i]*2):0;
					i <= (i == nth_ball)?0:i+1;
					state <= (i == nth_ball)?calc_wall_fy:calc_wall_fx;
				end
				
				calc_wall_fy:
				begin
					wall_fys[i] <= (wall_coly[i])?(yvs[i]*2):0;
					i <= (i == nth_ball)?0:i+1;
					state <= (i == nth_ball)?calc_friction:calc_wall_fy;
				end
				
				calc_friction:
				begin
					frictionx <= (xvs[i]==0)?0:((xvs[i]<0)?friction:-friction);
					frictiony <= (yvs[i]==0)?0:((yvs[i]<0)?friction:-friction);
					i <= (i == nth_ball)?0:i+1;
					state <= (i == nth_ball)?move_balls:calc_friction;
				end
				
				//apply all forces
				move_balls:
				begin
					xps[i] <= xps[i] + xvs[i] - wall_fxs[i] + col_fxs[i]*sw[1] + frictionx*sw[3];
					yps[i] <= yps[i] + yvs[i] - wall_fys[i] + col_fys[i]*sw[1]  + frictiony*sw[3] + g_d*sw[2];
					xvs[i] <= xvs[i] - wall_fxs[i] + col_fxs[i]*sw[1] + frictionx*sw[3];
					yvs[i] <= yvs[i] - wall_fys[i] + col_fys[i]*sw[1] + frictiony*sw[3] + g_d*sw[2];
					col_fxs[i] <= 0;
					col_fys[i] <= 0;
					i <= (i == nth_ball)?0:i+1;
					state <= (i == nth_ball)?clear_bram:move_balls;
					//state <= (i == nth_ball)?calc_col_disp:move_balls;
				end
				
				clear_bram:
				begin
					clear_addr <= (clear_addr == 20'd786432)?0:clear_addr + 1;
					state <= (clear_addr == 20'd786432)?point_bram:clear_bram;
					//clear_addr <= (clear_addr == 20'd2)?0:clear_addr + 1;
					//state <= (clear_addr == 20'd2)?point_bram:clear_bram;
				end
				
				hvcountt:
				begin
					i <= (i == nth_ball && n == no_pix)?0:((n == no_pix)?i+1:i);
					n <= (i == nth_ball && n == no_pix)?0:((n == no_pix)?0:n+1);
					xhcount <= xps[i][n_bits:frac_bits];
					yvcount <= yps[i][n_bits:frac_bits];
					state <= point_bram;
				end
				
				point_bram:
				begin
					
					write_addr <= (xhcount) + (yvcount*disp_w) + d_ci[n][n_bits:frac_bits];
					state <= (i == nth_ball && n == no_pix)?change_brams:hvcountt;
				end
				
				change_brams:
				begin
					i <= 0; 
					n <= 0;
					cur_bram <= (vsb)?next_bram:cur_bram;
					state <= (vsb)?calc_col_disp:change_brams;
				end
					
				default:
				begin
					state <= resting;
				end
			endcase
		end
	end

	always_ff @(posedge clk_65mhz)begin
		if (rst_in2) begin
			hs <= hsync;
       		vs <= vsync;
        	b <= blank;
        	
        	rgb <= 0;
		end else begin
			hs <= hsync;
			vs <= vsync;
			b <= blank;
			rgb <= data_from_bramb*white;
        end
	end
	
	always_comb begin
		case(cur_bram)
			bram1:
			begin
				write1 = 0;
				write2 = write;
				data_from_brama = data_from_brama2;
				data_from_bramb = data_from_bramb1;
				this_bram = bram1;
				next_bram = bram2;
			end
			
			bram2:
			begin
				write1 = write;
				write2 = 0;
				data_from_brama = data_from_brama1;
				data_from_bramb = data_from_bramb2;
				this_bram = bram2;
				next_bram = bram1;
			end
			
			default
			begin
				write1 = 0;
				write2 = 0;
				data_from_brama = data_from_brama2;
				data_from_bramb = data_from_bramb1;
				this_bram = bram1;
				next_bram = bram2;
			end
		endcase
	end
	
	always_comb begin
		case(state)
			clear_bram:
			begin
				addr = clear_addr;
				write = 1;
				data_to_bram = 0;
			end
			
			point_bram:
			begin
				addr = write_addr;
				write = 1;
				data_to_bram = n_ci[n];
			end
			
			default:
			begin
				addr = 0;
				write = 0;
				data_to_bram = 0;
			end
		endcase
	end
	
	assign addra1 = addr;
	assign addra2 = addr;
	assign addrb1 = hcount + vcount*disp_w;
	assign addrb2 = hcount + vcount*disp_w;
	assign data_to_brama1 = data_to_bram;
	assign data_to_brama2 = data_to_bram;
	assign led = sw;
	assign vga_r = ~b ? rgb[11:8]: 0;
	assign vga_g = ~b ? rgb[7:4] : 0;
    assign vga_b = ~b ? rgb[3:0] : 0;

    assign vga_hs = ~hs;
    assign vga_vs = ~vs;
endmodule


    
`default_nettype wire