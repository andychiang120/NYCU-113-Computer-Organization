// ID : 314551134
module Hazard_Detection(
    memread,
    instr_i,
    idex_regt,
    branch,
    pcwrite,
    ifid_write,
    ifid_flush,
    idex_flush,
    exmem_flush
);

input wire        memread;
input wire [32-1:0] instr_i;
input wire [5-1:0]  idex_regt;          
input wire        branch;      
output reg        pcwrite;        
output reg        ifid_write;     
output reg        ifid_flush;     
output reg        idex_flush;
output reg        exmem_flush;

wire [5-1:0] rs = instr_i[25:21];
wire [5-1:0] rt = instr_i[20:16];

always @(*) begin
    pcwrite     = 1;
    ifid_write  = 1;
    ifid_flush  = 0;
    idex_flush  = 0;
    exmem_flush = 0;

    // Load use
    if (memread && ((idex_regt == rs) || (idex_regt == rt))) begin
        pcwrite     = 0;
        ifid_write  = 0;
        idex_flush  = 1; 
    end
    // Branch Taken
    if (branch) begin
        ifid_flush  = 1;
        idex_flush  = 1;
        exmem_flush = 1;
    end
end

endmodule