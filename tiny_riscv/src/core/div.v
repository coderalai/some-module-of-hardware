module div (
    input   wire                    clk         ,  
    input   wire                    rst         ,

    // from ex
    input   wire    [`RegBus    ]   dividend_i  ,
    input   wire    [`RegBus    ]   divisor_i   ,
    input   wire                    start_i     ,
    input   wire    [2:0        ]   op_i        ,
    input   wire    [`RegAddrBus]   reg_waddr_i ,

    // to ex
    output  reg     [`RegBus    ]   result_o    ,
    output  reg                     ready_o     ,
    output  reg                     busy_o      ,
    output  reg     [`RegAddrBus]   reg_waddr_o 
);

    localparam  STATE_IDLE = 4'b0001; 
    localparam  STATE_START= 4'b0010; 
    localparam  STATE_CALC = 4'b0100; 
    localparam  STATE_END  = 4'b1000; 


    reg [`RegBus    ]       dividend_r   ;
    reg [`RegBus    ]       divisor_r    ;   
    reg [2:0        ]       op_r         ;
    reg [3:0        ]       state        ;
    reg [31:0       ]       count        ;
    reg [`RegBus    ]       div_result   ;      
    reg [`RegBus    ]       div_remain   ;   
    reg [`RegBus    ]       minuend      ;   
    reg                     invert_result;

    wire    op_div  = (op_r == `INST_DIV );
    wire    op_divu = (op_r == `INST_DIVU );
    wire    op_rem  = (op_r == `INST_REM );
    wire    op_remu = (op_r == `INST_REMU );

    wire [31:0] dividend_invert     = (~dividend_r);
    wire [31:0] divisor_invert      = (~divisor_r);
    wire        minuend_ge_divisor  = minuend > divisor_r;
    wire [31:0] minuend_sub_res     = minuend - divisor_r;
    wire [31:0] div_result_tmp      = minuend_ge_divisor? ({div_result[30:0], 1'b1}): ({div_result[30:0], 1'b0});
    wire [31:0] minuend_tmp         = minuend_ge_divisor? minuend_sub_res[30:0]: minuend[30:0];


    always @ (posedge clk) begin
        if (rst == `RstEnable ) begin
            state           <= STATE_IDLE ;
            ready_o         <= `DivResultNotReady;
            result_o        <= `ZeroWord;
            div_result      <= `ZeroWord;
            div_remain      <= `ZeroWord;
            op_r            <= 3'h0;
            reg_waddr_o     <= `ZeroWord;
            dividend_r      <= `ZeroWord;
            divisor_r       <= `ZeroWord;
            minuend         <= `ZeroWord;
            invert_result   <= 1'b0;
            busy_o          <= `False;
            count           <= `ZeroWord;
        end else begin
            case (state)
                STATE_IDLE: begin
                    if (start_i == `DivStart ) begin
                        op_r            <= op_i;
                        reg_waddr_o     <= reg_waddr_i;
                        dividend_r      <= dividend_i;
                        divisor_r       <= divisor_i ;
                        state           <= STATE_START ;
                        busy_o          <= `True;
                    end else begin
                        op_r            <= 3'h0;
                        reg_waddr_o     <= `ZeroWord;
                        dividend_r      <= `ZeroWord;
                        divisor_r       <= `ZeroWord;
                        busy_o          <= `False;
                        ready_o         <= `DivResultNotReady;
                        result_o        <= `ZeroWord;
                    end
                end
                STATE_START: begin
                    if (start_i == `DivStart) begin
                        if (divisor_r == `ZeroWord) begin
                            if (op_div | op_divu) begin
                                result_o    <= 32'hffffffff;
                            end else begin
                                result_o    <= dividend_r;
                            end
                            ready_o <= `DivResultReady;
                            state   <= STATE_IDLE;
                            busy_o  <= `False;
                        end else begin
                            busy_o  <= `True;
                            count   <= 32'h40000000;
                            state   <= STATE_CALC ;
                            div_result  <= `ZeroWord;
                            div_remain  <= `ZeroWord;
                            
                            if (op_div | op_rem) begin
                                if (dividend_r[31]==1'b1) begin
                                    dividend_r  <= dividend_invert;
                                    minuend <= dividend_invert[31];
                                end else begin
                                    minuend <= dividend_r[31];
                                end

                                if (divisor_r[31] == 1'b1) begin
                                    divisor_r   <= divisor_invert;
                                end
                            end else begin
                                minuend <= dividend_r[31];
                            end
                            
                            if ((op_div && (dividend_r[31] ^ divisor_r[31] == 1'b1)) || (op_rem && (dividend_r[31] == 1'b1))) begin
                                invert_result   <= 1'b1;
                            end else begin
                                invert_result   <= 1'b0;
                            end
                        end
                    end else begin
                        state   <= STATE_IDLE;
                        busy_o          <= `False;
                        ready_o         <= `DivResultNotReady;
                        result_o        <= `ZeroWord;
                    end
                end
                STATE_CALC: begin
                    if (start_i == `DivStart) begin
                        dividend_r  <= {dividend_r[30:0], 1'b0};
                        div_result  <= div_result_tmp;
                        count       <= {1'b0, count[31:1]};
                        if (|count) begin
                            minuend <= {minuend_tmp[30:0], dividend_r[30]};
                        end else begin
                            state   <= STATE_END;
                            if (minuend_ge_divisor) begin
                                div_remain  <= minuend_sub_res;
                            end else begin
                                div_remain  <= minuend;
                            end
                        end
                    end else begin
                        state       <= STATE_IDLE;
                        result_o    <= `ZeroWord;
                        ready_o     <= `DivResultNotReady;
                        busy_o      <= `False; 
                    end
                end
                STATE_END: begin
                    if (start_i == `DivStart) begin
                        ready_o     <= `DivResultReady;
                        state       <= STATE_IDLE;
                        busy_o      <= `False; 
                        if (op_div | op_divu) begin
                            if (invert_result) begin
                                result_o    <= (~div_result);
                            end else begin
                                result_o    <= div_result;
                            end
                        end else begin
                            if (invert_result) begin
                                result_o    <= (~div_remain);
                            end else begin
                                result_o    <= div_remain;
                            end
                        end
                    end else begin
                        state       <= STATE_IDLE;
                        result_o    <= `ZeroWord;
                        ready_o     <= `DivResultNotReady;
                        busy_o      <= `False; 
                    end
                end

            endcase
        end
    end





endmodule
