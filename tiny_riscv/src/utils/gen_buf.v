module gen_ticks_sync # (
    parameter   DP = 2,
    parameter   DW = 32
)(
    input   wire            rst,
    input   wire            clk,

    input   wire    [DW-1:0]    din,
    output  wire    [DW-1:0]    dout
);

    wire    [DW-1:0]    sync_dat[DP-1:0];

    genvar  i;

    generate
        for (i = 0; i < DP; i = i+1) begin: dp_width
            if (i == 0) begin: dp_is_o
                gen_rst_0_dff # (DW) rst_0_dff (clk, rst, din, sync_dat[0]);
            end else begin: dp_is_not_0
                gen_rst_0_dff # (DW) rst_0_dff (clk, rst, sync_dat[i-1], sync_dat[i]);
            end
        end
    endgenerate

    assign  dout = sync_dat[DP-1];

endmodule
