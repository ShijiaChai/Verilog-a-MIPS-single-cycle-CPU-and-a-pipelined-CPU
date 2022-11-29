module Forward(Forward_A,Forward_B,Forward_C,Mem_rd,WB_rd,EX_rs,EX_rt,ID_rs,Mem_RegWr,WB_RegWr,EX_RegWr,EX_rd);
  output reg [1:0]Forward_A;
  output reg [1:0]Forward_B;
  output reg [1:0]Forward_C;
  input [4:0]Mem_rd;
  input [4:0]WB_rd;
  input [4:0]EX_rd;
  input [4:0]EX_rs;
  input [4:0]EX_rt;
  input [4:0]ID_rs;
  input Mem_RegWr;
  input WB_RegWr;
  input EX_RegWr;
  always@(*)
    if(Mem_RegWr&&(Mem_rd!=0)&&(Mem_rd==EX_rs))
      Forward_A=2'd1;
    else if(WB_RegWr&&(WB_rd!=0)&&(WB_rd==EX_rs)&&((Mem_rd!=EX_rs)||!Mem_RegWr))
      Forward_A=2'd2;
    else Forward_A=2'd0;
  always@(*)
    if(Mem_RegWr&&(Mem_rd!=0)&&(Mem_rd==EX_rt))
        Forward_B=2'd1;
    else if(WB_RegWr&&(WB_rd!=0)&&(WB_rd==EX_rt)&&((Mem_rd!=EX_rt)||!Mem_RegWr))
        Forward_B=2'd2;
    else Forward_B=2'd0;
  always@(*)
    if(EX_RegWr&&(EX_rd==ID_rs)&&EX_rd!=0)
        Forward_C=2'd1;
    else if(Mem_RegWr&&(Mem_rd==ID_rs)&&Mem_rd!=0)
        Forward_C=2'd2;
    else Forward_C=2'd0;
 endmodule