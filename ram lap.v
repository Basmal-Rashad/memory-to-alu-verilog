module RAM #(
      parameter data_width =20,
      parameter adrss_width =8 )


(
  input wire clk,rst_n,wr_en,
  input wire [7:0]adrss ,
  input wire [data_width-1:0] din,
  output reg [data_width-1:0] dout,
  input wire rd_en,
  output reg ram_valid
);

reg [ data_width-1:0]mem[0:(1<<adrss_width)-1];   //memory cereation

integer i; 

always @(posedge clk or negedge rst_n ) begin

if(!rst_n)  begin
   
dout <={data_width{1'b0}}; 
  
ram_valid <=1'b0;

for(i=0;i<(1<<adrss_width );i=i+1) begin   

mem[i]<= {data_width{  1'b0 }};  end
                        
                    
                              end
 else  begin

ram_valid <=0;

if ( wr_en ) begin       
 mem[adrss]<=din ;
              end
              
              
 if(rd_en)  begin
   dout<= mem[adrss];  
  ram_valid<=1'b1; 
               end
  
  end 
 
 
  end                   
                  
                  
  endmodule
  
   
   
module piso #(     parameter WIDTH = 20,
                    parameter ADDR_WIDTH = 8
  )(

input wire clk,rst_n,en ,
  
input wire [WIDTH-1:0]parallel_in ,

 output reg        serial_out,
 output reg          valid 
  );



////////////////////////////////////

    reg [WIDTH-1:0] shift_reg;
    reg [$clog2(WIDTH):0] bit_count;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            shift_reg  <= 0;
            serial_out <= 0;
            valid      <= 0;
            bit_count  <= 0;
        end
        else begin

     if(en && !valid) begin
                shift_reg <= parallel_in;
                bit_count <= WIDTH;
                valid     <= 1'b1;
                                  end

            
    else if(valid) begin
          serial_out <= shift_reg[WIDTH-1];
           shift_reg  <= shift_reg << 1;
           bit_count  <= bit_count - 1;

     if(bit_count == 1)
                 valid <= 1'b0;
                                    end
    else begin
                serial_out <= 1'b0;
                                    end

        end
        end

endmodule


//////////////////////////////////////////////////////


module sipo #( parameter WIDTH = 20)


(
    input clk,
    input rst_n,
    input shift_en,
    input serial_in,

    output reg [WIDTH-1:0]  parallel_out
);

    always @(posedge clk or negedge rst_n) begin

        if(!rst_n) begin
            parallel_out <= 0;
                    end 
        else if(shift_en) begin
            parallel_out <= {parallel_out[WIDTH-2:0], serial_in};
                          end
    end

endmodule

module alu #(parameter WIDTH = 8)
  
  
(
   input wire [WIDTH-1:0] in_a,
   input wire  [WIDTH-1:0] in_b,
   input wire  [2:0] opcode,
   input wire  alu_en,

 output reg [WIDTH-1:0] alu_out,
 output wire a_is_zero

  );


assign a_is_zero = (in_a == 0);

always @(*) begin

    if (alu_en == 0)
        alu_out = 0;
/////////////////////////////////////////////////////
    
    
    else    begin
      
if (opcode == 3'b000)
    alu_out = in_a + in_b;

else if (opcode == 3'b001)
    alu_out = in_a - in_b;

else if (opcode == 3'b010)
    alu_out = in_a & in_b;

else if (opcode == 3'b011)
    alu_out = in_a ^ in_b;

else if (opcode == 3'b100)
    alu_out = in_a | in_b;

else if (opcode == 3'b101)
    alu_out = in_a;

else
    alu_out = 8'b0;

    end
///////////////////////////////////////////////////////////////
end

endmodule




  
  ///////////////////////////////////////////////////
  
  
  module top(

    input wire clk,
    input wire rst_n,

    input wire wr_en,
    input wire rd_en,

    input wire [7:0] adrss,
    input wire [19:0] din,

    output wire [7:0] alu_out,
    output wire a_is_zero

);


    wire [19:0] dout;
    wire   ram_valid;

    wire serial_out;
    wire valid;

    wire [19:0]  parallel_out;

   

    RAM RAM1(.clk(clk),.rst_n(rst_n),.wr_en(wr_en),.rd_en(rd_en),.adrss(adrss),.din(din),.dout(dout),.ram_valid(ram_valid));

    piso PISO1(.clk(clk),.rst_n(rst_n),.parallel_in(dout),.en(ram_valid),.serial_out(serial_out),.valid(valid));


   sipo SIPO1(.clk(clk),.rst_n(rst_n),.shift_en(valid),.serial_in(serial_out),.parallel_out(parallel_out));


   alu ALU1(.alu_en(parallel_out[19]),.opcode(parallel_out[18:16]),.in_a(parallel_out[15:8]),.in_b(parallel_out[7:0]),.alu_out(alu_out),.a_is_zero(a_is_zero));

endmodule
  
  
  ///////////////////////////////////////////////////////////////////
  
  
  
 
  
  
  
  
  
  
  
  
  