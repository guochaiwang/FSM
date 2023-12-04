
//verilog code for kore fsm opration 

module kore_opfsm (

  input    clk    ,
  input    rst_n    ,
  input    IR_code  , [31:0] pcdata_in ,    

  input    din_hs  ,   //data in hand shake 

  input    eop,    //from func fsm


  output    opcode      ,
  output    pcdata_rs0  ,
  output    pcdata_rs1  ,
  output    pcdata_rd   ,  
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
          if(pcdata_in[14:12]==3'b111)   //bc jump 
            ns = S1;
          else
            ns = IDLE; 
        end
        S1:begin
          if(eop == 1'b1 )    //wait for end of opration
              ns = S2 ;  // fanout
          else
              ns = S1 ; //wait for fanout
        end
      S2: begin
        if(pcdata_in[14:12] == 3'b111)
          ns = S3 ;
        else
          ns = S2 ;
      end
      S3: begin
        if(eop == 1'b1) 
            ns = S4;
          else
            ns = S3;
      end
      S4: begin
        if(pcdata_in[14:12] == 3'b111)
          ns = IDLE;
        else
          ns = S4;
      end
      default:begin
        ns = IDLE;
      end
    endcase
  end


  always@(posedge clk or negedge rst_n) begin
    case(ns)
      IDLE: begin
        opcode[6:0] <= pcdata_in [6:0] ;
        opflag    <= 1'b0   ;
        din_vld   <= 1'b1   ;   //wait for hand shake
        dout      <= 32'b0  ;
        dout_rdy  <= 1'b0   ;   //not rdy out
      end
      S1:  begin
          opflag  <= 1'b1  ;  //
      end
      S2:  begin
          opflag <= 1'b0;   //wait to fan out
          
      end
      S3:  begin
          opflag <= 1'b1;   //
      end
      S4:begin
         opflag <= 1'b0;   //wait to fan out
      end
      default:begin
         opflag <= 1'b0;   //wait to fan out
      end
    endcase

  end

  

  
  


  
  



endmodule



