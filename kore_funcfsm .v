module  kore_funcfsm (
        input   clk     ,
        input   rst_n    ,

        input   [6:0]  opcode      ,   
        input   [4:0]  pcdata_rs0  ,   
        input   [4:0]  pcdata_rs1  ,   
        input   [4:0]  pcdata_rd   ,   
        input   [2:0]  pcdata_bc   ,        

        input   opflag      ,

        input   [31:0]   data_bus , 


        output  reg [4:0]    reg_sel   ,    //to kore regbank       //RS1//RS2//RD
        output      reg_rd    ,           //  
        output   [31:0]   data_out  ,    // data to kore_regbank        

        output      wt_en      ,           //write enable  to kore_regbank
        output   reg    eop                    //end of opration

);


localparam   IDLE =  8'H0;   //S0
localparam   S1   =  8'H1;   //S0  
localparam   S2   =  8'H2;   //S0
localparam   S3   =  8'H3;   //S0
localparam   S4   =  8'H4;   //S0




  reg  [7:0] cs ;
  reg  [7:0]  ns ;

  reg [31:0] opradata_rs0;
  reg [31:0] opradata_rs1;
  reg [31:0] opradata_rd;




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
          if(opflag == 1'b1)   //bc jump 
            ns = S1;
          else
            ns = IDLE; 
        end
        S1:begin
            ns = S2;
        end
        S3: begin
            ns = S4;
        end
        S4:begin
            ns = S5;
        end
        S5: begin
            if()
        end
      default:begin
        ns = IDLE;
      end
    endcase
  end



  always@(posedge clk or negedge rst_n) begin
    case(ns)
      IDLE: begin
            eop  <= 1'b0;
      end
      S1:  begin
            eop  <= 1'b0    ;
            reg_sel <=  pcdata_rs0 ;    
            reg_rd <= 1'b1  ; //decoder reg == rs0
            opradata_rs0 <= data_bus  ; 
      end
      S2:  begin
            eop  <= 1'b0    ;
            reg_sel <=  pcdata_rs1 ;    
            reg_rd <= 1'b1  ; //decoder reg == rs0
            opradata_rs1 <= data_bus  ;                 
      end
      S3:begin
        reg_rd  <= 1'b0;
        reg_sel <=      ;   
        case(opcode)   //opcode to add/mul/sub/
        'h1:   data_out <= opradata_rs0 * opradata_rs1 ;
        'h2:   data_out <= opradata_rs0 + opradata_rs1 ;
        'h4:   data_out <= opradata_rs0 - opradata_rs1 ;      
        endcase
      end
     S4:  begin
        reg_wt [4:0] <= pcdata_rd ;  
        dout_rdy  <= 1'b1   ;
        eop <= 1'b1;
     end
     S5: begin
        eop <= eop;
        dout_rdy <= dout_rdy;
        data_out <= data_out ;
     end
      default:begin

      end



      



endmodule



      
      

  


























  
