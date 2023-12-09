class environment extends uvm_env;
  `uvm_component_utils(environment)
  
  //configuration handle properties
  env_config config_h;
  ahb_agent_config H_cnfg_h;
  apb_agent_config P_cnfg_h;
  
  ahb_sequencer ahb_seqcr_h;
  apb_sequencer apb_seqcr_h;
 
  //Handle for AHB & APB Agents
  ahb_agent H_agent_h;
  apb_agent P_agent_h;
  
  //coverage handle
ahb_coverage H_cov_h;

  
  //Handle for scoreboard 
  ahb_scrbd H_scrbd_h;
  apb_scrbd P_scrbd_h;
  scoreboard scrb_h;
  
 
  //------------methods-----------------//
 
  extern function new (string name = "environment",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
    
endclass : environment
    
    //constructor
    function environment:: new (string name="environment",uvm_component parent);
  super.new(name, parent);
endfunction:new

    //build phase
function void environment::build_phase(uvm_phase phase);
  
  super.build_phase(phase);
  
  //get configuration object from Database
  if(!uvm_config_db#(env_config)::get(this,"","env_config",config_h))
    `uvm_fatal(get_full_name(),"cannot get configuration object from Database")
    
    
 H_cnfg_h = ahb_agent_config::type_id::create("H_cnfg_h",this);
 P_cnfg_h = apb_agent_config::type_id::create("P_cnfg_h",this);
  
 H_agent_h = ahb_agent::type_id::create("H_agent_h",this);
 P_agent_h = apb_agent::type_id::create("P_agent_h",this);

 H_cov_h   = ahb_coverage::type_id::create("H_cov_h",this);
  
 H_scrbd_h = ahb_scrbd::type_id::create("H_scrbd_h",this);
 P_scrbd_h = apb_scrbd::type_id::create("P_scrbd_h",this); 

 scrb_h = scoreboard::type_id::create("scrb_h",this);

  uvm_config_db#(ahb_agent_config)::set(this, "*", "ahb_agent_config",config_h.H_cnfg_h);
  uvm_config_db#(apb_agent_config)::set(this, "*", "apb_agent_config",config_h.P_cnfg_h);
  
endfunction:build_phase
              
//connect phase
function void environment::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  
  //connect AHB Analysis port to AHB scoreboard to item collected export
  H_agent_h.ahb_mon_h.H_mon_ap.connect(H_scrbd_h.item_collected_export);
  //connect APB Analysis port to APB scoreboard to item collected export
  P_agent_h.apb_mon_h.P_mon_ap.connect(P_scrbd_h.item_collected_export);
 
  
    //connect AHB Analysis port to scoreboard to FIFO Analysis port
    H_agent_h.ahb_mon_h.H_mon_ap.connect(scrb_h.fifo_ahb.analysis_export);
    //connect APB Analysis port to scoreboard to FIFO Analysis port
    P_agent_h.apb_mon_h.P_mon_ap.connect(scrb_h.fifo_apb.analysis_export);
 
	
endfunction:connect_phase
              
 //end of elaboration phase
 function void environment::end_of_elaboration_phase(uvm_phase phase);
   `uvm_info("Environment",{get_full_name(),"####created####"},UVM_MEDIUM);
   uvm_top.print_topology();
endfunction:end_of_elaboration_phase
     
    
    
  
  
  