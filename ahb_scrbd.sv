class ahb_scrbd extends uvm_scoreboard;
  `uvm_component_utils(ahb_scrbd)
  
  ahb_sequence_item ahb_seq_itm_h;
  
  ahb_sequence_item H_seq_itm[$];
  bit [31:0] mem[*];
  
  uvm_analysis_imp#(ahb_sequence_item,ahb_scrbd)item_collected_export;
  
  
  
  //constructor
  function new (string name = "ahb_scrbd", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export=new("item_collected_export",this);
  endfunction
  
  
  virtual function void write(ahb_sequence_item item);
    H_seq_itm.push_back(item);
  endfunction
  
  //run_phase
  
  virtual task run_phase(uvm_phase phase);
   
    forever begin
      wait(H_seq_itm.size() > 0);
     ahb_seq_itm_h = H_seq_itm.pop_front();
      
      if(ahb_seq_itm_h.HWRITE==1) begin
        mem[ahb_seq_itm_h.HADDR] =ahb_seq_itm_h.HWDATA;
        `uvm_info(get_type_name(),$sformatf("------ :: WRITE DATA MATCH    :: ------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("HADDR: %0h",ahb_seq_itm_h.HADDR),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("HWDATA: %0h",ahb_seq_itm_h.HWDATA),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------\n",UVM_LOW)        
      end
      else if(ahb_seq_itm_h.HWRITE==0) begin
        if(mem[ahb_seq_itm_h.HADDR] ==ahb_seq_itm_h.HRDATA) begin
          `uvm_info(get_type_name(),$sformatf("------ :: READ DATA MATCH :: ------"),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("HADDR: %0h",ahb_seq_itm_h.HADDR),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Expected Data: %h Actual Data: %0h",mem[ahb_seq_itm_h.HADDR],ahb_seq_itm_h.HRDATA),UVM_LOW)
          `uvm_info(get_type_name(),"------------------------------------\n",UVM_LOW)
        end
        else begin
          `uvm_error(get_type_name(),"------ :: READ DATA MISMATCH :: ------")
          `uvm_info(get_type_name(),$sformatf("HADDR: %0h",ahb_seq_itm_h.HADDR),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",mem[ahb_seq_itm_h.HADDR],ahb_seq_itm_h.HRDATA),UVM_LOW)
          `uvm_info(get_type_name(),"------------------------------------\n",UVM_LOW)
        end
      end
    end
  endtask 
  
  
 //report_phase 
 function void report_phase(uvm_phase phase);
			super.report_phase(phase);

    `uvm_info(get_full_name(),$sformatf(" \n\------------------------------------------------------\n\tAHB_SCOREBOARD\tREPORT\n------------------------------------------------------\n\tHADDR\t \t %0h,\n\tHWDATA\t \t %0h,\n\tHRDATA \t\t%0h,\n\------------------------------------------------------",ahb_seq_itm_h.HADDR,ahb_seq_itm_h.HWDATA,ahb_seq_itm_h.HRDATA ),UVM_MEDIUM)
  endfunction:report_phase
        
    
  
endclass:ahb_scrbd