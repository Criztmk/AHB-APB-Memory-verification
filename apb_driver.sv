class apb_driver extends uvm_driver#(apb_sequence_item);
  `uvm_component_utils(apb_driver)
  
  //agent configuration object
  apb_agent_config P_cnfg_h;
  
  //virtual interface handle
  virtual apb_intf vintf_h;
  
  //apb sequence_item handle
  apb_sequence_item apb_seq_itm_h;
  
  //------------------------------------------//
  //-----------------methods------------------//
  //------------------------------------------//
  extern function new (string name = "apb_driver",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
      extern function void connect_phase(uvm_phase phase);
        extern function void end_of_elaboration_phase(uvm_phase phase);
          extern task run_phase(uvm_phase phase);
          extern task drive_item_to_dut(apb_sequence_item apb_seq_itm_h);  
              
endclass: apb_driver
              
//constructor
              
function apb_driver::new (string name="apb_driver",uvm_component parent); 
super.new(name, parent);
endfunction:new
              
//build_phase
function void apb_driver::build_phase(uvm_phase phase);
  
  //get configuration object from APB Agent
  if(!uvm_config_db#(apb_agent_config)::get(this,"","apb_agent_config",P_cnfg_h))
    `uvm_fatal(get_full_name(),"No handle of virtual interface received in APB Driver")
    
  super.build_phase(phase);
  
endfunction:build_phase
              
//connect phase
function void apb_driver::connect_phase (uvm_phase phase);
  super.connect_phase(phase);
	vintf_h=P_cnfg_h.vintf_h;
endfunction:connect_phase
             
 //end of elaboration phase
 function void apb_driver::end_of_elaboration_phase (uvm_phase phase);
   `uvm_info("APB_DRIVER",{get_full_name(),"####created####"},UVM_MEDIUM);
   
 endfunction:end_of_elaboration_phase
            //run_phase
            task apb_driver::run_phase(uvm_phase phase);
              vintf_h.Pdrv_cb.PCLKEN <=1;
               vintf_h.Pdrv_cb.PSLVERR <=0;
              forever
     begin
       `uvm_info("APB_DRIVER","::::::Driving sequence:::::::",UVM_MEDIUM);
       seq_item_port.get_next_item(req);
       drive_item_to_dut(req);     
       seq_item_port.item_done();
     end
            endtask:run_phase
              
task apb_driver::drive_item_to_dut(apb_sequence_item apb_seq_itm_h); 
  begin
  @(vintf_h.PDRV_MP.Pdrv_cb);
    vintf_h.PDRV_MP.Pdrv_cb.PREADY<= apb_seq_itm_h.PREADY;
    vintf_h.PDRV_MP.Pdrv_cb.PRDATA <= apb_seq_itm_h.PRDATA;
  vintf_h.PDRV_MP.Pdrv_cb.PSLVERR <= apb_seq_itm_h.PSLVERR;
   
   
  end
endtask:drive_item_to_dut