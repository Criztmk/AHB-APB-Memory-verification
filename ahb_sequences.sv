class H_base_sequence extends uvm_sequence#(ahb_sequence_item);
  `uvm_object_utils(H_base_sequence)
  
  env_config config_h;
  
  //methods
  function new (string name = "H_base_sequence");
    super.new(name);
  endfunction:new 
  
  task body();
    if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",config_h))
          `uvm_info(get_type_name(),"cannot get configuration from database",UVM_MEDIUM)
          endtask:body
 
  
endclass:H_base_sequence

//-----------------------------------//
//-----AHB Reset sequence------------//
//-----------------------------------//

class H_reset_sequence extends H_base_sequence;
  `uvm_object_utils(H_reset_sequence)
  bit[15:0]ADDR[*];
  bit i;
  
  
  //methods
  
  function new (string name = "H_reset_sequence");
    super.new(name);
  endfunction:new 
  
  task body();
    
    req = ahb_sequence_item::type_id::create("req");
    
    start_item(req);
    assert (req.randomize() with {HRESETn==1'b0 && HWRITE==1'b0 && HREADY==1'b0;});
      ADDR[i]=req.HADDR;
    finish_item(req);
   
  endtask:body
  
endclass : H_reset_sequence
    

//------------write Sequence------------//
    class H_write_sequence extends H_base_sequence;
      `uvm_object_utils(H_write_sequence)
      
      function new (string name = "H_write_sequence");
        super.new(name);
      endfunction
      
      task body();
       
        req = ahb_sequence_item::type_id::create("req");
         
        start_item(req);
        assert(req.randomize() with {HADDR[1:0] ==2'b00;HRESETn==1'b1;HPROT==3'b000;HREADY==1; HTRANS==2'b10;HSIZE==3'b000;HWRITE ==1'b1; HSEL==1'b1;})
        finish_item(req);
          
      endtask:body
      
    endclass:H_write_sequence
    
    
    //-----------Read_sequence-----------//
    
    class H_read_sequence extends H_base_sequence;
      `uvm_object_utils(H_read_sequence)
      
      function new (string name = "H_read_sequence");
        super.new(name);
      endfunction
      
      task body();
        
       req = ahb_sequence_item::type_id::create("req");
          repeat(10)
            begin
        start_item(req);
      
        assert(req.randomize() with {HRESETn==1'b1;HADDR[1:0] ==2'b00;HPROT==3'b000;HREADY==1; HTRANS==2'b10;
                    				 HSIZE==3'b000;HWRITE ==1'b0; HSEL==1'b1;});
        finish_item(req);
            end
        
      endtask:body
      
    endclass:H_read_sequence
    
    
    //------simultaneous read and write sequence------//
    
    class simultaneous_write_and_read_sequence extends H_base_sequence;
      `uvm_object_utils(simultaneous_write_and_read_sequence)
      
      function new (string name = "simultaneous_write_and_read_sequence");
        super.new(name);
      endfunction
      
      
       task body();
       
        req = ahb_sequence_item::type_id::create("req");
       begin  
        start_item(req);
        assert(req.randomize() with {HADDR[1:0] ==2'b00;HRESETn==1'b1;HPROT==3'b000;HREADY==1; HTRANS==2'b10;HSIZE==3'b000;HWRITE ==1'b1; HSEL==1'b1;})
        finish_item(req);
       end 
         
         begin
        start_item(req);
assert(req.randomize() with {HRESETn==1'b1;HADDR[1:0] ==2'b00;HPROT==3'b000;HREADY==1; HTRANS==2'b10;HSIZE==3'b000;HWRITE ==1'b0; HSEL==1'b1;});
        finish_item(req);
            end
      endtask:body
      
    endclass:simultaneous_write_and_read_sequence
    