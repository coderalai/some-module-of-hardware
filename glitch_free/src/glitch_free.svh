module sig_deglitch(clk,rstn,host,host_f);
input  clk;
input  rstn;
input  host;
output host_f;

reg host_d1;
reg host_d2;

always@(posedge clk or negedge rstn)
  begin
    if(~rstn)
    begin
        host_d1 <= 1'b1;
        host_d2 <= 1'b1;
       end
    else
      begin
        host_d1 <= host;
        host_d2 <= host_d1;

      end
  end

assign host_f = host_d1 | host_d2;

endmodule

