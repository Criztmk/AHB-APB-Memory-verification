class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)
  
  //virtual interface handle
  virtual apb_intf.PMON_MP vintf_h;
  
  apb_sequence_item apb_seq_itm_h;
  
  //agent configuration object
  apb_agent_config P_cnfg_h;
  
  //tlm_analysis port
  uvm_analysis_port#(apb_sequence_item)P_mon_ap;

covergroup apb_coverage;
                
                 PADDR : coverpoint apb_seq_itm_h.PADDR
                            { 
                              bins addr_low  ={[16'h0000:16'h00FF]};
                              bins addr_mid  ={[16'h0100:16'h0FFF]};
                              bins addr_high ={[16'h1000:16'hFFFF]};
                            }

                PWDATA : coverpoint apb_seq_itm_h.PWDATA
                            {
                              bins wdata_low  ={[32'h00000000:32'h00000FFF]};
                              bins wdata_mid  ={[32'h00001000:32'h000FFFFF]};
                              bins wdata_high ={[32'h00100000:32'hFFFFFFFF]};
                            }
                PRDATA : coverpoint apb_seq_itm_h.PRDATA
                            {
                              bins rdata_low  ={[32'h00000000:32'h00000FFF]};
                              bins rdata_mid  ={[32'h00001000:32'h000FFFFF]};
                              bins rdata_high ={[32'h00100000:32'hFFFFFFFF]};
                            }
                PWRITE : coverpoint apb_seq_itm_h.PWRITE
                            {
                              bins write_bin ={1};
                              bins read_bin  ={0};
                   
                             }
               
           endgroup
 

  
  extern function new (string name = "apb_monitor",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
    
          
  endclass:apb_monitor
    
    //constructor
    function apb_monitor::new(string name="apb_monitor",uvm_component parent);
      super.new (name,parent);
      P_mon_ap = new("P_mon_ap",this);
     apb_coverage=new();
    endfunction:new
    
    //build_phase
function void apb_monitor::build_phase(uvm_phase phase);
  
   
  //get configuration object from APB Agent
  if(!uvm_config_db#(apb_agent_config)::get(this,"","apb_agent_config",P_cnfg_h))
    `uvm_fatal(get_full_name(),"No handle of virtual interface received in APB_AGENT") 
    super.build_phase(phase);
  apb_seq_itm_h = apb_sequence_item::type_id::create("apb_seq_itm_h");
endfunction:build_phase
              
//connect phase
function void apb_monitor::connect_phase(uvm_phase phase);
	vintf_h=P_cnfg_h.vintf_h;
endfunction:connect_phase
              
 //end of elaboration phase
 function void apb_monitor::end_of_elaboration_phase(uvm_phase phase);
   `uvm_info("APB_MONITOR",{get_full_name(),"####created####"},UVM_MEDIUM); 
 endfunction:end_of_elaboration_phase
      
    task apb_monitor::run_phase(uvm_phase phase);
      begin
      forever
        begin
          @(vintf_h.Pmon_cb)
          //for write transfer
          if(vintf_h.Pmon_cb.PWRITE==1 && vintf_h.Pmon_cb.PENABLE==1 && vintf_h.Pmon_cb.PSEL==1 && vintf_h.Pmon_cb.PREADY==1 )
            begin
            apb_seq_itm_h.PWRITE = vintf_h.Pmon_cb.PWRITE;
            apb_seq_itm_h.PWDATA = vintf_h.Pmon_cb.PWDATA;
            apb_seq_itm_h.PADDR = vintf_h.Pmon_cb.PADDR;
              P_mon_ap.write(apb_seq_itm_h);
              apb_coverage.sample();
            end
          //for read transfer
          if(vintf_h.Pmon_cb.PWRITE==0 && vintf_h.Pmon_cb.PENABLE==1 && vintf_h.Pmon_cb.PSEL==1 && vintf_h.Pmon_cb.PREADY==1 )
            begin
             
              apb_seq_itm_h.PWRITE = vintf_h.Pmon_cb.PWRITE; 
               apb_seq_itm_h.PADDR = vintf_h.Pmon_cb.PADDR;
               apb_seq_itm_h.PRDATA = vintf_h.Pmon_cb.PRDATA;
              @(vintf_h.Pmon_cb);
             // @(vintf_h.Pmon_cb);
              //@(vintf_h.Pmon_cb);
               P_mon_ap.write(apb_seq_itm_h);
             apb_coverage.sample();
            end
        end
          
          
        end
    endtask:run_phase