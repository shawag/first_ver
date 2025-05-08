`ifndef PKT_IF_SV
`define PKT_IF_SV
`timescale 1ns / 1ps
interface pkt_if(input clk, rst_n);
    //signal of interface
    logic [7:0] data;
    logic       sop;
    logic       eop;
    logic       vld;
    //clocking block for driver
    clocking drv @(posedge clk);
        //delay of sample & dirve
        default input #1ps output #1ps;
        //output direction for dirver
        output data;
        output sop, eop, vld;
    endclocking : drv
    //modport 为接口创建不同的"视角"，限定了从这个视角可以访问的信号及其方向
    //modport 是实现接口复用和强制接口规范的强大机制，在验证环境中特别有价值，能够清晰地分离不同组件的职责和访问权限。
    modport pkt_drv (clocking drv);
    //clocking block for monitor
    clocking mon @(posedge clk);
        default input #1ps output #1ps;
        //input direction for monitor
        input data;
        input sop, eop, vld;
    endclocking: mon
    modport pkt_mon (clocking mon);
    
endinterface  
//common def
//这些类型定义允许通过类对象传递接口句柄，为面向对象的验证环境提供支持
typedef virtual pkt_if.drv vdrv;
typedef virtual pkt_if.mon vmon;

`endif