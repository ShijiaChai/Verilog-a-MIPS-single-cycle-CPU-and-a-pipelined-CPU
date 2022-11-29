module IFID_Reg(ID_Instruct,ID_PC,Instruct_in,IF_PC,Hold,clk,reset);
  output reg[31:0]ID_Instruct;
  output reg[31:0]ID_PC;
  input [31:0]Instruct_in;
  input [31:0]IF_PC;
  input Hold;
  input clk;
  input reset;
  
  always @(posedge clk or negedge reset)
  if(!reset)
    begin
      ID_Instruct<=32'b0;
      ID_PC<=32'b0;
    end
  else if(!Hold)
    begin
      ID_Instruct<=Instruct_in;
      ID_PC<=IF_PC;
    end
endmodule

module IDEX_Reg(EX_PC,EX_Imm,BUS_A,BUS_B,EX_rs,EX_rt,EX_rd,EX_Shamt,EX_ALUFun,EX_Sign,EX_ALUSrc1,EX_ALUSrc2,EX_MemWr,EX_MemtoReg,EX_RegWr,EX_MemRd,EX_PCSrc,EX_ConBA,
ID_PC,ID_Imm,REG_A,REG_B,ID_rs,ID_rt,ID_rd,ID_Shamt,ID_ALUFun,ID_Sign,ID_ALUSrc1,ID_ALUSrc2,ID_MemWr,ID_MemtoReg,ID_RegWr,ID_MemRd,PCSrc,ID_ConBA,Control_Flush,undefine,clk,reset);
output reg [31:0]EX_PC;
output reg [31:0]EX_Imm;
output reg [31:0]BUS_A;
output reg [31:0]BUS_B;
output reg [4:0]EX_rs;
output reg [4:0]EX_rt;
output reg [4:0]EX_rd;
output reg [4:0]EX_Shamt;
output reg [5:0]EX_ALUFun;
output reg EX_Sign;
output reg [1:0]EX_ALUSrc1;
output reg [1:0]EX_ALUSrc2;
output reg EX_MemWr;
output reg [1:0]EX_MemtoReg;
output reg EX_RegWr;
output reg EX_MemRd;
output reg [2:0]EX_PCSrc;
output reg [31:0]EX_ConBA;
input [31:0]ID_PC;
input [31:0]ID_Imm;
input [31:0]REG_A;
input [31:0]REG_B;
input [4:0]ID_rs;
input [4:0]ID_rt;
input [4:0]ID_rd;
input [4:0]ID_Shamt;
input [5:0]ID_ALUFun;
input ID_Sign;
input [1:0]ID_ALUSrc1;
input [1:0]ID_ALUSrc2;
input ID_MemWr;
input [1:0]ID_MemtoReg;
input ID_RegWr;
input ID_MemRd;
input [2:0]PCSrc;
input [31:0]ID_ConBA;
input Control_Flush;
input undefine;
input clk;
input reset;

  always @(posedge clk or negedge reset)
  if(!reset)
    begin
      EX_PC<=32'b0;
      EX_Imm<=32'b0;
      BUS_A<=32'b0;
      BUS_B<=32'b0;
      EX_rs<=0;
      EX_rt<=0;
      EX_rd<=0;
      EX_Shamt<=0;
      EX_ALUFun<=0;
      EX_Sign<=0;
      EX_ALUSrc1<=0;
      EX_ALUSrc2<=0;
      EX_MemWr<=0;
      EX_MemtoReg<=0;
      EX_RegWr<=0;
      EX_MemRd<=0;
      EX_PCSrc<=0;
      EX_ConBA<=0;
    end
  else
    begin
      EX_PC<=ID_PC;
      EX_Imm<=ID_Imm;
      BUS_A<=REG_A;
      BUS_B<=REG_B;
      EX_rs<=ID_rs;
      EX_rt<=ID_rt;
      EX_rd<=ID_rd;
      EX_Shamt<=ID_Shamt;
      EX_ALUFun<=ID_ALUFun;
      EX_Sign<=ID_Sign;
      EX_ALUSrc1<=ID_ALUSrc1;
      EX_ALUSrc2<=ID_ALUSrc2;
      EX_MemWr<=(Control_Flush||undefine)?0:ID_MemWr;
      EX_MemtoReg<=ID_MemtoReg;
      EX_RegWr<=Control_Flush?0:ID_RegWr;
      EX_MemRd<=(Control_Flush||undefine)?0:ID_MemRd;
      EX_PCSrc<=(Control_Flush)?0:PCSrc;
      EX_ConBA<=ID_ConBA;
    end
endmodule

module EXMEM_Reg(Mem_PC,MemALU_out,Mem_rd,wr_Data,Mem_MemWr,Mem_MemtoReg,Mem_RegWr,Mem_MemRd,
EX_PC,ALU_out,EX_rd,after_BUS_B,EX_MemWr,EX_MemtoReg,EX_RegWr,EX_MemRd,clk,reset);
  output reg [31:0]Mem_PC;
  output reg [31:0]MemALU_out;
  output reg [4:0]Mem_rd;
  output reg [31:0]wr_Data;
  output reg Mem_MemWr;
  output reg [1:0]Mem_MemtoReg;
  output reg Mem_RegWr;
  output reg Mem_MemRd;
  input [31:0]EX_PC;
  input [31:0]ALU_out;
  input [4:0]EX_rd;
  input [31:0]after_BUS_B;
  input EX_MemWr;
  input [1:0]EX_MemtoReg;
  input EX_RegWr;
  input EX_MemRd;
  input clk;
  input reset;
  
  always @(posedge clk or negedge reset)
  if(!reset)
    begin
      Mem_PC<=0;
      MemALU_out<=0;
      Mem_rd<=0;
      wr_Data<=0;
      Mem_MemWr<=0;
      Mem_MemtoReg<=0;
      Mem_RegWr<=0;
      Mem_MemRd<=0;
    end
  else
    begin
      Mem_PC<=EX_PC;
      MemALU_out<=ALU_out;
      Mem_rd<=EX_rd;
      wr_Data<=after_BUS_B;
      Mem_MemWr<=EX_MemWr;
      Mem_MemtoReg<=EX_MemtoReg;
      Mem_RegWr<=EX_RegWr;
      Mem_MemRd<=EX_MemRd;
    end
endmodule

module MemWB_Reg(WB_PC,Mem_Data,WBALU_out,WB_MemtoReg,WB_RegWr,WB_rd,
Mem_PC,MemALU_out,Mem_out,Mem_MemtoReg,Mem_RegWr,Mem_rd,clk,reset);
 output reg [31:0]WB_PC;
  output reg [31:0]Mem_Data;
  output reg [31:0]WBALU_out;
  output reg [1:0]WB_MemtoReg;
  output reg WB_RegWr;
  output reg [4:0]WB_rd;
  input [31:0]Mem_PC;
  input [31:0]MemALU_out;
  input [31:0]Mem_out;
  input [1:0]Mem_MemtoReg;
  input Mem_RegWr;
  input [4:0]Mem_rd;
  input clk;
  input reset;
  
  always @(posedge clk or negedge reset)
  if(!reset)
    begin
      WB_PC<=0;
      Mem_Data<=0;
      WBALU_out<=0;
      WB_MemtoReg<=0;
      WB_RegWr<=0;
      WB_rd<=0;
    end
  else
    begin
      WB_PC<=Mem_PC;
      Mem_Data<=Mem_out;
      WBALU_out<=MemALU_out;
      WB_MemtoReg<=Mem_MemtoReg;
      WB_RegWr<=Mem_RegWr;
      WB_rd<=Mem_rd;
    end
endmodule