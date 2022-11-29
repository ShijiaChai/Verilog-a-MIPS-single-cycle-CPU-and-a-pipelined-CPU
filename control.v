module Control(Instruct,IRQ,PC31,irq_valid,PCSrc,RegDst,RegWr,ALUSrc1,ALUSrc2,ALUFun,Sign,MemWr,MemRd,MemToReg,EXTOp,LUOp,undefine);
  output reg [2:0]PCSrc;
  output reg [1:0]RegDst;
  output reg RegWr;
  output [1:0]ALUSrc1;
  output reg [1:0]ALUSrc2;
  output reg [5:0]ALUFun;
  output reg Sign;
  output reg MemWr;
  output reg MemRd;
  output reg [1:0]MemToReg;
  output reg EXTOp;
  output reg LUOp;
  output irq_valid;
  output undefine;
  input [31:0]Instruct;
  input IRQ;
  input PC31;
  wire undef;
  wire [5:0]Opcode;
  assign Opcode=Instruct[31:26];
  assign undef=((Opcode>=6'h0&&Opcode<=6'hc)||Opcode==6'hf||Opcode==6'h23||Opcode==6'h2b)?0:1;
  assign irq_valid=IRQ&&(!PC31);
  assign undefine=PC31?0:undef;
  
  always @(*)
  if(irq_valid) PCSrc=3'd4;
  else if(undefine) PCSrc=3'd5;
  else if(Opcode==6'h1||Opcode>=6'h4&&Opcode<=6'h7)
    PCSrc=3'd1;
  else if(Opcode==6'h2||Opcode==6'h3)
    PCSrc=3'd2;
  else if(Opcode==6'h0&&(Instruct[5:0]==6'h8||Instruct[5:0]==6'h9))
    PCSrc=3'd3;
  else PCSrc=3'd0;
    
  always @(*)
  if(irq_valid||undefine) RegWr=1;
  else case(Opcode)
    6'h2b: RegWr=0;
    6'h04: RegWr=0;
    6'h05: RegWr=0;
    6'h06: RegWr=0;
    6'h07: RegWr=0;
    6'h01: RegWr=0;
    6'h02: RegWr=0;
    default:
    if(Opcode==6'h0&&Instruct[5:0]==6'h8)
      RegWr=0;
    else RegWr=1;
    endcase

always @(*)
if(Opcode==6'h3||(Opcode==6'h0&&Instruct[5:0]==6'h9))
  RegDst=2'b10;
else if(Opcode==6'h0)
  RegDst=2'b00;
else if(irq_valid||undefine)
  RegDst=2'b11;
else RegDst=2'b01;
  
always @(*)
if(Opcode==6'h23) MemRd=1;
else MemRd=0;
  
always @(*)
if(irq_valid) MemWr=0;
else 
 case(Opcode)
  6'h2b: MemWr=1;
  default: MemWr=0;
 endcase
  
always @(*)
if(irq_valid||undefine) MemToReg=2'b10;
else
  case(Opcode)
    6'h23: MemToReg=2'b01;
    6'h03: MemToReg=2'b10;
    default:
    if(Opcode==6'h0&&Instruct[5:0]==6'h9)
      MemToReg=2'b10;
    else MemToReg=2'b00;
  endcase

always @(*)
if(Opcode==6'h0c||Opcode==6'h0b)
  EXTOp=0;
else EXTOp=1;
  
always @(*)
if(Opcode==6'h0f) LUOp=1;
else LUOp=0;

assign ALUSrc1=(Opcode==6'h0&&(Instruct[5:0]==6'h0||Instruct[5:0]==6'h2||Instruct[5:0]==6'h3))?1:0;

always @(*)
case(Opcode)
  6'h23: ALUSrc2=1;
  6'h2b: ALUSrc2=1;
  6'h0f: ALUSrc2=1;
  6'h08: ALUSrc2=1;
  6'h09: ALUSrc2=1;
  6'h0c: ALUSrc2=1;
  6'h0a: ALUSrc2=1;
  6'h0b: ALUSrc2=1;
  default: ALUSrc2=0;
endcase

always @(*)
if(Opcode==6'hf||Opcode==6'hc||Opcode==6'hb)
  Sign=0;
else if(Opcode==6'h0)
  case(Instruct[5:0])
    6'h24: Sign=0;
    6'h25: Sign=0;
    6'h26: Sign=0;
    6'h27: Sign=0;
    6'h2b: Sign=0;
    default: Sign=1;
  endcase
else Sign=1;
  
always @(*)
if(Opcode==6'h0)
  case(Instruct[5:0])
    6'h20: ALUFun=6'b000000;
    6'h21: ALUFun=6'b000000;
    6'h22: ALUFun=6'b000001;
    6'h23: ALUFun=6'b000001;
    6'h24: ALUFun=6'b011000;
    6'h25: ALUFun=6'b011110;
    6'h26: ALUFun=6'b010110;
    6'h27: ALUFun=6'b010001;
    6'h00: ALUFun=6'b100000;
    6'h02: ALUFun=6'b100001;
    6'h03: ALUFun=6'b100011;
    6'h2a: ALUFun=6'b110101;
    6'h2b: ALUFun=6'b110101;
    default: ALUFun=6'b0;
  endcase
else
  case(Opcode)
    6'h23: ALUFun=6'b000000;
    6'h2b: ALUFun=6'b000000;
    6'h0f: ALUFun=6'b000000;
    6'h08: ALUFun=6'b000000;
    6'h09: ALUFun=6'b000000;
    6'h0c: ALUFun=6'b011000;
    6'h0a: ALUFun=6'b110101;
    6'h0b: ALUFun=6'b110101;
    6'h04: ALUFun=6'b110011;
    6'h05: ALUFun=6'b110001;
    6'h06: ALUFun=6'b111101;
    6'h07: ALUFun=6'b111111;
    6'h01: ALUFun=6'b111011;
    default: ALUFun=6'b0;
  endcase
  
endmodule

