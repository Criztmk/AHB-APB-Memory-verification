class ahb_agent extends uvm_agent;
  `uvm_component_utils(ahb_agent)
 
  //creating handles for AHB_Sequencer, driver, monitor
  ahb_monitor	ahb_mon_h;
  ahb_driver	ahb_drvr_h;
  ahb_sequencer ahb_seqcr_h;
  H_base_sequence H_seq_h;
  ahb_sequence_item ahb_seq_itm_h;
  
   //AHB agent config handle
  ahb_agent_config H_cnfg_h;
  
//analysis port for data broadcast
  uvm_analysis_port #(ahb_sequence_item)H_mon_ap;
  
  //interface
  virtual ahb_intf vintf_h;
  
  //methods
  extern function new (string name = "ahb_agent",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
      extern function void connect_phase(uvm_phase phase);
        extern function void end_of_elaboration_phase(uvm_phase phase);
          
    endclass:ahb_agent
                 
          
 //constructor
 function ahb_agent::new (string name ="ahb_agent",uvm_component parent);
  super.new(name,parent);
   H_mon_ap=new("H_mon_ap",this);
  endfunction:new
          
          //build_phase
          
          function void ahb_agent::build_phase(uvm_phase phase);
            
             super.build_phase(phase);
            
            if(!uvm_config_db#(ahb_agent_config)::get(this,"*","ahb_agent_config",H_cnfg_h))
       `uvm_fatal("agent_config","No handle of virtual interface received in AHB_AGENT")
              ahb_mon_h = ahb_monitor::type_id::create("ahb_mon_h",this); 
              
              if(H_cnfg_h.is_active==UVM_ACTIVE)
            begin
            ahb_seqcr_h = ahb_sequencer::type_id::create("ahb_seqcr_h",this);
            ahb_drvr_h = ahb_driver::type_id::create("ahb_drvr_h",this);
            H_seq_h = H_base_sequence::type_id::create("H_seq_h",this); 
           ahb_seq_itm_h = ahb_sequence_item::type_id::create("ahb_seq_itm_h",this);
            
            end
           
          endfunction:build_phase
          
          //connect phase
          function void ahb_agent::connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            if(H_cnfg_h.is_active==UVM_ACTIVE)
            begin
            ahb_drvr_h.seq_item_port.connect(ahb_seqcr_h.seq_item_export);
            ahb_mon_h.H_mon_ap.connect(H_mon_ap);
            end
          endfunction:connect_phase
          
          //end_of_elaboration phase
          function void ahb_agent::end_of_elaboration_phase(uvm_phase phase);
            `uvm_info("AHB_AGENT",{get_full_name(),"####created ####"},UVM_HIGH);
          
          endfunction:end_of_elaboration_phase
          
            
          
 
          
      
    
  
  