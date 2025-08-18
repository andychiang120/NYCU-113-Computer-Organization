// student ID : 314551134
module ALU_Ctrl(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
    );
          
// I/O ports 
input      [6-1:0] funct_i;
input      [2-1:0] ALUOp_i;

output reg [4-1:0] ALUCtrl_o;  

// funct code parameters
localparam ADD  = 6'b100011;
localparam SUB  = 6'b100001;
localparam AND  = 6'b100110;
localparam OR   = 6'b100101;
localparam NOR  = 6'b101011;
localparam SLT  = 6'b101000;

always @(*) begin
    // default value
    ALUCtrl_o        = 4'b0000;

    case (ALUOp_i)
        2'b10: begin // R-type
            case (funct_i)
                ADD:  ALUCtrl_o = 4'b0010; // add
                SUB:  ALUCtrl_o = 4'b0110; // sub
                AND:  ALUCtrl_o = 4'b0001; // and
                OR:   ALUCtrl_o = 4'b0000; // or
                NOR:  ALUCtrl_o = 4'b1101; // nor
                SLT:  ALUCtrl_o = 4'b0111; // slt

                default: ALUCtrl_o = 4'b0000;
            endcase
        end

        2'b00: begin // addi, lw, sw
            ALUCtrl_o = 4'b0010; // add
        end

        2'b01: begin // beq, bne
            ALUCtrl_o = 4'b0110; // sub
        end
    endcase
end  

endmodule
