



module  IR_REG ( 
    input           clk       ,      
    input           rst_n     ,

    input           wt_en     ,         //from apb reg
    input   [4:0]   cfg_sel   ,   //from apb reg
    input   [31:0]  din       ,   //from apb reg

    input   [7:0]   pc_sel    ,   //from fsm op

    output wire  [31:0]   pcdata  //to fsm op

    
);

  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin : REGISTER_GEN
      reg [31:0] IR_reg;

      always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          IR_reg <= 32'b0;
        end else if (wt_en && (cfg_sel == i)) begin
          IR_reg <= din;
        end
        else begin
          IR_reg <= IR_reg ;
        end
      end
    end
  endgenerate

  always@(*) begin
    pcdata[31:0] = (pc_sel < 32) ? IR_reg[pc_sel] : 32'b0;
  end





endmodule










