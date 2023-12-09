class ahb_driver extends uvm_driver#(ahb_sequence_item);
  `uvm_component_utils(ahb_driver)
  
  //agent configuration object
  ahb_agent_config H_cnfg_h;
  
  //virtual interface handle
  virtual ahb_intf vintf_h;
  
  //ahb sequence_item handle
 ahb_sequence_item ahb_seq_itm_h;
  
  
  //-----------------methods------------------//
  
  extern function new (string name = "ahb_driver", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
      extern function void connect_phase(uvm_phase phase);
        extern function void end_of_elaboration_phase(uvm_phase phase);
          extern task run_phase(uvm_phase phase);
            extern task drive_item_to_dut(ahb_sequence_item ahb_seq_itm_h);
              
              
endclass:ahb_driver
              
//constructor
              
function ahb_driver::new (string name = "ahb_driver", uvm_component parent); 
	super.new(name, parent);
endfunction:new
              
//build_phase
function void ahb_driver :: build_phase (uvm_phase phase);
  
  super.build_phase(phase);
  
  //get configuration object to AHB Driver
  if(!uvm_config_db#(ahb_agent_config)::get(this,"","ahb_agent_config",H_cnfg_h))
    `uvm_fatal(get_full_name(),"No handle of virtual interface received in AHB_AGENT")
   
  
endfunction:build_phase
              
//connect phase
function void ahb_driver :: connect_phase (uvm_phase phase);
  super.connect_phase(phase);
	vintf_h = H_cnfg_h.vintf_h;
endfunction:connect_phase
              
 //end of elaboration phase
 function void ahb_driver::end_of_elaboration_phase(uvm_phase phase);
   `uvm_info("AHB_DRIVER",{get_full_name(),"####created####"},UVM_MEDIUM);
   
 endfunction:end_of_elaboration_phase
              
//Run phase
task ahb_driver::run_phase(uvm_phase phase);
    
   @(vintf_h.HDRV_MP.Hdrv_cb);
  vintf_h.Hdrv_cb.HRESETn    <=	0;
  vintf_h.Hdrv_cb.HREADY     <=	0;
   @(vintf_h.HDRV_MP.Hdrv_cb);
  vintf_h.Hdrv_cb.HRESETn    <=    1;
  vintf_h.Hdrv_cb.HREADY	 <=	 1;
  
   forever
     begin
       `uvm_info("AHB_DRIVER",":::::::Driving sequence ::::::::",UVM_MEDIUM);
       seq_item_port.get_next_item(req);
       drive_item_to_dut(req);     
       seq_item_port.item_done();
     end
  
endtask:run_phase
              

  //drive  item to DUT
              task ahb_driver::drive_item_to_dut(ahb_sequence_item ahb_seq_itm_h);
                begin
                  if(ahb_seq_itm_h.HRESETn==0)
                    begin
                      @(vintf_h.HDRV_MP.Hdrv_cb);
                      vintf_h.HDRV_MP.Hdrv_cb.HRESETn  <= 0;
                      vintf_h.HDRV_MP.Hdrv_cb.HSEL  <= 0;
                      @(vintf_h.HDRV_MP.Hdrv_cb);
                       vintf_h.HDRV_MP.Hdrv_cb.HRESETn  <= 1;
                      @(vintf_h.HDRV_MP.Hdrv_cb);
                    end
                  else if (ahb_seq_itm_h.HRESETn==1)
                    //write operation
                    if(ahb_seq_itm_h.HWRITE)
                      begin
                         @(vintf_h.HDRV_MP.Hdrv_cb);
                        vintf_h.HDRV_MP.Hdrv_cb.HRESETn	<=	1;
                        vintf_h.HDRV_MP.Hdrv_cb.HSEL	<=	ahb_seq_itm_h.HSEL;
                        vintf_h.HDRV_MP.Hdrv_cb.HADDR	<=	ahb_seq_itm_h.HADDR;
                        vintf_h.HDRV_MP.Hdrv_cb.HTRANS	<=	ahb_seq_itm_h.HTRANS;
                        vintf_h.HDRV_MP.Hdrv_cb.HSIZE	<=	ahb_seq_itm_h.HSIZE;
                        vintf_h.HDRV_MP.Hdrv_cb.HPROT	<=	ahb_seq_itm_h.HPROT;
                        vintf_h.HDRV_MP.Hdrv_cb.HWRITE	<=	ahb_seq_itm_h.HWRITE;
                         @(vintf_h.HDRV_MP.Hdrv_cb);
                         @(vintf_h.HDRV_MP.Hdrv_cb);
                        vintf_h.HDRV_MP.Hdrv_cb.HSIZE	<=	ahb_seq_itm_h.HSIZE;
                        vintf_h.HDRV_MP.Hdrv_cb.HWDATA	<=	ahb_seq_itm_h.HWDATA;
                        @(vintf_h.HDRV_MP.Hdrv_cb);
                      end
                  else 
                    begin
                     vintf_h.HDRV_MP.Hdrv_cb.HRESETn	<=	1;
                        vintf_h.HDRV_MP.Hdrv_cb.HSEL	<=	ahb_seq_itm_h.HSEL;
                  		vintf_h.HDRV_MP.Hdrv_cb.HTRANS	<=	ahb_seq_itm_h.HTRANS;
                        vintf_h.HDRV_MP.Hdrv_cb.HSIZE	<=	ahb_seq_itm_h.HSIZE;
                        vintf_h.HDRV_MP.Hdrv_cb.HPROT	<=	ahb_seq_itm_h.HPROT;
                        vintf_h.HDRV_MP.Hdrv_cb.HWRITE	<=	ahb_seq_itm_h.HWRITE;
                 		 vintf_h.HDRV_MP.Hdrv_cb.HREADY	<= 	ahb_seq_itm_h.HREADY;
                         @(vintf_h.HDRV_MP.Hdrv_cb);
                  		@(vintf_h.HDRV_MP.Hdrv_cb);
                      if(!vintf_h.HDRV_MP.Hdrv_cb.HRESP && !vintf_h.HDRV_MP.Hdrv_cb.HREADYOUT)
                  ahb_seq_itm_h.HRDATA = vintf_h.HDRV_MP.Hdrv_cb.HRDATA;
                
                    end
                  
                end
                
              endtask:drive_item_to_dut 


