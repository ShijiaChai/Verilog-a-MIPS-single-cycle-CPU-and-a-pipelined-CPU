module watchmaker(clk,new_clk);

output reg new_clk = 0;
input clk;

parameter RATIO =  2,
          HALF_RATIO = RATIO / 2;

integer counter = 1;

always @(posedge clk) begin
    if (counter >=HALF_RATIO) 
    begin
    	counter <= 1;
 	new_clk <= ~new_clk;
    end 
    else begin
        counter <= counter + 1;
    end
end
endmodule