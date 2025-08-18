//Student ID: 314551134
`timescale 1ns/1ps

module MUX_4to1(
	input			src1,
	input			src2,
	input			src3,
	input			src4,
	input   [2-1:0] select,
	output 	reg		result
	);

/* Write down your code HERE */
wire 	g1, g2, g3, g4, _sel0, _sel1;
not 	n1(_sel0, select[0]);
not 	n2(_sel1, select[1]);
and 	a1(g1, src1, _sel1, _sel0);
and 	a2(g2, src2, _sel1, select[0]);
and 	a3(g3, src3, select[1], _sel0);
and 	a4(g4, src4, select[1], select[0]);
or 		o1(result_w, g1, g2, g3, g4);

always @(*) begin
    result = result_w;
end

endmodule