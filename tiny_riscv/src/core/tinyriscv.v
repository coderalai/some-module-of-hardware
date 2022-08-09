
`include "defines.v"

module tinyriscv (
    input   wire clk,
    input   wire rst,

    output  wire    [`MemAddrBus]   rib_ex_addr_o,
    input   wire    [`MemBus]       rib_ex_data_i,
    output  wire    [`MemBus]       rib_ex_data_o,
    output  wire                    rib_ex_req_o,
    output  wire                    rib_ex_we_o,

    output  wire    [`MemAddrBus]   rib_pc_addr_o,
    input   wire    [`MemBus]       rib_pc_data_i,

    input   wire    [`RegAddrBus]   jtag_reg_addr_i,
    input   wire    [`RegBus]       jtag_reg_data_i,
    input   wire                    jtag_reg_we_i,
    output  wire    [`RegBus]       jtag_reg_data_o,

    input   wire                    rib_hold_flag_i,
    input   wire                    jtag_halt_flag_i,
    input   wire                    jtag_reset_flag_i,

    input   wire    [`INT_BUS]      int_i
);







endmodule
