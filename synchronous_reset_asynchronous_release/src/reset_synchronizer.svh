module reset_synchronizer (clk, asyncrst_n, rst_n);
    input           clk;
    input           asyncrst_n;
    output  reg     rst_n;

    reg     rff;

    always @ (posedge clk or negedge asyncrst_n) begin
        if (!asyncrst_n) begin
            {rst_n,rff} <= 2'b0;
        end else begin
            {rst_n,rff} <= {rff,1'b1};
        end
    end

endmodule
