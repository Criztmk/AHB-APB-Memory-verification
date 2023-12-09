class env_config extends uvm_object;
  `uvm_object_utils(env_config)
  
  
  //configuration handles
  ahb_agent_config H_cnfg_h;
  apb_agent_config P_cnfg_h;
  
  
  //constructor
  
  function new (string name ="env_config");
    super.new(name);
  endfunction : new
  
  endclass : env_config