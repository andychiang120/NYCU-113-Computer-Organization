//Student ID: 314551134
`timescale 1ns/1ps
`include "ALU_1bit.v"
module ALU(
	input                   rst_n,         // negative reset            (input)
	input	     [32-1:0]	src1,          // 32 bits source 1          (input)
	input	     [32-1:0]	src2,          // 32 bits source 2          (input)
	input 	     [ 4-1:0] 	ALU_control,   // 4 bits ALU control input  (input)
	output reg   [32-1:0]	result,        // 32 bits result            (output)
	output reg              zero,          // 1 bit when the output is 0, zero must be set (output)
	output reg              cout,          // 1 bit carry out           (output)
	output reg              overflow       // 1 bit overflow            (output)
	);
	
/* Write down your code HERE */

/* Decode the control signal */
wire Ainvert   = ALU_control[3];
wire Binvert   = ALU_control[2];
wire [1:0] op  = ALU_control[1:0];

wire [31:0] carry;
wire [31:0] result_w; 

wire set = src1[31] ^ (~src2[31]) ^ carry[31];	// the less value of ALU0

genvar i;
generate
	for (i = 0; i < 32; i = i + 1) begin : gen_alu
		if(i == 0)
			ALU_1bit alu0 (
				.src1     (src1[i]),
				.src2     (src2[i]),
				.less     (set),				
				.Ainvert  (Ainvert),
				.Binvert  (Binvert),
				.cin      (Binvert),
				.operation(op),
				.result   (result_w[i]),
				.cout     (carry[i])
			);
		else
			ALU_1bit alui (
				.src1     (src1[i]),
				.src2     (src2[i]),
				.less     (1'b0),				
				.Ainvert  (Ainvert),
				.Binvert  (Binvert),
				.cin      (carry[i-1]),
				.operation(op),
				.result   (result_w[i]),
				.cout     (carry[i])
			);
	end
endgenerate

always @(*) begin
    if (!rst_n) begin
        result   = 32'b0;
        zero     = 1'b0;
        cout     = 1'b0;
        overflow = 1'b0;
    end else begin
        result = result_w;
		zero = ~|result;							// reduction or -> not
		cout = (op == 2'b10) ? carry[31] : 1'b0;
		overflow = (op == 2'b10) ? (carry[30] ^ carry[31]) : 1'b0;;
    end
end

endmodule