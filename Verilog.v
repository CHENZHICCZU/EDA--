module IntersectionTrafficLight (
  input wire clk,    // 时钟信号
  input wire reset,  // 复位信号
  output wire left_turn_a,  // A方向左拐灯
  output wire green_a,      // A方向绿灯
  output wire yellow_a,     // A方向黄灯
  output wire red_a,        // A方向红灯
  output wire left_turn_b,  // B方向左拐灯
  output wire green_b,      // B方向绿灯
  output wire yellow_b,     // B方向黄灯
  output wire red_b         // B方向红灯
);

  reg [2:0] state_a;    // A方向状态寄存器
  reg [2:0] state_b;    // B方向状态寄存器
  reg counter_yellow_a;
  reg counter_yellow_b;
  reg [4:0] countdown_a;  // A方向倒计时寄存器
  reg [4:0] countdown_b;  // B方向倒计时寄存器
  
  parameter IDLE = 3'b000;        // 空闲状态
  parameter LEFT_TURN = 3'b001;   // 左拐状态
  parameter YELLOW = 3'b010;      // 黄灯状态
  parameter GREEN = 3'b011;       // 绿灯状态
  parameter RED = 3'b100;         // 红灯状态
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state_a <= IDLE;          // 复位时将A方向状态设置为IDLE
      countdown_a <= 0;         // 复位时将A方向倒计时设置为0
      state_b <= IDLE;          // 复位时将B方向状态设置为IDLE
      countdown_b <= 0;         // 复位时将B方向倒计时设置为0
      counter_yellow_a<=0;
      counter_yellow_b<=0;
    end else begin
      case (state_a)
        IDLE: begin
          if (countdown_a == 0) begin
            state_a <= LEFT_TURN;  // 进入左拐状态
            countdown_a <= 15;     // 设置A方向左拐倒计时为15
          end else begin
            countdown_a <= countdown_a - 1;
          end
        end
        LEFT_TURN: begin
          if (countdown_a == 0) begin
            state_a <= YELLOW;     // 进入黄灯状态
            countdown_a <= 5;      // 设置A方向黄灯倒计时为5
          end else begin
            countdown_a <= countdown_a - 1;
          end
        end
        YELLOW:
        if(!counter_yellow_a) begin
          if (countdown_a == 0) begin
            state_a <= GREEN;      // 进入绿灯状态
            countdown_a <= 40;     // 设置A方向绿灯倒计时为40
            counter_yellow_a<=~counter_yellow_a;
          end 
          else begin  
            countdown_a <= countdown_a - 1;
          end
          end
          else begin
          if (countdown_a == 0) begin
            state_a <= RED;      // 进入绿灯状态
            countdown_a <= 55;     // 设置A方向绿灯倒计时为40
          end else begin
            countdown_a <= countdown_a - 1;
          end
        end
        
        GREEN: begin
          if (countdown_a == 0) begin
            state_a <= YELLOW;     // 进入黄灯状态
            countdown_a <= 5;      // 设置A方向黄灯倒计时为5
          end else begin
            countdown_a <= countdown_a - 1;
          end
        end
        
        RED: begin
          if (countdown_a == 0) begin
            state_a <= IDLE;       // 进入空闲状态
            countdown_a <= 55;     // 设置A方向红灯倒计时为55
          end else begin
            countdown_a <= countdown_a - 1;
          end
        end
      endcase


      case (state_b)
        IDLE: begin
          if (countdown_b == 0) begin
            state_b <= RED;  // 进入红灯状态
            countdown_b <=65;     // 设时间65s
            counter_yellow_b<=0;
          end else begin
            countdown_b <= countdown_b - 1;
          end
        end
        
        LEFT_TURN: begin
          if (countdown_b == 0) begin
            state_b <= YELLOW;     // 进入黄灯状态            countdown_b <= 5;      // 设置B方向黄灯倒计时为5
            countdown_b <=5; 
          end else begin
            countdown_b <= countdown_b - 1;
          end
        end
        
        YELLOW: 
        if(!counter_yellow_b)
        begin
          if (countdown_b == 0) begin
            state_b <= GREEN;      // 进入绿灯状态
            countdown_b <= 30;     // 设置B方向绿灯倒计时为30
            countdown_b<=~countdown_b;  
          end else begin
            countdown_b <= countdown_b - 1;
          end
        end 
        else begin 
          if (countdown_b == 0) begin
            state_b <= IDLE;      // 进入绿灯状态
            countdown_b <= 0;     // 设置B方向绿灯倒计时为30
          end else begin
            countdown_b <= countdown_b - 1;
          end

        end





        
        GREEN: begin
          if (countdown_b == 0) begin
            state_b <= YELLOW;     // 进入黄灯状态
            countdown_b <= 5 ;      // 设置B方向黄灯倒计时为5
          end else begin
            countdown_b <= countdown_b - 1;
          end
        end
        
        RED: begin
          if (countdown_b == 0) begin
            state_b <= LEFT_TURN;       // 进入空闲状态
            countdown_b <= 15;     // 设置B方向红灯倒计时为65
          end else begin
            countdown_b <= countdown_b - 1;
          end
        end
      endcase
    end
  end

  // 输出信号控制
  assign left_turn_a = (state_a == LEFT_TURN) ? 1'b1 : 1'b0;
  assign green_a = (state_a == GREEN) ? 1'b1 : 1'b0;
  assign yellow_a = (state_a == YELLOW) ? 1'b1 : 1'b0;
  assign red_a = (state_a == RED) ? 1'b1 : 1'b0;
  
  assign left_turn_b = (state_b == LEFT_TURN) ? 1'b1 : 1'b0;
  assign green_b = (state_b == GREEN) ? 1'b1 : 1'b0;
  assign yellow_b = (state_b == YELLOW) ? 1'b1 : 1'b0;
  assign red_b = (state_b == RED) ? 1'b1 : 1'b0;

endmodule