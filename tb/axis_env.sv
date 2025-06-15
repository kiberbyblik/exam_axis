`ifndef ALU_MATRIX_ENV
`define ALU_MATRIX_ENV

`include "clk_agent.sv"
`include "rst_agent.sv"
`include "axi_stream_master_agent.sv"
`include "axi_stream_slave_agent.sv"

class axis_env;

  // Agents instances
  clk_agent               clk_agent;
  rst_agent               rst_agent;

  axi_stream_master_agent axis_master_agent;
  axi_stream_slave_agent  axis_slave_agent;

  // Mailbox handles
  mailbox                 rst2scrb; // From reset             to scoreboard
  mailbox                 in2scrb;  // From axi_stream_master to scoreboard
  mailbox                 out2scrb; // From axi_stream_slave  to scoreboard

  // Virtual interface
  virtual axis_env_if vif;

  // Event fthat indicates first valid_ready
  // handshake on axis_in_if
  event first_hs;

  // Constructor
  function new(virtual axis_env_if vif);

    this.vif                 = vif;

    // Creating mailboxes
    this.rst2scrb            = new();
    this.in2scrb             = new();
    this.out2scrb            = new();
    // Creating agents
    this.clk_agent           = new(vif.clk_if                         );
    this.rst_agent           = new(vif.rst_if,      rst2scrb          );

    this.axis_master_agent   = new(vif.axis_in_if,  in2scrb,  first_hs);
    this.axis_slave_agent    = new(vif.axis_out_if, out2scrb          );

  endfunction
  
  // Test phases
  task pre_main();

  endtask
  
  task main();
    fork
      clk_agent.run();
      rst_agent.run();

      axis_master_agent.run();
      axis_slave_agent.run();
    join_none
  endtask

  // Run task
  task run;
    pre_main();
    main();
  endtask

endclass

`endif //!AXIS_ENV