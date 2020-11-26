module tb();
    reg [31:0]memx[30:0];
    initial begin
        $readmemh("counter.mem",memx);
    end
    reg clock;
    initial clock = 1'b0; 
    always #10 clock = ~clock;

    reg in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10;
    wire out0,out1,out2,out3,out4;

    fpga tb_(.in0(in0),.in1(in1),.in2(in2),.in3(in3),.in4(in4),.in5(in5),.in6(in6),.in7(in7),.in8(in8),.in9(in9),.in10(in10),
            .out0(out0),.out1(out1),.out2(out2),.out3(out3),.out4(out4),.clock(clock));

    initial begin
        tb_.lt0.mem={memx[1][0],memx[0]};
        tb_.lt1.mem={memx[3][0],memx[2]};
        tb_.lt2.mem={memx[5][0],memx[4]};
        tb_.lt3.mem={memx[7][0],memx[6]};
        tb_.lt4.mem={memx[9][0],memx[8]};
        tb_.lt5.mem={memx[11][0],memx[10]};
        tb_.lt6.mem={memx[13][0],memx[12]};
        tb_.lt7.mem={memx[15][0],memx[14]};
        tb_.lt8.mem={memx[17][0],memx[16]};
        tb_.sb0.configure=memx[18][15:0];
        tb_.sb1.configure=memx[19][15:0];
        tb_.sb2.configure=memx[20][15:0];
        tb_.sb3.configure=memx[21][15:0];
        tb_.sb4.configure=memx[22][15:0];
        tb_.sb5.configure=memx[23][15:0];
        tb_.sb6.configure=memx[24][15:0];
        tb_.sb7.configure=memx[25][15:0];
        tb_.sb8.configure=memx[26][15:0];
        tb_.sb9.configure=memx[27][15:0];
        tb_.sb10.configure=memx[28][15:0];
        tb_.sb11.configure=memx[29][15:0];
        tb_.sb12.configure=memx[30][15:0];

        in0=1'b0;
        in1=1'b1;
        #20
        $display("out: %b%b%b%b",out3,out2,out1,out0);
        in0=1'b0;
        in1=1'b1;
        #20
        $display("out: %b%b%b%b",out3,out2,out1,out0);
        in0=1'b1;
        in1=1'b0;
        #20
        $display("out: %b%b%b%b",out3,out2,out1,out0);
        in0=1'b0;
        in1=1'b0;
        #20
        $display("out: %b%b%b%b",out3,out2,out1,out0);
        in0=1'b1;
        in1=1'b0;
        #100
        $display("out: %b%b%b%b",out3,out2,out1,out0);
        $finish;
    end
    initial begin
        $dumpfile("x3.vcd");
        $dumpvars;
    end
endmodule
    