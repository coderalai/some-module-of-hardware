`include "defines.v"
module csr_reg (
    input   wire                   clk,
    input   wire                   rst,

    // from ex
    input   wire                   we_i     ,
    input   wire    [`MemAddrBus]  raddr_i  ,
    input   wire    [`MemAddrBus]  waddr_i  ,
    input   wire    [`RegBus    ]  data_i   ,

    // from clint
    input   wire                   clint_we_i     ,
    input   wire    [`MemAddrBus]  clint_raddr_i  ,
    input   wire    [`MemAddrBus]  clint_waddr_i  ,
    input   wire    [`RegBus    ]  clint_data_i   ,

    output  wire                   global_int_en_o,

    // to clint
    output  reg     [`RegBus    ]      clint_data_o,
    output  wire    [`RegBus    ]      clint_csr_mtvec,
    output  wire    [`RegBus    ]      clint_csr_mepc,
    output  wire    [`RegBus    ]      clint_csr_mstatus,

    // to ex
    output  reg     [`RegBus    ]      data_o
);

    reg [`DoubleRegBus]      cycle;
    reg [`RegBus      ]      mtvec;
    reg [`RegBus      ]      mcause;
    reg [`RegBus      ]      mepc;
    reg [`RegBus      ]      mie;
    reg [`RegBus      ]      mstatus;
    reg [`RegBus      ]      mscratch;
    
    assign  global_int_en_o = (mstatus[3] == 1'b1)? `True: `False;

    assign  clint_csr_mtvec     = mtvec    ;
    assign  clint_csr_mepc      = mepc     ;
    assign  clint_csr_mstatus   = mstatus  ;

    // cycle couter
    always @ (posedge clk) begin
        if (rst == `RstEnable ) begin
            cycle <= {`ZeroWord, `ZeroWord};
        end else begin
            cycle <= cycle + 1'b1;
        end
    end
    
    // write reg
    always @ (posedge clk) begin
        if (rst == `RstEnable ) begin
            mtvec   <= `ZeroWord;
            mcause  <= `ZeroWord;
            mepc    <= `ZeroWord;
            mie     <= `ZeroWord;
            mstatus <= `ZeroWord;
            mscratch<= `ZeroWord;
        end else begin
            if (we_i == `WriteEnable ) begin
                case (waddr_i[11:0])
                    `CSR_MTVEC   : mtvec   <= data_i;
                    `CSR_MCAUSE  : mcause  <= data_i;
                    `CSR_MEPC    : mepc    <= data_i;
                    `CSR_MIE     : mie     <= data_i;
                    `CSR_MSTATUS : mstatus <= data_i;
                    `CSR_MSCRATCH: mscratch<= data_i;
                    default : ;
                endcase
            end else if (clint_we_i == `WriteEnable ) begin
                case (clint_waddr_i[11:0])
                    `CSR_MTVEC   : mtvec   <= clint_data_i;
                    `CSR_MCAUSE  : mcause  <= clint_data_i;
                    `CSR_MEPC    : mepc    <= clint_data_i;
                    `CSR_MIE     : mie     <= clint_data_i;
                    `CSR_MSTATUS : mstatus <= clint_data_i;
                    `CSR_MSCRATCH: mscratch<= clint_data_i;
                    default : ;
                endcase
            end
        end
    end

    // ex read csr reg
    always @ (*) begin
        if ((raddr_i[11:0] == waddr_i[11:0]) && (we_i == `WriteEnable)) begin
            data_o = data_i;
        end else begin
            case (raddr_i[11:0])
                `CSR_CYCLE   : data_o = cycle[31:0] ; 
                `CSR_CYCLEH  : data_o = cycle[63:32];
                `CSR_MTVEC   : data_o = mtvec       ;
                `CSR_MCAUSE  : data_o = mcause      ;
                `CSR_MEPC    : data_o = mepc        ;
                `CSR_MIE     : data_o = mie         ;
                `CSR_MSTATUS : data_o = mstatus     ;
                `CSR_MSCRATCH: data_o = mscratch    ;
                default      : data_o = `ZeroWord   ;
            endcase
        end
    end

    // clint read csr reg
    always @ (*) begin
        if ((clint_raddr_i[11:0] == clint_waddr_i[11:0]) && (clint_we_i == `WriteEnable)) begin
            clint_data_o = clint_data_i;
        end else begin
            case (clint_raddr_i[11:0])
                `CSR_CYCLE   : clint_data_o = cycle[31:0] ; 
                `CSR_CYCLEH  : clint_data_o = cycle[63:32];
                `CSR_MTVEC   : clint_data_o = mtvec       ;
                `CSR_MCAUSE  : clint_data_o = mcause      ;
                `CSR_MEPC    : clint_data_o = mepc        ;
                `CSR_MIE     : clint_data_o = mie         ;
                `CSR_MSTATUS : clint_data_o = mstatus     ;
                `CSR_MSCRATCH: clint_data_o = mscratch    ;
                default      : clint_data_o = `ZeroWord   ;
            endcase
        end
    end

endmodule
