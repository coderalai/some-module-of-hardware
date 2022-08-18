`include "../core/defines.v"
module ram (
    input   wire                    clk,
    input   wire                    rst,

    input   wire                    we_i,
    input   wire    [`MemAddrBus]   addr_i,
    input   wire    [`MemBus    ]   data_i,

    output  reg     [`MemBus    ]   data_o

);

    reg [`MemBus    ]   _ram    [0:`MemNum-1];

    always @ (posedge   clk) begin
        if (we_i == `WriteEnable) begin
            _ram[addr_i[31:2]]  <= data_i;
        end
    end
        
    always @ (*) begin
        if (rst == `RstEnable) begin
            data_o = `ZeroWord;
        end else begin
            data_o = _ram[addr_i[31:2]];
        end
    end


endmodule
