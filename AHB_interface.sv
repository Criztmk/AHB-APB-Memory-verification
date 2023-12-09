interface ahb_intf(input bit HCLK);
  
  parameter int addr_width = 16,
  				data_width = 32;
  
  
//AHB SIGNALS
  logic 	  HRESETn;
  logic		  HSEL;
  logic		  HWRITE;
  logic 	  HRESP;
  logic		  HREADY;
  logic 	  HREADYOUT;
  logic [1:0] HTRANS;
  logic [2:0] HSIZE;
  logic [3:0] HPROT;
  logic [addr_width-1:0]HADDR;
  logic [data_width-1:0]HWDATA;
  logic [data_width-1:0]HRDATA;
 
  
//AHB Driver clocking block
  
  clocking Hdrv_cb@(posedge HCLK);
    input HRDATA;
    input HRESP;
    input HREADYOUT;
    
    output HRESETn;
    output HTRANS;
    output HSEL;
    output HWRITE;
    output HWDATA;
    output HREADY;
    output HSIZE;
    output HPROT;
    output HADDR;
  endclocking:Hdrv_cb
  
  
  //AHB Monitor clocking block
  clocking Hmon_cb@(posedge HCLK);
    input HRDATA;
    input HRESP;
    input HREADYOUT;
    input HRESETn;
    input HTRANS;
    input HSEL;
    input HWRITE;
    input HWDATA;
    input HREADY;
    input HSIZE;
    input HPROT;
    input HADDR;
    endclocking:Hmon_cb
  
  
  //Declaration of modports
  
  modport HDRV_MP (clocking Hdrv_cb); //AHB Driver modport
  modport HMON_MP (clocking Hmon_cb);//AHB Monitor modport
  
endinterface 