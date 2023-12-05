
module kore_regbank(
    input           clk        ,    
    input           rst_n      ,      

    input  [4:0]       reg_sel ,    //from func fsm
    input  [31:0]      din     ,    //from func fsm
    input              wt_en   ,    //from func fsm

    output   wire [31:0]   dout        //out to top result
);
    


wire [31:0]    data_bus ;

  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin : REGISTER_GEN
      reg [31:0] kore_reg;

      always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          kore_reg <= 32'b0;
        end else if (wt_en && (reg_sel == i)) begin
          kore_reg <= din;
        end
        else begin
          kore_reg <= kore_reg ;
        end
      end
    end
  endgenerate

  always@(*) begin
    dout[31:0] = (reg_sel < 32) ? kore_reg[reg_sel] : 32'b0;
  end

endmodule       






