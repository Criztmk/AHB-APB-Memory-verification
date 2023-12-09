class apb_agent_config extends uvm_object;
  `uvm_object_utils(apb_agent_config)
  
  virtual apb_intf vintf_h;
  uvm_active_passive_enum is_active=UVM_ACTIVE;
  
  //constructor
  
  function new (string name = "apb_agent_config");
    super.new(name);
  endfunction:new
  
  endclass:apb_agent_config