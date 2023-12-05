
//verilog code for kore fsm opration 

module kore_opfsm (

  input    clk    ,
  input    rst_n    ,
  input    [31:0] pcdata_in ,    //from  ir reg 


  input    eop,    //from func fsm

  output  reg [7:0]     pc_sel  ,   //is pcdata in [32:25] to choose IR reg  
  
  output reg [6:0]   opcode      ,  
  output reg [4:0]   pcdata_rs0  ,  
  output reg [4:0]   pcdata_rs1  ,  
  output reg [4:0]   pcdata_rd   ,  
  output reg [2:0]   pcdata_bc   ,  

  output reg         opflag      

);


localparam   IDLE =  8'H0;   //S0
localparam   S1   =  8'H1;   //S0  
localparam   S2   =  8'H2;   //S0
localparam   S3   =  8'H3;   //S0
localparam   S4   =  8'H4;   //S0


  reg  [7:0] cs ;
  reg  [7:0]  ns ;


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
        pc_sel[7:0]      <= pcdata_in[32:25]  ;   //  func8
        pcdata_rs0[4:0]  <= pcdata_in[24:20]  ;   //
        pcdata_rs1[4:0]  <= pcdata_in[19:15]  ;   //
        pcdata_bc [2:0]  <= pcdata_in[14:12] ;  // 
        pcdata_rd [4:0]  <= pcdata_in[11:7]  ;   //
        opcode[6:0]      <= pcdata_in [6:0] ;
        opflag           <= 1'b0   ;
      end
      S1:  begin
        pc_sel[7:0]      <= pcdata_in[32:25]  ;   //  func8
        pcdata_rs0[4:0]  <= pcdata_in[24:20]  ;   //
        pcdata_rs1[4:0]  <= pcdata_in[19:15]  ;   //
        pcdata_bc [2:0]  <= pcdata_in[14:12] ;  // 
        pcdata_rd [4:0]  <= pcdata_in[11:7]  ;   //
        opcode[6:0]      <= pcdata_in [6:0] ;        
        opflag           <= 1'b1  ;  //
      end
      S2:  begin
        pc_sel[7:0]      <= pcdata_in[32:25]  ;   //  func8
        pcdata_rs0[4:0]  <= pcdata_in[24:20]  ;   //
        pcdata_rs1[4:0]  <= pcdata_in[19:15]  ;   //
        pcdata_bc [2:0]  <= pcdata_in[14:12] ;  // 
        pcdata_rd [4:0]  <= pcdata_in[11:7]  ;   //
        opcode[6:0]      <= pcdata_in [6:0] ;    
        opflag <= 1'b0;   //wait to fan out          
      end
      S3:  begin
        pc_sel[7:0]      <= pcdata_in[32:25]  ;   //  func8
        pcdata_rs0[4:0]  <= pcdata_in[24:20]  ;   //
        pcdata_rs1[4:0]  <= pcdata_in[19:15]  ;   //
        pcdata_bc [2:0]  <= pcdata_in[14:12] ;  // 
        pcdata_rd [4:0]  <= pcdata_in[11:7]  ;   //
        opcode[6:0]      <= pcdata_in [6:0] ;    
          opflag <= 1'b1;   //
      end
      S4:begin
        pc_sel[7:0]      <= pcdata_in[32:25]  ;   //  func8
        pcdata_rs0[4:0]  <= pcdata_in[24:20]  ;   //
        pcdata_rs1[4:0]  <= pcdata_in[19:15]  ;   //
        pcdata_bc [2:0]  <= pcdata_in[14:12] ;  // 
        pcdata_rd [4:0]  <= pcdata_in[11:7]  ;   //
        opcode[6:0]      <= pcdata_in [6:0] ;    
        opflag <= 1'b0;   //wait to fan out
      end
      default:begin
        pc_sel[7:0]      <= pcdata_in[32:25]  ;   //  func8
        pcdata_rs0[4:0]  <= pcdata_in[24:20]  ;   //
        pcdata_rs1[4:0]  <= pcdata_in[19:15]  ;   //
        pcdata_bc [2:0]  <= pcdata_in[14:12] ;  // 
        pcdata_rd [4:0]  <= pcdata_in[11:7]  ;   //
        opcode[6:0]      <= pcdata_in [6:0] ;    
        opflag <= 1'b0;   //wait to fan out
      end
    endcase

  end

  

  
  


  
  



endmodule



