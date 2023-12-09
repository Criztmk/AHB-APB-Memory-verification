class apb_sequence_item extends uvm_sequence_item;
  `uvm_object_utils(apb_sequence_item)
  
  bit PSEL;
  bit PENABLE;
  bit PWRITE;
  bit [2:0]PPROT;
  bit [3:0]PSTRB;
  bit APBACTIVE;
  bit PSLVERR;
  
  rand bit [15:0]PADDR;
  rand bit [31:0]PWDATA;
  rand bit PREADY;
 rand bit PCLKEN;
  
  logic [31:0]PRDATA;
  
  
  
  function new(string name = "apb_sequence_item" );
    super.new(name);
  endfunction
  
endclass:apb_sequence_item