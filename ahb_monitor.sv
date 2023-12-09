class ahb_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_monitor)
  
   //agent configuration object
  ahb_agent_config H_cnfg_h;
  
  ahb_sequence_item ahb_seq_itm_h;
  
  //Analysis port
  uvm_analysis_port#(ahb_sequence_item)H_mon_ap;
  
  //virtual interface handle
  virtual ahb_intf.HMON_MP vintf_h;

covergroup ahb_coverage;
                
                 HADDR : coverpoint ahb_seq_itm_h.HADDR
                            { 
                              bins addr_low  ={[16'h0000:16'h00FF]};
                              bins addr_mid  ={[16'h0100:16'h0FFF]};
                              bins addr_high ={[16'h1000:16'hFFFF]};
                            }

                HWDATA : coverpoint ahb_seq_itm_h.HWDATA
                            {
                              bins wdata_low  ={[32'h00000000:32'h00000FFF]};
                              bins wdata_mid  ={[32'h00001000:32'h000FFFFF]};
                              bins wdata_high ={[32'h00100000:32'hFFFFFFFF]};
                            }
                HRDATA : coverpoint ahb_seq_itm_h.HRDATA
                            {
                              bins rdata_low  ={[32'h00000000:32'h00000FFF]};
                              bins rdata_mid  ={[32'h00001000:32'h000FFFFF]};
                              bins rdata_high ={[32'h00100000:32'hFFFFFFFF]};
                            }
                HWRITE : coverpoint ahb_seq_itm_h.HWRITE
                            {
                              bins write_bin ={1};
                              bins read_bin  ={0};
                   
                             }
               
           endgroup
 
  
  extern function new (string name = "ahb_monitor",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
          
  endclass:ahb_monitor
    
    //constructor
    function ahb_monitor::new(string name="ahb_monitor",uvm_component parent);
      super.new (name,parent);
      H_mon_ap = new("H_mon_ap",this);
      ahb_coverage = new();
    endfunction:new
    
    //build_phase
function void ahb_monitor::build_phase(uvm_phase phase);
  
  //get configuration object from AHB Agent
  if(!uvm_config_db#(ahb_agent_config)::get(this,"","ahb_agent_config",H_cnfg_h))
    `uvm_fatal(get_full_name(),"No handle of virtual interface received in AHB_AGENT")
    
  super.build_phase(phase);
  ahb_seq_itm_h = ahb_sequence_item::type_id::create("ahb_seq_itm_h");
  
endfunction:build_phase
              
//connect phase
function void ahb_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
	vintf_h = H_cnfg_h.vintf_h;
endfunction:connect_phase
              
 //end of elaboration phase
 function void ahb_monitor::end_of_elaboration_phase(uvm_phase phase);
   `uvm_info("AHB_MONITOR",{get_full_name(),"####created####"},UVM_MEDIUM);
   
 endfunction:end_of_elaboration_phase
    
//run_phase
   task ahb_monitor::run_phase(uvm_phase phase);
     begin
     forever
       begin
         @(vintf_h.Hmon_cb)
         
         if(vintf_h.Hmon_cb.HRESETn==1)
           begin
         
         if(vintf_h.Hmon_cb.HWRITE && vintf_h.Hmon_cb.HSEL && vintf_h.Hmon_cb.HREADY)
           
           begin
            ahb_seq_itm_h.HWRITE = vintf_h.Hmon_cb.HWRITE;
            ahb_seq_itm_h.HADDR = vintf_h.Hmon_cb.HADDR;
             
              @(vintf_h.Hmon_cb);
             @(vintf_h.Hmon_cb);
             @(vintf_h.Hmon_cb);
             
             ahb_seq_itm_h.HWDATA = vintf_h.Hmon_cb.HWDATA;
             H_mon_ap.write(ahb_seq_itm_h);
             ahb_coverage.sample();

           end
         
         else 
           if(!vintf_h.Hmon_cb.HWRITE && vintf_h.Hmon_cb.HSEL && vintf_h.Hmon_cb.HREADY)
           begin
           ahb_seq_itm_h.HWRITE = vintf_h.Hmon_cb.HWRITE;
            ahb_seq_itm_h.HADDR = vintf_h.Hmon_cb.HADDR; 
             
             @(vintf_h.Hmon_cb);
             @(vintf_h.Hmon_cb);
             //@(vintf_h.Hmon_cb);
             
             ahb_seq_itm_h.HRDATA = vintf_h.Hmon_cb.HRDATA;
             H_mon_ap.write(ahb_seq_itm_h);
            ahb_coverage.sample();
         end
           end
         end
     end
   endtask:run_phase
      
      