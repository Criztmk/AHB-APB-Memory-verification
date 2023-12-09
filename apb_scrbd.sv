class apb_scrbd extends uvm_scoreboard;
  `uvm_component_utils(apb_scrbd)
  
  apb_sequence_item apb_seq_itm_h;
  apb_sequence_item P_seq_itm[$];
  bit [31:0] mem[*];
  uvm_analysis_imp#(apb_sequence_item,apb_scrbd)item_collected_export;
  
  function new (string name = "apb_scrbd", uvm_component parent);
    super.new(name, parent);
     item_collected_export=new("item_collected_export",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  virtual function void write(apb_sequence_item item);
    P_seq_itm.push_back(item);
  endfunction
  
   virtual task run_phase(uvm_phase phase);
   
    forever begin
      wait(P_seq_itm.size() > 0);
     apb_seq_itm_h = P_seq_itm.pop_front();
      
      if(apb_seq_itm_h.PWRITE==1) begin
        mem[apb_seq_itm_h.PADDR] =apb_seq_itm_h.PWDATA;
        `uvm_info(get_type_name(),$sformatf("------ :: WRITE DATA MATCH    :: ------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("PADDR: %0h",apb_seq_itm_h.PADDR),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("PWDATA: %0h",apb_seq_itm_h.PWDATA),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------\n",UVM_LOW)        
      end
      else if(apb_seq_itm_h.PWRITE==0) begin
        if(mem[apb_seq_itm_h.PADDR] ==apb_seq_itm_h.PRDATA) begin
          `uvm_info(get_type_name(),$sformatf("------ :: READ DATA MATCH :: ------"),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("PADDR: %0h",apb_seq_itm_h.PADDR),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Expected Data: %h Actual Data: %0h",mem[apb_seq_itm_h.PADDR],apb_seq_itm_h.PRDATA),UVM_LOW)
          `uvm_info(get_type_name(),"------------------------------------\n",UVM_LOW)
        end
        else begin
          `uvm_error(get_type_name(),"------ :: READ DATA MISMATCH :: ------")
          `uvm_info(get_type_name(),$sformatf("PADDR: %0h",apb_seq_itm_h.PADDR),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",mem[apb_seq_itm_h.PADDR],apb_seq_itm_h.PRDATA),UVM_LOW)
          `uvm_info(get_type_name(),"------------------------------------\n",UVM_LOW)
        end
      end
    end
  endtask 
  
  
  
  
  
   function void report_phase(uvm_phase phase);
			super.report_phase(phase);

    `uvm_info(get_full_name(),$sformatf(" \n\------------------------------------------------------\n\tAPB_SCOREBOARD\tREPORT\n------------------------------------------------------\n \n\tPADDR\t \t %0h,\n\tPWDATA\t \t %0h,\n\tPRDATA \t\t%0h,\n\------------------------------------------------------",apb_seq_itm_h.PADDR,apb_seq_itm_h.PWDATA,apb_seq_itm_h.PRDATA ),UVM_MEDIUM)
  endfunction:report_phase
        
    
  
endclass:apb_scrbd