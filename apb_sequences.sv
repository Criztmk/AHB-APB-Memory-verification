class P_base_sequence extends uvm_sequence#(apb_sequence_item);
  `uvm_object_utils(P_base_sequence)
  
  env_config config_h;
  
  function new (string name = "P_base_sequence");
    super.new(name);
  endfunction
 
  task body();
    if(!uvm_config_db#(env_config)::get(null,get_full_name(),"env_config",config_h))
      `uvm_info(get_type_name(),"cannot get configuration object from Environment",UVM_MEDIUM)
      endtask:body
endclass:P_base_sequence
      
    //------reset sequence -------//
      class P_reset_sequence extends P_base_sequence;
        `uvm_object_utils(P_reset_sequence)
        bit[15:0]ADDR[*];
  			bit i;
        
        function new(string name = "P_reset_sequence");
          super.new(name);
        endfunction
        
        task body();
          req = apb_sequence_item::type_id::create("req");
   
    start_item(req);
          assert (req.randomize() with {PCLKEN==1'b0 && PWRITE==1'b0 && PREADY==1'b0;});
      ADDR[i]=req.PADDR;
    finish_item(req);
    
        endtask
      endclass:P_reset_sequence
 
  
    //-----------write_sequence------------//
    class P_write_sequence extends P_base_sequence;
      `uvm_object_utils(P_write_sequence)
      
      function new(string name = "P_write_sequence");
        super.new(name);
      endfunction
      
      task body();
        
         req = apb_sequence_item::type_id::create("req");
         
        start_item(req);
        assert (req.randomize() with {PREADY==1'b1;PSLVERR==1'b0;PCLKEN==1'b1;})
          finish_item(req);
         
       
      endtask
    endclass:P_write_sequence
      
    
    //-----------read_sequence------------//
    class P_read_sequence extends P_base_sequence;
      `uvm_object_utils(P_read_sequence)
      
      function new(string name = "P_read_sequence");
        super.new(name);
      endfunction
      
      task body();
        begin 
          repeat(10)
         req = apb_sequence_item::type_id::create("req");
          begin
        start_item(req);
        assert (req.randomize() with {PREADY==1'b1;PSLVERR==1'b0;PCLKEN==1'b1;})
          finish_item(req);
          end
        end
      endtask
    endclass:P_read_sequence
      
  