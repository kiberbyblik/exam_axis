`ifndef ICON_TEST
`define ICON_TEST

class axis_test;

  axis_env env;
  int unsigned delay;

  axi_stream_transaction axis_transaction;
  clk_transaction        clk_transaction;
  rst_transaction        rst_transaction;

  function new(axis_env env);
    this.env = env;
  endfunction

  task clk_transaction_put(int t_period);
    clk_transaction  = new();
    clk_transaction.period = t_period;
    env.clk_agent.to_driver.put(clk_transaction);
  endtask

  task rst_transaction_put(int t_duration);
    rst_transaction  = new();
    rst_transaction.duration = t_duration;
    env.rst_agent.to_driver.put(rst_transaction);
  endtask

  task axis_transaction_put(logic [`AXI_DATA_W -1:0] t_data[$]);
    axis_transaction = new();
    axis_transaction.data = t_data;
    env.axis_master_agent.to_driver.put(axis_transaction);
  endtask

  task wait_axis_in_end_trans();
    @(posedge (env.vif.axis_in_if.axis_last && env.vif.axis_in_if.axis_valid && env.vif.axis_in_if.axis_ready));
    @(posedge env.vif.clk_if.clk);
  endtask

  task init_axi(logic [`AXI_DATA_W -1:0] t_data[$]);
    axis_transaction_put(t_data);
    wait_axis_in_end_trans();
  endtask

  task run(); 
    $display("run test");
    fork
      begin
        env.run();
      end
      begin
        base_test();
        $finish;
      end
      join_none
  endtask

  task base_test();  
    clk_transaction_put(`CLOCK_PERIOD);
    @(posedge env.vif.clk_if.clk);
    rst_transaction_put(50);
    $display ("here reset");  
    repeat(3)
        init_axi(.t_data({1,2,3,4,5,6,7,8,9}));
  endtask

endclass

`endif //!AXIS_TEST