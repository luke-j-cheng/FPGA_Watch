module stopwatch(
    input pause, 
    input rst,
    input clk1sec,
    input clk100MHz,
    input [1:0] sel,
    output reg [3:0] tenminout,
    output reg [3:0] oneminout,
    output reg [3:0] tensecout,
    output reg [3:0] onesecout
    );
    reg toggle = 0;
    reg [3:0] tenmin = 0, onemin = 0, tensec = 0, onesec = 0;
    
    always @(posedge pause)begin
        if(sel == 2'b01)
            toggle = ~toggle;
    end
    
    always @(posedge clk1sec)begin
        if (toggle == 1)begin
            if (onesec == 9) begin
                onesec <= 0;
                if (tensec == 5) begin
                    tensec <= 0;
                    if (onemin == 9 && tenmin != 5)begin
                        onemin <= 0;
                        tenmin = tenmin + 1;
                    end
                    
                    else if (onemin == 9 && tenmin == 5)begin
                        onemin <= 0;
                        tenmin <= 0;
                    end
                    
                    else begin
                        onemin <= onemin + 1;
                    end
                end
                
                else begin
                    tensec <= tensec + 1;  
                end
            end
            
            else begin
                onesec <= onesec + 1;
            end
        end   
    end 
    always @(posedge clk100MHz)begin
        if(rst)begin
            tenmin <= 0;
            onemin <= 0;
            tensec <= 0;
            onesec <= 0;
        end   
    end
    
    
    always @(posedge clk100MHz)begin
        tensecout <= tensec;
        onesecout <= onesec;
        tenminout <= tenmin;
        oneminout <= onemin;
    end
    
        
    
endmodule