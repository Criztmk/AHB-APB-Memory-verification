interface apb_intf(input bit PCLK);
  parameter int addr_width = 16,
  				data_width = 32;
  
  //APB SIGNALS
  logic			PCLKEN;
  logic 		PSEL;
  logic 		PENABLE;
  logic 		PWRITE;
  logic         PSLVERR;
  logic			APBACTIVE;
  logic			PREADY;
  logic	   [3:0]PSTRB;
  logic    [2:0]PPROT;
  logic [addr_width-1:0]PADDR;
  logic [data_width-1:0]PWDATA;
  logic [data_width-1:0]PRDATA;
  
  //APB Driver clocking block
  clocking Pdrv_cb@(posedge PCLK);
    input PSEL;
    input PENABLE;
    input PWRITE;
    input APBACTIVE;
    input PSTRB;
    input PPROT;
    input PADDR;
    input PWDATA;
    
    output PCLKEN;
    output PREADY;
    output PRDATA;
    output PSLVERR;
    
  endclocking:Pdrv_cb
  
  
  //APB MONITOR clocking block
  clocking Pmon_cb@(posedge PCLK);
    input PCLKEN;
    input PREADY;
    input PRDATA;
    input PSLVERR;
    input PSEL;
    input PENABLE;
    input PWRITE;
    input APBACTIVE;
    input PSTRB;
    input PPROT;
    input PADDR;
    input PWDATA;
    
  endclocking:Pmon_cb

  //Declaration of modports
  modport PDRV_MP (clocking Pdrv_cb);//APB Driver modport
  modport PMON_MP (clocking Pmon_cb);//APB monitor modport
  //APB ASSERTIONS

sequence write;
(PWRITE == 1);
endsequence

sequence read;
(PWRITE == 0);
endsequence

sequence fsm_transition;
((!PSEL && !PENABLE) ##1 (PSEL && !PENABLE)) ##1 ((PSEL && PENABLE) ##1 (!PSEL && !PENABLE));
endsequence

sequence setup_state;
$rose(PSEL) and $rose(PWRITE) and (!PENABLE) and (!PREADY);
endsequence

sequence access_state;
$rose (PENABLE) and $rose(PREADY) and $stable (PSEL) and $stable (PWRITE) and $stable (PWDATA) and $stable (PADDR);
endsequence

property select;
        @(posedge PCLK) ((PENABLE) |-> $stable(PSEL));
      endproperty
      c1:assert property(select);
        
        property read_signal;
          @(posedge PCLK)  ((PSEL && !PENABLE) |-> PREADY);
          endproperty
        c2:assert property(read_signal);

    
endinterface : apb_intf
    
    
  