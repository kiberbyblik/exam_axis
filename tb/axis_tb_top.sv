`ifndef AXIS_TB_TOP
`define AXIS_TB_TOP

`include "axis_defines.sv"
`include "axis_env_if.sv"
`include "axis_env.sv"
`include "axis_test.sv"


module axis_tb_top;

  axis_env_if env_if();

  axis_env    env;

  axis_test   test;

  axis_reg top (
   .clk_i               (env_if.clk_if.clk),
   .arstn_i             (env_if.rst_if.rst_n),
   .s_axis_tdata_i      (env_if.axis_in_if.axis_data),
   .s_axis_tvalid_i      (env_if.axis_in_if.axis_valid),
   .s_axis_tready_o      (env_if.axis_in_if.axis_ready),
   .m_axis_tdata_o       (env_if.axis_out_if.axis_data),
   .m_axis_tvalid_o      (env_if.axis_out_if.axis_valid),
   .m_axis_tready_i      (env_if.axis_out_if.axis_ready )
  );

  initial begin
    // Set time format
    $timeformat(-12, 0, " ps", 10);

    env = new(env_if);

    // Creating test   
    test = new(env);

    // Calling run of test
    test.run();
  end

endmodule

`endif //!AXIS_TB_TOP