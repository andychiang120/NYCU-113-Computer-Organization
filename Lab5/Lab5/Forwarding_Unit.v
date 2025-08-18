// ID : 314551134
module Forwarding_Unit(
    regwrite_mem,
    regwrite_wb,
    idex_regs,
    idex_regt,
    exmem_regd,
    memwb_regd,
    forwarda,
    forwardb
);

input wire regwrite_mem;
input wire regwrite_wb;
input wire [5-1:0] idex_regs;
input wire [5-1:0] idex_regt;
input wire [5-1:0] exmem_regd;
input wire [5-1:0] memwb_regd;
output reg [2-1:0] forwarda;
output reg [2-1:0] forwardb;

always @(*) begin
    // default
    forwarda = 2'b00;
    forwardb = 2'b00;

    // EX Hazard
    if (regwrite_mem && (exmem_regd != 0) && (exmem_regd == idex_regs))
        forwarda = 2'b01;

    if (regwrite_mem && (exmem_regd != 0) && (exmem_regd == idex_regt))
        forwardb = 2'b01;

    // MEM Hazard
    if (regwrite_wb && (memwb_regd != 0) &&
        !(regwrite_mem && (exmem_regd != 0) && (exmem_regd == idex_regs)) &&
        (memwb_regd == idex_regs))
        forwarda = 2'b10;

    if (regwrite_wb && (memwb_regd != 0) &&
        !(regwrite_mem && (exmem_regd != 0) && (exmem_regd == idex_regt)) &&
        (memwb_regd == idex_regt))
        forwardb = 2'b10;
end

endmodule
