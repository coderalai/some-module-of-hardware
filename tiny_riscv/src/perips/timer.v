`include "../core/defines.v"
module timer (
    input   wire            clk,
    input   wire            rst,

    input   wire    [31:0]  data_i,
    input   wire    [31:0]  addr_i,
    input   wire            we_i,

    output  reg     [31:0]  data_o,
    output  wire            int_sig_o
);

    localparam  REG_CTRL    = 4'h0;
    localparam  REG_COUNT   = 4'h4;
    localparam  REG_VALUE   = 4'h8;

    reg [31:0]  timer_ctrl;
    reg [31:0]  timer_count;
    reg [31:0]  timer_value;

    assign  int_sig_o   = ((timer_ctrl[2] == 1'b1) && (timer_ctrl[1] == 1'b1))? `INT_ASSERT: `  INT_DEASSERT;

    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            timer_count   <= `ZeroWord;
        end else begin
            if (timer_count[0] == 1'b1) begin
                timer_count   <= timer_count + 1'b1;
                if (timer_count >= timer_value) begin
                    timer_count <= `ZeroWord;
                end
            end else begin
                timer_count   <= `ZeroWord;
            end
        end
    end


    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            timer_ctrl  <= `ZeroWord;
            timer_value <= `ZeroWord;
        end else begin
            if (we_i == `WriteEnable) begin
                case (addr_i[3:0])
                    REG_CTRL: begin
                        timer_ctrl  <= {data_i[31:3], (timer_ctrl[2] & (~data_i[2])), data_i[1:0]};
                    end
                    REG_VALUE: begin
                        timer_value <= data_i;
                    end
                endcase
            end else begin
                if ((timer_ctrl[0] == 1'b1) && (timer_count >= timer_value) ) begin
                    timer_ctrl[0]   <= 1'b0;
                    timer_ctrl[2]   <= 1'b1;
                end
            end
        end
    end


    always @ (*) begin
        if (rst == `RstEnable) begin
            data_o = `ZeroWord;
        end else begin
            case (addr_i[3:0])
                REG_VALUE: begin
                    data_o = timer_value;
                end
                REG_CTRL: begin
                    data_o = timer_ctrl;
                end
                REG_COUNT: begin
                    data_o = timer_count;
                end
                default: begin
                    data_o = `ZeroWord;
                end
            endcase
        end
    end


endmodule
