`ifndef AXIS_ENV_IF
`define AXIS_ENV_IF

interface axis_env_if();
  
  // Clock and Reset interfaces
  clk_agent_if         clk_if      ();
  rst_agent_if         rst_if      ();
  
  axi_stream_agent_if  axis_in_if  (clk_if.clk, rst_if.rst_n);
  axi_stream_agent_if  axis_out_if (clk_if.clk, rst_if.rst_n);

endinterface

`endif // !AXIS_ENV_IF