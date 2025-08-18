`timescale 1ns/1ps
module MUX_4to1_tb;
    // DUT 介面
    reg        src1, src2, src3, src4;
    reg  [1:0] select;
    wire       result;

    MUX_4to1 dut ( .src1(src1), .src2(src2), .src3(src3), .src4(src4),
                   .select(select), .result(result) );

    // 預期值函式
    function automatic expected (input [3:0] data, input [1:0] sel);
        case (sel)
            2'b00: expected = data[0];
            2'b01: expected = data[1];
            2'b10: expected = data[2];
            2'b11: expected = data[3];
        endcase
    endfunction

    integer pattern, sel_i, err;
    initial begin
        err = 0;
        $display("time\tsel\tdata(src4..1)\tresult\texpect");

        // 外層：16 種資料
        for (pattern = 0; pattern < 16; pattern = pattern + 1) begin
            {src4, src3, src2, src1} = pattern;   // 4-bit 資料

            // 內層：4 種 select
            for (sel_i = 0; sel_i < 4; sel_i = sel_i + 1) begin
                select = sel_i[1:0];              // **只在這裡轉成 2-bit**
                #1;                               // 等待組合邏輯穩定

                if (result !== expected({src4,src3,src2,src1}, select)) begin
                    $display("%0t\t%b\t%b\t\t%b\t%b <-- MISMATCH",
                             $time, select, {src4,src3,src2,src1},
                             result,
                             expected({src4,src3,src2,src1}, select));
                    err = err + 1;
                end
                else begin
                    $display("%0t\t%b\t%b\t\t%b\t%b",
                             $time, select, {src4,src3,src2,src1},
                             result,
                             expected({src4,src3,src2,src1}, select));
                end
            end
        end

        if (err == 0)
            $display("\n==== TEST PASSED ====");
        else
            $display("\n==== TEST FAILED : %0d error(s) ====", err);

        $finish;
    end
endmodule
