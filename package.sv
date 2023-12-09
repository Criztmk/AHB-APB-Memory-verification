
package ahb2apb_bridge;

import uvm_pkg::*;
`include "uvm_macros.svh"


`include "ahb_sequence_item.sv"
`include "apb_sequence_item.sv"

`include "ahb_agent_config.sv"
`include "apb_agent_config.sv"
`include "env_config.sv"

`include "ahb_sequences.sv"
`include "ahb_sequencer.sv"
`include "ahb_driver.sv"
`include "ahb_monitor.sv"
`include "ahb_agent.sv"

`include "apb_sequences.sv"
`include "apb_sequencer.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"
`include "apb_agent.sv"

`include "ahb_scrbd.sv"
`include "apb_scrbd.sv"

`include "scoreboard.sv"
`include "ahb_coverage.sv"
`include "environment.sv"
`include "tests.sv"

endpackage