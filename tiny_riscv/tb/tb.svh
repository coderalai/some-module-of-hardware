`include "defines.v"
module tb ();

    logic               clk              ;
    logic               rst              ;
                       
    logic [`MemAddrBus] rib_ex_addr_o    ;
    logic [`MemBus]     rib_ex_data_i    ;
    logic [`MemBus]     rib_ex_data_o    ;
    logic               rib_ex_req_o     ;
    logic               rib_ex_we_o      ;
                       
    logic [`MemAddrBus] rib_pc_addr_o    ;
    logic [`MemBus]     rib_pc_data_i    ;
                       
    logic [`RegAddrBus] jtag_reg_addr_i  ;
    logic [`RegBus]     jtag_reg_data_i  ;
    logic               jtag_reg_we_i    ;
    logic [`RegBus]     jtag_reg_data_o  ;
                       
    logic               rib_hold_flag_i  ;
    logic               jtag_halt_flag_i ;
    logic               jtag_reset_flag_i;
                       
    logic [`INT_BUS]    int_i            ;




    tinyriscv u_tinyriscv (
        .clk                (clk              ),
        .rst                (rst              ),

        .rib_ex_addr_o      (rib_ex_addr_o    ),
        .rib_ex_data_i      (rib_ex_data_i    ),
        .rib_ex_data_o      (rib_ex_data_o    ),
        .rib_ex_req_o       (rib_ex_req_o     ),
        .rib_ex_we_o        (rib_ex_we_o      ),

        .rib_pc_addr_o      (rib_pc_addr_o    ),
        .rib_pc_data_i      (rib_pc_data_i    ),

        .jtag_reg_addr_i    (jtag_reg_addr_i  ),    
        .jtag_reg_data_i    (jtag_reg_data_i  ),
        .jtag_reg_we_i      (jtag_reg_we_i    ),
        .jtag_reg_data_o    (jtag_reg_data_o  ),

        .rib_hold_flag_i    (rib_hold_flag_i  ),
        .jtag_halt_flag_i   (jtag_halt_flag_i ),
        .jtag_reset_flag_i  (jtag_reset_flag_i),

        .int_i              (int_i            ) 
    
    );


    initial begin
       $fsdbDumpfile("wave_out.fsdb");
       $fsdbDumpvars;
    end
    

endmodule
