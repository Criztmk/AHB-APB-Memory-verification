class ahb_sequence_item extends uvm_sequence_item;
  `uvm_object_utils(ahb_sequence_item)
  
  //typedef enum {IDLE, BUSY, NON_SEQ,SEQ}trans_type;//transfer type
  
  rand bit HRESETn;
  rand bit HREADY;
  
 //AHB control signals
  rand bit 		HSEL;
  rand bit [1:0]HSIZE;
  rand bit [2:0]HTRANS;
  rand bit [3:0]HPROT;
  rand bit	    HWRITE;
  
  rand bit [15:0]HADDR;
  rand bit [31:0]HWDATA;
  
  logic    [31:0]HRDATA;
  
  //AHB outputs
  bit HREADYOUT;
  bit HRESP;
  
  
  
  //size {8 bits 16 bits & 32 bits}
  constraint size_limit { HSIZE inside {0,1,2};}
 
  
  //constructor
  function new(string name = "ahb_sequence_item" );
    super.new(name);
    endfunction :new
                               
  
endclass:ahb_sequence_item