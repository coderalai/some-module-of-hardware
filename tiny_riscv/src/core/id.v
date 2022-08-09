`include "defines.v"
module id (
    input   wire                    rst,

    input   wire    [`InstBus    ]   inst_i,
    input   wire    [`InstAddrBus]   inst_addr_i,

    input   wire    [`RegBus]        reg1_rdata_i,
    input   wire    [`RegBus]        reg2_rdata_i,

    input   wire    [`RegBus]        csr_rdata_i,

    input   wire                     ex_jump_flag_i,

    output  reg     [`RegAddrBus]    reg1_raddr_o,
    output  reg     [`RegAddrBus]    reg2_raddr_o,
                      
    output  reg     [`MemAddrBus]    csr_raddr_o,

    output  reg     [`MemAddrBus]    op1_o,
    output  reg     [`MemAddrBus]    op2_o,
    output  reg     [`MemAddrBus]    op1_jump_o,
    output  reg     [`MemAddrBus]    op2_jump_o,
    output  reg     [`InstBus    ]   inst_o,
    output  reg     [`InstAddrBus]   inst_addr_o,
    output  reg     [`RegBus]        reg1_rdata_o,
    output  reg     [`RegBus]        reg2_rdata_o,
    output  reg                      reg_we_o,
    output  reg     [`RegAddrBus]    reg_waddr_o,
    output  reg                      csr_we_o,
    output  reg     [`RegBus]        csr_rdata_o,
    output  reg     [`MemAddrBus]    csr_waddr_o
);






endmodule
