`timescale 1ns/1ps

module full_protocol_tb;
   reg reset;
   reg clk;
   reg data_in;
   wire finished;     
   wire [7:0] cmd_data_out;
   wire [7:0] length_data_out;
   wire [7:0] r_data_out;
   wire [7:0] g_data_out;
   wire [7:0] b_data_out;
   wire [7:0] check_data_out;
   wire [3:0] state;
   full_protocol uut(reset, clk, data_in, finished, cmd_data_out, length_data_out,r_data_out,g_data_out,b_data_out,check_data_out,state);
    
    always #5 clk=~clk;
    
    initial begin
        clk=0;
        reset = 1;
        data_in=1;
        #20;
        reset = 0;
        #1000;
        
        data_in=0; //start bit
        #1000;
        
        data_in=1; #1000; //cmd start
        data_in=0;#1000; 
        data_in=1;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=1;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000;  //cmd finish
        
        data_in=1;#1000;  //length bit start
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000;  //length bit finish
        
        data_in=1;#1000;  //R-bit start
        data_in=0;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=1;#1000; 
        data_in=1;#1000;  //R-bit finish
        
        data_in=1;#1000;  //g-bit start
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000;  //g-bit finish
        
        data_in=0;#1000;  //b-bit start
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=1;#1000;  //b-bit finish      
        
        data_in=1;#1000;  //checksum start
        data_in=0;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000;  //checksum finish
        
        
        data_in=1;
        #140000;  
        
        
        
        data_in=0; //start bit
        #1000;
        
        data_in=0; #1000; //cmd start
        data_in=1;#1000; 
        data_in=1;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=1;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000;  //cmd finish
        
        data_in=1;#1000;  //length bit start
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000;  //length bit finish
        
        data_in=1;#1000;  //R-bit start
        data_in=1;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=1;#1000;  //R-bit finish
        
        data_in=1;#1000;  //g-bit start
        data_in=1;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000;  //g-bit finish
        
        data_in=0;#1000;  //b-bit start
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=1;#1000; 
        data_in=1;#1000;  //b-bit finish      
        
        data_in=1;#1000;  //checksum start
        data_in=0;#1000; 
        data_in=1;#1000; 
        data_in=1;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000; 
        data_in=0;#1000;  //checksum finish
        
        data_in=1;
        #140000;  
            
        $finish;
    end
    

endmodule
