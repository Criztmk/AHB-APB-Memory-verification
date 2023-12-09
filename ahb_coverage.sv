class ahb_coverage extends uvm_subscriber#(ahb_sequence_item);
`uvm_component_utils(ahb_coverage)


env_config config_h;
ahb_sequence_item ahb_seq_itm_h;

real coverage;

covergroup ahb_coverage;
option.per_instance =1;

reset : coverpoint ahb_seq_itm_h.HRESETn;
write : coverpoint ahb_seq_itm_h.HWRITE;
trans : coverpoint ahb_seq_itm_h.HTRANS;
size  : coverpoint ahb_seq_itm_h.HSIZE;
addr  : coverpoint ahb_seq_itm_h.HADDR[0] {option.auto_bin_max = 16;}
wdata : coverpoint ahb_seq_itm_h.HWDATA[0] {option.auto_bin_max = 32;}
rdata : coverpoint ahb_seq_itm_h.HRDATA[0] {option.auto_bin_max = 32;}
resp  : coverpoint ahb_seq_itm_h.HRESP;
rdy   : coverpoint ahb_seq_itm_h.HREADY;


wr_size : cross write,size;

endgroup

//constructor
function new (string name = "ahb_coverage",uvm_component parent);
super.new(name,parent);
ahb_coverage = new();
endfunction


//build_phase
function void build_phase(uvm_phase phase);

if(!uvm_config_db#(env_config)::get(this,"","env_config",config_h))
`uvm_fatal(get_full_name(),"cannot get environment config from configuration database!")

 ahb_seq_itm_h = ahb_sequence_item::type_id::create("ahb_seq_itm_h",this);
super.build_phase(phase);
endfunction

//write
function void write(ahb_sequence_item t);
ahb_seq_itm_h = t;
ahb_coverage.sample();
endfunction

//extractphase
function void extract_phase(uvm_phase phase);
coverage = ahb_coverage.get_coverage();
endfunction

//report_phase
function void report_phase(uvm_phase phase);
`uvm_info(get_type_name(),$sformatf("coverage is = %f",coverage),UVM_MEDIUM);
endfunction

endclass:ahb_coverage


