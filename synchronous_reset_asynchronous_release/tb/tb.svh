module tb ();
    logic      clk       ; 
    logic      asyncrst_n; 
    logic      rst_n     ; 

    initial begin
        clk = 0;
        repeat (100) #10 clk = ~clk;
        $finish();
    end
    initial begin
        asyncrst_n = 1;
        #14 asyncrst_n = 0;
        #14 asyncrst_n = 1;
        #50 asyncrst_n = 0;
        #14 asyncrst_n = 1;
    end

     initial begin
        $fsdbDumpfile("wave_out.fsdb");
        $fsdbDumpvars;
     end

    reset_synchronizer reset_synchronizer_i (
       .clk                 (clk       ),
       .asyncrst_n          (asyncrst_n),
       .rst_n               (rst_n     )   
    );

endmodule
