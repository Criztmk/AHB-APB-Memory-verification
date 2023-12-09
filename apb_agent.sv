class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)
 
  //creating handles for APB_Sequencer, driver, monitor
  apb_sequencer apb_seqcr_h;
  P_base_sequence P_seq_h;
  apb_driver	apb_drvr_h;
  apb_sequence_item apb_seq_itm_h;
  apb_monitor	apb_mon_h;
  
  
  //apb agent config handle
   apb_agent_config P_cnfg_h;
  
  //analysis port of data broadcast
  uvm_analysis_port #(apb_sequence_item)P_mon_ap;
  
  //interface
  virtual apb_intf vintf_h;
  
  //methods
  extern function new (string name="apb_agent",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
      extern function void connect_phase(uvm_phase phase);
        extern function void end_of_elaboration_phase(uvm_phase phase);
      endclass:apb_agent     
          
 //constructor
          function apb_agent::new (string name ="apb_agent",uvm_component parent);
  super.new(name,parent);
            P_mon_ap = new("P_mon_ap",this);
  endfunction:new
          //build_phase
          
          function void apb_agent::build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(apb_agent_config)::get(this,"*","apb_agent_config",P_cnfg_h))
              `uvm_fatal(get_full_name,"No handle of virtual interface received in APB_AGENT")
           
 			apb_mon_h = apb_monitor::type_id::create("apb_mon_h",this);
            
              if(P_cnfg_h.is_active == UVM_ACTIVE)
              begin
            apb_seq_itm_h = apb_sequence_item::type_id::create("apb_seq_itm_h",this);
                P_seq_h = P_base_sequence::type_id::create("P_seq_h",this);
            apb_seqcr_h = apb_sequencer::type_id::create("apb_seqcr_h",this);
            apb_drvr_h = apb_driver::type_id::create("apb_drvr_h",this);
           
              end
            
          endfunction:build_phase
          
          //connect phase
          function void apb_agent::connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            if(P_cnfg_h.is_active==UVM_ACTIVE)
            begin
            apb_drvr_h.seq_item_port.connect(apb_seqcr_h.seq_item_export);
            apb_mon_h.P_mon_ap.connect(P_mon_ap);
            end
          endfunction:connect_phase
          
          //end_of_elaboration phase
          function void apb_agent::end_of_elaboration_phase(uvm_phase phase);
            `uvm_info("APB_AGENT",{get_full_name(),"####created####"},UVM_HIGH);
          
          endfunction:end_of_elaboration_phase
          
            
          
 
          
          
      
    
  
  