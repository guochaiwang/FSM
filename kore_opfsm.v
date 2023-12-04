
//verilog code for kore fsm opration 

module kore_opfsm (

  input    clk    ,
  input    rst_n    ,
  input     IR_code  ,  


  output    opcode    ,
  output    pcdata_rs0  ,
  output    pcdata_rs1  ,
  output    pcdata_bc    ,

  output    opflag    
  


);


localparam   IDLE =  8'H0;   //S0
localparam   S1   =  8'H1;   //S0  
localparam   S2   =  8'H2;   //S0
localparam   S3   =  8'H3;   //S0
localparam   S4   =  8'H4;   //S0


  reg  [7:0] cs ;
  reg  [7:0]  ns ;
  
  wire  [31:0] IR_code;

  assign  IR_code = IR_code  ;  //from IR reg

  always@(posedge clk or negedge rst_n ) begin
    if(!rst_n)  begin
        cs <= IDLE;
    end
    else begin
         cs<= ns ;
    end
  end


  
  always@(*) begin
    case(cs)
        IDLE: begin

        end
        S1:begin

        end
      default:begin
        ns = IDLE;
      end
    endcase
  end



  

  
  


  
  



endmodule



