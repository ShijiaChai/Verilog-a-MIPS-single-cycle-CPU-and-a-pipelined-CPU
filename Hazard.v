module Hazard(PC_Hold,IF_Hold,IF_Flush,Control_Flush,
ID_rt,ID_rs,EX_rt,EX_MemRd,PCSrc,EX_PCSrc,ALUout_0,undefine,irq_valid);
  output reg IF_Hold;
  output reg IF_Flush;
  output reg PC_Hold;
  output reg Control_Flush;
  input [2:0] PCSrc;
  input EX_MemRd;
  input [4:0] EX_rt;
  input [4:0] ID_rs;
  input [4:0] ID_rt;
  input [2:0] EX_PCSrc;
  input ALUout_0;
  input undefine;
  input irq_valid;  
  always @(*)
    if(EX_MemRd&&(EX_rt==ID_rs||EX_rt==ID_rt))
      begin
      PC_Hold=1;
      IF_Flush=0;
      IF_Hold=1;
      Control_Flush=1;
      end
    else if(PCSrc==3'd2||PCSrc==3'd3||irq_valid)
    begin
      PC_Hold=0;
      IF_Flush=1;
      IF_Hold=0;
      Control_Flush=0;
    end
    else if((EX_PCSrc==3'd1&&ALUout_0)||undefine)
      begin
          PC_Hold=0;
          IF_Flush=1;
          IF_Hold=0;
          Control_Flush=1;
        end
    else
      begin
        PC_Hold=0;
        IF_Flush=0;
        IF_Hold=0;
        Control_Flush=0;
      end
  
endmodule