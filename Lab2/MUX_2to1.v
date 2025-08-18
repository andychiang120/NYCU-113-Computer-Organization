//Student ID: 314551134
`timescale 1ns/1ps

module MUX_2to1(
	input      src1,
	input      src2,
	input	   select,
	output  reg result
	);

/* Write down your code HERE */
wire 	g1, g2, _select, result_w;
not 	n(_select, select);
and 	a1(g1, src1, _select);
and 	a2(g2, src2, select);
or 		o(result_w, g1, g2);

always @(*) begin
    result = result_w;
end
endmodule