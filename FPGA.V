//old module used

module logic_tile(out,clock,in1,in2,in3,in4,in5);
	input clock,in1,in2,in3,in4,in5;
	output out;

	reg [32:0] mem;
	reg lutout;
	reg q,notq;

	initial begin
		q=1'b0;
		lutout=1'b0;
	end

	always@(in5,in4,in3,in2,in1,mem[31:0])
	begin
		case({in5,in4,in3,in2,in1})
			5'b00000 : lutout=mem[0];
			5'b00001 : lutout=mem[1];
			5'b00010 : lutout=mem[2];
			5'b00011 : lutout=mem[3];
			5'b00100 : lutout=mem[4];
			5'b00101 : lutout=mem[5];
			5'b00110 : lutout=mem[6];
			5'b00111 : lutout=mem[7];
			5'b01000 : lutout=mem[8];
			5'b01001 : lutout=mem[9];
			5'b01010 : lutout=mem[10];
			5'b01011 : lutout=mem[11];
			5'b01100 : lutout=mem[12];
			5'b01101 : lutout=mem[13];
			5'b01110 : lutout=mem[14];
			5'b01111 : lutout=mem[15];
			5'b10000 : lutout=mem[16];
			5'b10001 : lutout=mem[17];
			5'b10010 : lutout=mem[18];
			5'b10011 : lutout=mem[19];
			5'b10100 : lutout=mem[20];
			5'b10101 : lutout=mem[21];
			5'b10110 : lutout=mem[22];
			5'b10111 : lutout=mem[23];
			5'b11000 : lutout=mem[24];
			5'b11001 : lutout=mem[25];
			5'b11010 : lutout=mem[26];
			5'b11011 : lutout=mem[27];
			5'b11100 : lutout=mem[28];
			5'b11101 : lutout=mem[29];
			5'b11110 : lutout=mem[30];
			5'b11111 : lutout=mem[31];
//			default : lutout=1'bx;
		endcase
	end

	always@(posedge clock)
	begin
		q <= lutout;
		notq <= !lutout;
	end

	reg out;
	
	always@(*)
	begin
		if(mem[32]==1'b0)
			out=lutout;
		else if(mem[32]==1'b1)
			out=q;
//		else
//			out=1'bx;
	end
endmodule

module switch_box_4x4(out,in);
	input [3:0] in;
	output [3:0] out;
	
	reg [15:0] configure;
	reg [3:0] out;
	
	initial begin
		out=4'b0000;
	end

	always@(in)	begin
	out[0]<=(configure[0]&in[0])|(configure[1]&in[1])|(configure[2]&in[2])|(configure[3]&in[3]);
	out[1]<=(configure[4]&in[0])|(configure[5]&in[1])|(configure[6]&in[2])|(configure[7]&in[3]);
	out[2]<=(configure[8]&in[0])|(configure[9]&in[1])|(configure[10]&in[2])|(configure[11]&in[3]);
	out[3]<=(configure[12]&in[0])|(configure[13]&in[1])|(configure[14]&in[2])|(configure[15]&in[3]);
	end

endmodule

//new fpga

module fpga(in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,out0,out1,out2,out3,out4,clock);
    input in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,clock;
    output out0,out1,out2,out3,out4;

	//for 3(mux) in8,in9,in10 will be control bits, in 10 being msb
	//for 1(adder) in0-in3 -first num (in3 msb), in4-in7 -second num(in7 msb), in8 -cin
	//for 6(synch counter) {in0,in1}={c,d}

	wire [3:0] sout9;
	wire [3:0] insy;
	switch_box_4x4 sb9(sout9,insy);			//switch box for synch counter

	wire [3:0] sout0,sout1,sout2,sout3,sout4,sout5;
	wire [3:0] sin0,sin1,sin2,sin3,sin4,sin5;
	assign sin0={in3,in2,in1,in0};
	assign sin1={in5,in4,in1,in0};
	assign sin2={in7,in6,in1,in0};
	assign sin3={1'b0,1'b0,sout9[0],in8};
	assign sin4={1'b0,1'b0,sout9[1],in4};
	assign sin5={1'b0,1'b0,sout9[2],in5};
	switch_box_4x4 sb0(sout0,sin0);
	switch_box_4x4 sb1(sout1,sin1);
	switch_box_4x4 sb2(sout2,sin2);
	switch_box_4x4 sb3(sout3,sin3);
	switch_box_4x4 sb4(sout4,sin4);
	switch_box_4x4 sb5(sout5,sin5);

	wire ltout0,ltout1,ltout2,ltout3;
	logic_tile lt0(ltout0,clock,in0,in1,sout3[0],sout4[0],sout5[0]);
	logic_tile lt1(ltout1,clock,sout0[0],sout0[1],sout3[0],sout4[0],sout5[0]);
	logic_tile lt2(ltout2,clock,sout1[0],sout1[1],sout3[0],sout4[0],sout5[0]);
	logic_tile lt3(ltout3,clock,sout2[0],sout2[1],sout3[0],sout4[0],sout5[0]);

	wire [3:0] sout6,sout7,sout8;
	wire [3:0] sin6,sin7,sin8;
	assign sin6={in3,in2,ltout1,ltout0};
	assign sin7={in7,in6,in9,ltout2};
	assign sin8={in3,in2,ltout3,ltout2};
	switch_box_4x4 sb6(sout6,sin6);
	switch_box_4x4 sb7(sout7,sin7);
	switch_box_4x4 sb8(sout8,sin8);

	wire ltout4,ltout5,ltout6,ltout7;
	logic_tile lt4(ltout4,clock,sout6[0],sout6[1],sout7[0],sout7[1],sout7[2]);
	logic_tile lt5(ltout5,clock,sout8[0],sout8[1],sout7[0],sout7[1],sout7[2]);
	logic_tile lt6(ltout6,clock,in2,in3,ltout2,in6,in7);
	logic_tile lt7(ltout7,clock,sout9[3],ltout3,1'b0,1'b0,1'b0);

	wire ltout8;
	logic_tile lt8(ltout8,clock,ltout4,ltout5,in10,1'b0,1'b0);

	wire [3:0] sout10,sout11,sout12;
	wire [3:0] sin10,sin11,sin12;
	assign sin10={1'b0,ltout8,ltout0,ltout0};		//out0
	assign sin11={1'b0,1'b0,ltout2,ltout4};			//out2
	assign sin12={1'b0,1'b0,ltout7,ltout5};			//out3
	switch_box_4x4 sb10(sout10,sin10);
	switch_box_4x4 sb11(sout11,sin11);
	switch_box_4x4 sb12(sout12,sin12);

	assign out0=sout10[0];
	assign out1=ltout1;
	assign out2=sout11[0];
	assign out3=sout12[0];
	assign out4=ltout6;

	assign insy={ltout7,ltout2,ltout1,ltout0};
	
endmodule
    
    
    


