`timescale 1ns/1ps

module ALU_Ctrl_tb;

    // DUT I/O
    reg  [5:0] funct_i;
    reg  [1:0] ALUOp_i;

    wire [3:0] ALUCtrl_o;
    wire       FURslt_o;
    wire       leftRight_o;
    wire       shifhterSource_o;
    wire       PC_source_o;

    // Instantiate DUT
    ALU_Ctrl dut (
        .funct_i(funct_i),
        .ALUOp_i(ALUOp_i),
        .ALUCtrl_o(ALUCtrl_o),
        .FURslt_o(FURslt_o),
        .leftRight_o(leftRight_o),
        .shifhterSource_o(shifhterSource_o),
        .PC_source_o(PC_source_o)
    );

    // funct encodings (與 DUT 一致)
    localparam ADD  = 6'b100011;
    localparam SUB  = 6'b100001;
    localparam AND_ = 6'b100110;
    localparam OR_  = 6'b100101;
    localparam NOR_ = 6'b101011;
    localparam SLT  = 6'b101000;
    localparam SLL  = 6'b000010;
    localparam SRL  = 6'b000100;
    localparam SLLV = 6'b000110;
    localparam SRLV = 6'b001000;
    localparam JR   = 6'b001100;

    integer pass_cnt, fail_cnt;

    // 顯示目前輸出
    task show;
        begin
            #1;
            $display("  -> ALUOp=%b funct=%b | ALUCtrl=%b FUR=%b LR=%b SRC=%b PCsrc=%b",
                     ALUOp_i, funct_i, ALUCtrl_o, FURslt_o, leftRight_o, shifhterSource_o, PC_source_o);
        end
    endtask

    // 期望 ALUCtrl 是確定值
    task expect_exact;
        input [3:0] exp_alu;
        input       exp_fur, exp_lr, exp_src, exp_pc;
        begin
            #1;
            if (ALUCtrl_o === exp_alu &&
                FURslt_o  === exp_fur &&
                leftRight_o === exp_lr &&
                shifhterSource_o === exp_src &&
                PC_source_o === exp_pc) begin
                pass_cnt = pass_cnt + 1;
                $display("  PASS");
            end else begin
                fail_cnt = fail_cnt + 1;
                $display("  FAIL (got ALU=%b, FUR=%b, LR=%b, SRC=%b, PCsrc=%b)",
                         ALUCtrl_o, FURslt_o, leftRight_o, shifhterSource_o, PC_source_o);
            end
        end
    endtask

    // 期望 ALUCtrl 是 xxxx（含 X 比較）
    task expect_x_alu;
        input       exp_fur, exp_lr, exp_src, exp_pc;
        begin
            #1;
            if (ALUCtrl_o === 4'bxxxx &&
                FURslt_o  === exp_fur &&
                leftRight_o === exp_lr &&
                shifhterSource_o === exp_src &&
                PC_source_o === exp_pc) begin
                pass_cnt = pass_cnt + 1;
                $display("  PASS");
            end else begin
                fail_cnt = fail_cnt + 1;
                $display("  FAIL (got ALU=%b, FUR=%b, LR=%b, SRC=%b, PCsrc=%b)",
                         ALUCtrl_o, FURslt_o, leftRight_o, shifhterSource_o, PC_source_o);
            end
        end
    endtask

    initial begin
        // 波形（可用 GTKWave 看）
        $dumpfile("ALU_Ctrl_tb.vcd");
        $dumpvars(0, ALU_Ctrl_tb);

        pass_cnt = 0; fail_cnt = 0;

        // ---------------- R-type：ALU 類 ----------------
        ALUOp_i = 2'b10;

        funct_i = ADD;   $display("R add");  show(); expect_exact(4'b0010, 1'b0, 1'b0, 1'b0, 1'b0);
        funct_i = SUB;   $display("R sub");  show(); expect_exact(4'b0110, 1'b0, 1'b0, 1'b0, 1'b0);
        funct_i = AND_;  $display("R and");  show(); expect_exact(4'b0001, 1'b0, 1'b0, 1'b0, 1'b0);
        funct_i = OR_;   $display("R or ");  show(); expect_exact(4'b0000, 1'b0, 1'b0, 1'b0, 1'b0);
        funct_i = NOR_;  $display("R nor");  show(); expect_exact(4'b1101, 1'b0, 1'b0, 1'b0, 1'b0);
        funct_i = SLT;   $display("R slt");  show(); expect_exact(4'b0111, 1'b0, 1'b0, 1'b0, 1'b0);

        // ---------------- R-type：Shifter 類 ----------------
        funct_i = SLL;   $display("R sll");  show(); expect_x_alu(1'b1, 1'b0, 1'b0, 1'b0);
        funct_i = SRL;   $display("R srl");  show(); expect_x_alu(1'b1, 1'b1, 1'b0, 1'b0);
        funct_i = SLLV;  $display("R sllv"); show(); expect_x_alu(1'b1, 1'b0, 1'b1, 1'b0);
        funct_i = SRLV;  $display("R srlv"); show(); expect_x_alu(1'b1, 1'b1, 1'b1, 1'b0);

        // ---------------- R-type：JR ----------------
        funct_i = JR;    $display("R jr ");  show(); expect_x_alu(1'b0, 1'b0, 1'b0, 1'b1);

        // ---------------- I-type：addi/lw/sw ----------------
        ALUOp_i = 2'b00; funct_i = 6'bxxxxxx;
        $display("I addi/lw/sw"); show(); expect_exact(4'b0010, 1'b0, 1'b0, 1'b0, 1'b0);

        // ---------------- Branch：beq/bne ----------------
        ALUOp_i = 2'b01; funct_i = 6'bxxxxxx;
        $display("I beq/bne   "); show(); expect_exact(4'b0110, 1'b0, 1'b0, 1'b0, 1'b0);

        // ---------------- Default（如 j/jal） ----------------
        ALUOp_i = 2'b11; funct_i = 6'b000000;
        $display("default     "); show(); expect_x_alu(1'b0, 1'b0, 1'b0, 1'b0);

        $display("\nSummary: PASS=%0d, FAIL=%0d\n", pass_cnt, fail_cnt);
        if (fail_cnt == 0) $display("ALL TESTS PASSED");
        else               $display("SOME TESTS FAILED");

        $finish;
    end

endmodule
