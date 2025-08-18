//Student ID: 314551134
`timescale 1ns/1ps
`include "MUX_2to1.v"
`include "MUX_4to1.v"

module ALU_1bit(
	input				src1,       //1 bit source 1  (input)
	input				src2,       //1 bit source 2  (input)
	input				less,       //1 bit less      (input)
	input 				Ainvert,    //1 bit A_invert  (input)
	input				Binvert,    //1 bit B_invert  (input)
	input 				cin,        //1 bit carry in  (input)
	input 	    [2-1:0] operation,  //2 bit operation (input)
	output      reg     result,     //1 bit result    (output)
	output      reg  	cout        //1 bit carry out (output)
	);
		
/* Write down your code HERE */

wire 	_src1, _src2, i1, i2, or_result, and_result, s;
not 	n1(_src1, src1);
not 	n2(_src2, src2);
MUX_2to1 mux1(						
	.src1(src1),
	.src2(_src1),
	.select(Ainvert),
	.result(i1)
);
MUX_2to1 mux2(
	.src1(src2),
	.src2(_src2),
	.select(Binvert),
	.result(i2)
);
or 		o1(or_result, i1, i2);
and 	a1(and_result, i1, i2);

/* Full Adder */
wire	g1, g2, g3, cout_w;
xor		xor1(g1, i1, i2);
xor 	xor2(s, g1, cin);
and		a2(g2, i1, i2);
and 	a3(g3, g1, cin);
or 		o2(cout_w, g2, g3);

wire result_w;
MUX_4to1 mux3(
	.src1(or_result),
	.src2(and_result),
	.src3(s),
	.src4(less),
	.select(operation),
	.result(result_w)
);

always @(*)begin
	cout = cout_w;
	result = result_w;
end

endmodule