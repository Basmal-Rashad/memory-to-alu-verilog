
 
  module  test ;

reg clk;
reg rst_n;
reg wr_en;
reg rd_en;
reg [7:0] adrss;
reg [19:0] din;
wire [7:0] alu_out;
wire a_is_zero;

top DUT ( 

.clk(clk),.rst_n(rst_n),.wr_en(wr_en),.rd_en(rd_en),.adrss(adrss),.din(din),.alu_out(alu_out),.a_is_zero(a_is_zero));
  
  
always #5 clk = ~clk;    //   period time 10sec

initial begin

clk = 0;
rst_n = 0;
wr_en = 0;
rd_en = 0;
adrss = 0;
din = 0;

  
#20;
rst_n = 1;
adrss = 8'd0;
din = {1'b1,3'b000,8'd5,8'd3};


wr_en = 1;
#10;
wr_en = 0;


rd_en = 1;
#10;
rd_en = 0;


#250;
$stop;

end

endmodule  