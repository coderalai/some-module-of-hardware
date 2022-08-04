module tb;

    logic       clk   ;
    logic       rstn  ;
    logic       host  ;
    logic       host_f;
    
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        rstn = 1;
        #15 rstn = ~rstn;
        #20 rstn = ~rstn;
    end


    initial begin
        #1   host = 1;
        #100 host = 0;
        #19  host = 1;
        #100;
        //repeat(100) #17 host = ~host;
        $finish();
    end

     initial begin
        $fsdbDumpfile("wave_out.fsdb");
        $fsdbDumpvars;
     end

    sig_deglitch  sig_deglitch_i(
      .clk          ( clk     ),    
      .rstn         ( rstn    ),
      .host         ( host    ),
      .host_f       ( host_f  ) 
    );


endmodule
