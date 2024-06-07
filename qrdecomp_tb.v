module qrdecomp_tb;

logic [15:0] A;
logic clk,reset, start, done;
logic [15:0] q1out;
logic [15:0] q2out;
logic [15:0] q3out;

initial begin
$fsdbDumpfile("waveform.fsdb");
$fsdbDumpvars();

end

//initial begin
//    clk = 0;
//    forever #25 clk = ~clk;
//end

parameter clk_period=10000;
initial begin
    clk <= 0;
    forever #(clk_period/2)clk <= ~clk;
end

initial begin
  //  reset = 1;
  reset <= 0;
@(negedge clk);
@(negedge clk);
@(negedge clk);
@(negedge clk);
@(negedge clk);
 reset<=1;
  
    A <= 0;
    start<=0;
	@(negedge clk);
@(negedge clk);
@(negedge clk);
@(negedge clk);
@(negedge clk);
@(negedge clk);
@(negedge clk);
@(negedge clk);
@(negedge clk);
@(negedge clk);

   reset = 0;
   start=1;
        @(negedge clk);
	  @(negedge clk);
     A=0;  
@(negedge clk);	  
    A = 2;
	 @(negedge clk);
    A=0; 
@(negedge clk);	 
    A=2;
	 @(negedge clk);
    A=0;
	 @(negedge clk);
    A=0;
	 @(negedge clk);
    A=0;
	 @(negedge clk);
    A=0;
	 @(negedge clk);
    A=2;


   repeat (10000)	  
 @(posedge clk);  
//    @(posedge clk);
    $finish();
end

qr_decomp qr(.*);

initial begin 
$monitor("q1=%h, q2=%h, q3=%h", q1out, q2out, q3out);
end

endmodule
