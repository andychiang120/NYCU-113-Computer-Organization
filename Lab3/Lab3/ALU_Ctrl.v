// student ID : 314551134
module ALU_Ctrl(
    funct_i,
    ALUOp_i,
    ALUCtrl_o,
    FURslt_o,
    leftRight_o,
    shifhterSource_o,
    JR_source_o
    );
          
// I/O ports 
input      [6-1:0] funct_i;
input      [2-1:0] ALUOp_i;

output reg [4-1:0] ALUCtrl_o;  
output reg         FURslt_o;         // 1-bit: 0=ALU, 1=Shifter
output reg         leftRight_o;
output reg         shifhterSource_o;
output reg         JR_source_o;

// funct code parameters
localparam ADD  = 6'b100011;
localparam SUB  = 6'b100001;
localparam AND  = 6'b100110;
localparam OR   = 6'b100101;
localparam NOR  = 6'b101011;
localparam SLT  = 6'b101000;
localparam SLL  = 6'b000010;
localparam SRL  = 6'b000100;
localparam SLLV = 6'b000110;
localparam SRLV = 6'b001000;
localparam JR   = 6'b001100;

always @(*) begin
    // default value
    ALUCtrl_o        = 4'b0000;
    FURslt_o         = 1'b0;
    leftRight_o      = 1'b0;
    shifhterSource_o = 1'b0;
    JR_source_o      = 1'b0;

    case (ALUOp_i)
        2'b10: begin // R-type
            case (funct_i)
                ADD:  ALUCtrl_o = 4'b0010; // add
                SUB:  ALUCtrl_o = 4'b0110; // sub
                AND:  ALUCtrl_o = 4'b0001; // and
                OR:   ALUCtrl_o = 4'b0000; // or
                NOR:  ALUCtrl_o = 4'b1101; // nor
                SLT:  ALUCtrl_o = 4'b0111; // slt

                SLL: begin
                    FURslt_o         = 1'b1; // Shifter
                    leftRight_o      = 1'b0; // <<
                    shifhterSource_o = 1'b0; // shamt
                    ALUCtrl_o        = 4'bxxxx;
                end
                SRL: begin
                    FURslt_o         = 1'b1; // Shifter
                    leftRight_o      = 1'b1; // >>
                    shifhterSource_o = 1'b0; // shamt
                    ALUCtrl_o        = 4'bxxxx;
                end
                SLLV: begin
                    FURslt_o         = 1'b1;
                    leftRight_o      = 1'b0; // <<
                    shifhterSource_o = 1'b1; // register
                    ALUCtrl_o        = 4'bxxxx;
                end
                SRLV: begin
                    FURslt_o         = 1'b1;
                    leftRight_o      = 1'b1; // <<
                    shifhterSource_o = 1'b1; // register
                    ALUCtrl_o        = 4'bxxxx;
                end

                JR: begin
                    JR_source_o = 1'b1;       // PC = register value
                    ALUCtrl_o   = 4'bxxxx;    
                end

                default: ALUCtrl_o = 4'b0000;
            endcase
        end

        2'b00: begin // addi, lw, sw
            ALUCtrl_o = 4'b0010; // add
        end

        2'b01: begin // beq, bne
            ALUCtrl_o = 4'b0110; // sub
        end

        default: begin // j, jal
            ALUCtrl_o = 4'bxxxx;
        end
    endcase
end  

endmodule
