module ROM (addr,data);
input [30:0] addr;
output [31:0] data;
localparam ROM_SIZE = 256;
(* rom_style = "distributed" *) reg [31:0] ROMDATA[ROM_SIZE-1:0];
assign data=(addr[30:2] < ROM_SIZE)?ROMDATA[addr[30:2]]:32'b0;
integer i;
initial begin   
    ROMDATA[0]<=32'h08000003;
    ROMDATA[1]<=32'h08000070;
    ROMDATA[2]<=32'h0800009a;
    ROMDATA[3]<=32'h3c044000;
    ROMDATA[4]<=32'h20090001;
    ROMDATA[5]<=32'h200a0002;
    ROMDATA[6]<=32'h200e0003;
    ROMDATA[7]<=32'h00005820;
    ROMDATA[8]<=32'h00009820;
    ROMDATA[9]<=32'h20160000;
    ROMDATA[10]<=32'h8c880020;
    ROMDATA[11]<=32'h31080008;
    ROMDATA[12]<=32'h1100fffd;
    ROMDATA[13]<=32'h12c00002;
    ROMDATA[14]<=32'h8c91001c;
    ROMDATA[15]<=32'h08000013;
    ROMDATA[16]<=32'h8c90001c;
    ROMDATA[17]<=32'h20160001;
    ROMDATA[18]<=32'h0800000a;
    ROMDATA[19]<=32'hac800008;
    ROMDATA[20]<=32'h2008d8f0;
    ROMDATA[21]<=32'hac880000;
    ROMDATA[22]<=32'h2008ffff;
    ROMDATA[23]<=32'hac880004;
    ROMDATA[24]<=32'hac8e0008;
    ROMDATA[25]<=32'h0010a020;
    ROMDATA[26]<=32'h0011a820;
    ROMDATA[27]<=32'h0211902a;
    ROMDATA[28]<=32'h12400003;
    ROMDATA[29]<=32'h02009020;
    ROMDATA[30]<=32'h02208020;
    ROMDATA[31]<=32'h02408820;
    ROMDATA[32]<=32'h1220000a;
    ROMDATA[33]<=32'h1229000b;
    ROMDATA[34]<=32'h02119022;
    ROMDATA[35]<=32'h1240000b;
    ROMDATA[36]<=32'h0251602a;
    ROMDATA[37]<=32'h11890002;
    ROMDATA[38]<=32'h02118022;
    ROMDATA[39]<=32'h08000022;
    ROMDATA[40]<=32'h02208020;
    ROMDATA[41]<=32'h02408820;
    ROMDATA[42]<=32'h08000022;
    ROMDATA[43]<=32'h00101020;
    ROMDATA[44]<=32'h0800009b;
    ROMDATA[45]<=32'h20020001;
    ROMDATA[46]<=32'h0800009b;
    ROMDATA[47]<=32'h00111020;
    ROMDATA[48]<=32'h0800009b;
    ROMDATA[49]<=32'h20a6fff1;
    ROMDATA[50]<=32'h10c0001d;
    ROMDATA[51]<=32'h20a6fff2;
    ROMDATA[52]<=32'h10c0001d;
    ROMDATA[53]<=32'h20a6fff3;
    ROMDATA[54]<=32'h10c0001d;
    ROMDATA[55]<=32'h20a6fff4;
    ROMDATA[56]<=32'h10c0001d;
    ROMDATA[57]<=32'h20a6fff5;
    ROMDATA[58]<=32'h10c0001d;
    ROMDATA[59]<=32'h20a6fff6;
    ROMDATA[60]<=32'h10c0001d;
    ROMDATA[61]<=32'h20a6fff7;
    ROMDATA[62]<=32'h10c0001d;
    ROMDATA[63]<=32'h20a6fff8;
    ROMDATA[64]<=32'h10c0001d;
    ROMDATA[65]<=32'h20a6fff9;
    ROMDATA[66]<=32'h10c0001d;
    ROMDATA[67]<=32'h20a6fffa;
    ROMDATA[68]<=32'h10c0001d;
    ROMDATA[69]<=32'h20a6fffb;
    ROMDATA[70]<=32'h10c0001d;
    ROMDATA[71]<=32'h20a6fffc;
    ROMDATA[72]<=32'h10c0001d;
    ROMDATA[73]<=32'h20a6fffd;
    ROMDATA[74]<=32'h10c0001d;
    ROMDATA[75]<=32'h20a6fffe;
    ROMDATA[76]<=32'h10c0001d;
    ROMDATA[77]<=32'h20a6ffff;
    ROMDATA[78]<=32'h10c0001d;
    ROMDATA[79]<=32'h10a0001e;
    ROMDATA[80]<=32'h2007000e;
    ROMDATA[81]<=32'h03e00008;
    ROMDATA[82]<=32'h20070006;
    ROMDATA[83]<=32'h03e00008;
    ROMDATA[84]<=32'h20070021;
    ROMDATA[85]<=32'h03e00008;
    ROMDATA[86]<=32'h20070046;
    ROMDATA[87]<=32'h03e00008;
    ROMDATA[88]<=32'h20070003;
    ROMDATA[89]<=32'h03e00008;
    ROMDATA[90]<=32'h20070008;
    ROMDATA[91]<=32'h03e00008;
    ROMDATA[92]<=32'h20070010;
    ROMDATA[93]<=32'h03e00008;
    ROMDATA[94]<=32'h20070000;
    ROMDATA[95]<=32'h03e00008;
    ROMDATA[96]<=32'h20070078;
    ROMDATA[97]<=32'h03e00008;
    ROMDATA[98]<=32'h20070002;
    ROMDATA[99]<=32'h03e00008;
    ROMDATA[100]<=32'h20070012;
    ROMDATA[101]<=32'h03e00008;
    ROMDATA[102]<=32'h20070019;
    ROMDATA[103]<=32'h03e00008;
    ROMDATA[104]<=32'h20070030;
    ROMDATA[105]<=32'h03e00008;
    ROMDATA[106]<=32'h20070024;
    ROMDATA[107]<=32'h03e00008;
    ROMDATA[108]<=32'h20070079;
    ROMDATA[109]<=32'h03e00008;
    ROMDATA[110]<=32'h20070040;
    ROMDATA[111]<=32'h03e00008;
    ROMDATA[112]<=32'h8c980008;
    ROMDATA[113]<=32'h200ffff9;
    ROMDATA[114]<=32'h030fc024;
    ROMDATA[115]<=32'hac980008;
    ROMDATA[116]<=32'h23bdfff8;
    ROMDATA[117]<=32'hafbf0000;
    ROMDATA[118]<=32'hafa80004;
    ROMDATA[119]<=32'h1260000e;
    ROMDATA[120]<=32'h12690012;
    ROMDATA[121]<=32'h126a0016;
    ROMDATA[122]<=32'h126e001a;
    ROMDATA[123]<=32'h8fbf0000;
    ROMDATA[124]<=32'h8fa80004;
    ROMDATA[125]<=32'h23bd0008;
    ROMDATA[126]<=32'hac870014;
    ROMDATA[127]<=32'h8c980008;
    ROMDATA[128]<=32'h030ec025;
    ROMDATA[129]<=32'hac980008;
    ROMDATA[130]<=32'h166e0001;
    ROMDATA[131]<=32'h2013ffff;
    ROMDATA[132]<=32'h22730001;
    ROMDATA[133]<=32'h03400008;
    ROMDATA[134]<=32'h00142e00;
    ROMDATA[135]<=32'h00052f02;
    ROMDATA[136]<=32'h0c000031;
    ROMDATA[137]<=32'h20e70780;
    ROMDATA[138]<=32'h0800007b;
    ROMDATA[139]<=32'h00142f00;
    ROMDATA[140]<=32'h00052f02;
    ROMDATA[141]<=32'h0c000031;
    ROMDATA[142]<=32'h20e70b80;
    ROMDATA[143]<=32'h0800007b;
    ROMDATA[144]<=32'h00152e00;
    ROMDATA[145]<=32'h00052f02;
    ROMDATA[146]<=32'h0c000031;
    ROMDATA[147]<=32'h20e70d80;
    ROMDATA[148]<=32'h0800007b;
    ROMDATA[149]<=32'h00152f00;
    ROMDATA[150]<=32'h00052f02;
    ROMDATA[151]<=32'h0c000031;
    ROMDATA[152]<=32'h20e70e80;
    ROMDATA[153]<=32'h0800007b;
    ROMDATA[154]<=32'h0800009a;
    ROMDATA[155]<=32'hac82000c;
    ROMDATA[156]<=32'hac820018;
    ROMDATA[157]<=32'h08000003;    
	    for (i=158;i<ROM_SIZE;i=i+1) begin
            ROMDATA[i] <= 32'b0;
        end
end
endmodule
