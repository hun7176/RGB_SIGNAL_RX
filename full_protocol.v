`timescale 1ns/1ps
module full_protocol
  (
   input            reset,
   input            clk,
   input            data_in,
   output reg       finished,        
   output reg [7:0] cmd_data_out,
   output reg [7:0] length_data_out,
   output reg [7:0] r_data_out,
   output reg [7:0] g_data_out,
   output reg [7:0] b_data_out,
   output reg [7:0] check_data_out,
   output reg [3:0] state
   );
   
  localparam IDLE         = 4'b0000; //평상시 상태. 입력데이터가 0이 되면(start bit) 다음상태로 넘어간다.
  localparam RECEIVE_START = 4'b0001; //이 state에서 반클락을 delay한다.
  localparam RECEIVE_CMD = 4'b0010;
  localparam RECEIVE_LENGTH = 4'b0011;
  localparam RECEIVE_r_DATA = 4'b0100;
  localparam RECEIVE_g_DATA = 4'b0101;
  localparam RECEIVE_b_DATA = 4'b0110;
  localparam RECEIVE_CHECK = 4'b0111;
  localparam RECEIVE_STOP  = 4'b1000;
  localparam CLEANUP      = 4'b1001;
  
  reg [6:0] count; //100까지만 셀수 있으면 된다. 100클락에 한문자 날라옴.
  reg [2:0] bit_index; //송신하고자 하는 데이터의 인덱스
  reg [3:0] current_state; //fsm의 현재 state
  
  
  always @(posedge clk or posedge reset)
  begin
    if (reset) begin
      current_state <= 3'b000; 
	  finished   <= 1'b0;
    end

    else begin case (current_state)
      IDLE : begin state<=0;
          finished<= 1'b0;
          count <= 0;
          bit_index   <= 0;         
          if (data_in == 1'b0)          // 입력데이터가 0, startbit가 시작하게되면 다음 state
            current_state <= RECEIVE_START;
          else
            current_state <= IDLE;
        end

      RECEIVE_START : begin state<=1;
          if (count == 50) begin
				if (data_in == 1'b0) begin
					count <= 0; 
					current_state <= RECEIVE_CMD;
					end
            	else
            		current_state <= IDLE;
          		end
          else begin
            count <= count + 1;
            current_state <= RECEIVE_START;
          end
        end 
      
      RECEIVE_CMD : begin state<=2;
          if (count < 100) begin
            count <= count + 1;
            current_state <= RECEIVE_CMD;
          end else
          begin
            count <= 0;
            cmd_data_out[bit_index] <= data_in;
            if (bit_index < 7)
            begin
              bit_index <= bit_index + 1;
              current_state   <= RECEIVE_CMD;
            end
            else
            begin
              bit_index <= 0;
              current_state   <= RECEIVE_LENGTH;
            end
          end
        end 

       RECEIVE_LENGTH : begin state<=3;
          if (count < 100) begin
            count <= count + 1;
            current_state <= RECEIVE_LENGTH;
          end else
          begin
            count <= 0;
            length_data_out[bit_index] <= data_in;
            if (bit_index < 7)
            begin
              bit_index <= bit_index + 1;
              current_state   <= RECEIVE_LENGTH;
            end
            else
            begin
              bit_index <= 0;
              current_state   <= RECEIVE_r_DATA;
            end
          end
        end      

       RECEIVE_r_DATA : begin state<=4;
          if (count < 100) begin
            count <= count + 1;
            current_state <= RECEIVE_r_DATA;
          end else
          begin
            count <= 0;
            r_data_out[bit_index] <= data_in;
            if (bit_index < 7) begin
              bit_index <= bit_index + 1;
              current_state   <= RECEIVE_r_DATA;
            end
            else begin
              bit_index <= 0;
			  if(length_data_out==8'h01)
              	current_state   <= RECEIVE_CHECK;
                else
			  	current_state   <= RECEIVE_g_DATA;
            end
          end
        end   
             
		RECEIVE_g_DATA : begin state<=5;
          if (count < 100) begin
            count <= count + 1;
            current_state <= RECEIVE_g_DATA;
          end else
          begin
            count <= 0;
            g_data_out[bit_index] <= data_in;
            if (bit_index < 7)
            begin
              bit_index <= bit_index + 1;
              current_state   <= RECEIVE_g_DATA;
            end
            else
            begin
              bit_index <= 0;
			  if(length_data_out==2)begin
              	current_state   <= RECEIVE_CHECK;
			  end else
			  	current_state   <= RECEIVE_b_DATA;
            end
          end
        end 


		RECEIVE_b_DATA : begin state<=6;
          if (count < 100) begin
            count <= count + 1;
            current_state <= RECEIVE_b_DATA;
          end else
          begin
            count <= 0;
            b_data_out[bit_index] <= data_in;
            if (bit_index < 7)
            begin
              bit_index <= bit_index + 1;
              current_state   <= RECEIVE_b_DATA;
            end
            else
            begin
              bit_index <= 0;
			  current_state   <= RECEIVE_CHECK;
            end
          end
        end 

		RECEIVE_CHECK : begin state<=7;
          if (count < 100) begin
            count <= count + 1;
            current_state <= RECEIVE_CHECK;
          end else
          begin
            count <= 0;
            check_data_out[bit_index] <= data_in;
            if (bit_index < 7)
            begin
              bit_index <= bit_index + 1;
              current_state   <= RECEIVE_CHECK;
            end
            else
            begin
              bit_index <= 0;
			  current_state   <= RECEIVE_STOP;
            end
          end
        end 

      RECEIVE_STOP : begin state<=8;
          if (count < 100)
          begin
            count <= count + 1;
            current_state<= RECEIVE_STOP;
          end
          else
          begin
            finished<= 1'b1;
            count <= 0;
            current_state<= CLEANUP;
          end
        end 

      CLEANUP : begin state<=9;
          current_state <= IDLE;
          finished   <= 1'b0;
        end
    
      default :
        current_state <= IDLE;
      
    endcase
    end 
  end
  
endmodule 