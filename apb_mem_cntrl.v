// APB memory design RTL
module apb_mem  #(parameter ADDR_WIDTH=16, DATA_WIDTH=32, RDY_COUNT=1) (
  input  wire        PCLK,     // Clock
  input  wire        PRESETn,  // Reset
  input  wire        PSEL,     // Device select
  input  wire [ADDR_WIDTH-1:0]  PADDR,    // Address
  input  wire        PENABLE,  // Transfer control
  input  wire        PWRITE,   // Write control
  input  wire [DATA_WIDTH-1:0] PWDATA,   // Write data
  output wire [DATA_WIDTH-1:0] PRDATA,   // Read data
  output reg        PREADY );  // Device ready
 // Signals for read/write controls
 wire  read_enable, write_enable;
 reg [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH:0];
 integer rdy_count; 
 // Read and write control signals
 assign  read_enable  = PSEL & (~PWRITE) & & PENABLE & PREADY ; // assert for Read trans
 assign  write_enable = PSEL & (PWRITE) & PENABLE & PREADY;     // assert for write trans
 // memory read
 assign PRDATA[DATA_WIDTH-1:0] = (read_enable)? mem[PADDR] : 'hzzzz_zzzz;    
 // Memory write 
  always @(posedge PCLK)  begin
    if (write_enable)
      mem[PADDR] <= PWDATA[DATA_WIDTH-1:0];
  end
  // ready assertion logic based on parameter
  always @(posedge PCLK, PRESETn) begin 
     if (!PRESETn) begin
	   PREADY <= 1'b0;
	   rdy_count<=0;
	 end else if (rdy_count == RDY_COUNT) begin
	   PREADY <= 1'b1;
	   rdy_count<=0;
	 end else begin  
	   PREADY <= 1'b1;
	   rdy_count<=rdy_count+1;
	 end
  end  
endmodule