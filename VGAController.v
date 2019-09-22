`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//VGAController.v
// A module for the VGAController
// It output the proper color according to the relation between the Cordinate
// sent by the Encoder and the posision of the objects of the game.
// This is the main part of the game, and it determines the behavior of the objects 
// of the game
//
//Shao-Peng Yang
//3/15/19: Initial Release
//////////////////////////////////////////////////////////////////////////////////


module VGAController(CLK, KBCODE, HCOORD, VCOORD, KBSTROBE, ARST_L, CSEL);
input CLK, ARST_L, KBSTROBE;
input [9:0] HCOORD, VCOORD;
input [7:0] KBCODE;
output reg [11:0] CSEL;


reg [17:0] cnt_i; // internal counter to achieve 1/10 second refresh rate


reg shoot_i, shoot2_i; // internal signal for the rocket(bullet) begin fired
// the signals for the jet position, rocket position, and their speed
// shootpos determines where the rocket(bullet) is fired
reg [9:0] jetposx_i, jetposy_i, jetposx2_i, jetposy2_i, jetposx3_i, jetposy3_i, jetposx4_i, jetposy4_i, jetposx5_i, jetposy5_i, jetposx6_i, jetposy6_i
           , jetposx7_i, jetposy7_i, jetposx8_i, jetposy8_i, jetposx9_i, jetposy9_i,jetposx10_i, jetposy10_i, jetposx11_i
           ,jetposy11_i, rocketposx_i, rocketposy_i, shootpos_i,rocketposx2_i, rocketposy2_i, shootpos2_i, xspeed_i, yspeed_i;
// signals for the enemy position and speed and explosion position
reg [9:0] enemyx_i, enemyy_i,espeedx_i, espeedy_i, epx_i,epy_i, enemyx2_i, enemyy2_i,espeedx2_i, espeedy2_i, enemyx3_i, enemyy3_i,espeedx3_i, espeedy3_i, enemyx4_i, enemyy4_i, espeedx4_i, espeedy4_i
         , enemyx5_i, enemyy5_i, espeedx5_i, espeedy5_i;
// signals for background         
reg [9:0] starx_i, stary_i,starx2_i, stary2_i, starx3_i,stary3_i;  
// signals for determining whether there is kill, colision, all killed, and explosion       
reg kill_i,kill2_i, coli_i, coli2_i, coli3_i, coli4_i, coli5_i, allkilled_i, explode_i;
// signal for jet explosion
reg [9:0] jepx_i_i, jepy_i_i;
// signal for determining whether the jet is killed
reg bekilled_i;
//signal for determining whether the game is over
wire gameover_i;

// making the reset active high
wire arst_i;
assign arst_i = ~ARST_L;

// counter for the refresh rate for the jet and enemy posision
always @(posedge CLK, posedge arst_i)//Counting to 250,000
begin
   if(arst_i)
      cnt_i <= 0;
   else if(cnt_i == 250001)
      cnt_i <= 0;
   else
      cnt_i <= cnt_i + 1;
end

// position for the stars , there are three reference points, and it will keep moving down
always @ (posedge CLK, posedge arst_i)
begin
    if(arst_i)
    begin
        starx_i <= 319;
        stary_i <= 1;
    end
    else if ((stary_i+2 >= 495) && (stary_i+2 <= 832))
    begin
        starx_i <= 319;
        stary_i <= 1;
    end
    else if ((cnt_i == 249999))
    begin
        starx_i <= starx_i;
        stary_i <= stary_i + 1;
    end
end

always @ (posedge CLK, posedge arst_i)
begin
    if(arst_i)
    begin
        starx2_i <= 319;
        stary2_i <= 375;
    end
    else if ((stary2_i+2 >= 495) && (stary2_i+2 <= 832))
    begin
        starx2_i <= 319;
        stary2_i <= 1;
    end
    else if ((cnt_i == 249999))
    begin
        starx2_i <= starx2_i;
        stary2_i <= stary2_i + 1;
    end
end

always @ (posedge CLK, posedge arst_i)
begin
    if(arst_i)
    begin
        starx3_i <= 319;
        stary3_i <= 478;
    end
    else if ((stary3_i+2 >= 495) && (stary3_i+2 <= 832))
    begin
        starx3_i <= 319;
        stary3_i <= 1;
    end
    else if ((cnt_i == 249999))
    begin
        starx3_i <= starx3_i;
        stary3_i <= stary3_i + 1;
    end
end

// this determine the jet position, it will be controlled by the key 'W','A'
// the jet stop moving when it hit the wall until the key is pressed
// there are eleven reference ponits for this jet
always @ (posedge CLK, posedge arst_i)
begin
    if (arst_i)
    begin
        jetposx_i <= 319;
        jetposy_i <= 470;
        jetposx2_i <= 321;
        jetposy2_i <= 470;
        jetposx3_i <= 323;
        jetposy3_i <= 470;
        jetposx4_i <= 325;
        jetposy4_i <= 470;
        jetposx5_i <= 327;
        jetposy5_i <= 470;
        jetposx6_i <= 329;
        jetposy6_i <= 474;
        jetposx7_i <= 317;
        jetposy7_i <= 470;
        jetposx8_i <= 315;
        jetposy8_i <= 470;
        jetposx9_i <= 313;
        jetposy9_i <= 470;
        jetposx10_i <= 311;
        jetposy10_i <= 470;
        jetposx11_i <= 309;
        jetposy11_i <= 474;
        
    end 
    else if (bekilled_i)
    begin
        jetposx_i <=jetposx_i;
        jetposy_i <=jetposy_i; 
    end
    else if (((jetposx6_i+2 >= 495) && (jetposx6_i+2 <= 832)) && (KBCODE ==8'h23))
    begin 
        jetposy_i <= jetposy_i;
        jetposy2_i <= jetposy2_i;
        jetposy3_i <= jetposy3_i;
        jetposy4_i <= jetposy4_i;
        jetposy5_i <= jetposy5_i;
        jetposy6_i <= jetposy6_i;
        jetposy7_i <= jetposy7_i;
        jetposy8_i <= jetposy8_i;
        jetposy9_i <= jetposy9_i;
        jetposy10_i <= jetposy10_i;
        jetposy11_i <= jetposy11_i;
        jetposx_i <= jetposx_i-5;
        jetposx2_i <= jetposx2_i-5;
        jetposx3_i <= jetposx3_i-5;
        jetposx4_i <= jetposx4_i-5;
        jetposx5_i <= jetposx5_i-5;
        jetposx6_i <= jetposx6_i-5;
        jetposx7_i <= jetposx7_i-5;
        jetposx8_i <= jetposx8_i-5;
        jetposx9_i <= jetposx9_i-5;
        jetposx10_i <= jetposx10_i-5;
        jetposx11_i <= jetposx11_i-5;
    end
    else if ((jetposx11_i-2 >= 0)&&(jetposx11_i-2 <= 155)&& (KBCODE ==8'h1C) )
    begin
        jetposy_i <= jetposy_i;
        jetposy2_i <= jetposy2_i;
        jetposy3_i <= jetposy3_i;
        jetposy4_i <= jetposy4_i;
        jetposy5_i <= jetposy5_i;
        jetposy6_i <= jetposy6_i;
        jetposy7_i <= jetposy7_i;
        jetposy8_i <= jetposy8_i;
        jetposy9_i <= jetposy9_i;
        jetposy10_i <= jetposy10_i;
        jetposy11_i <= jetposy11_i;
        jetposx_i <= jetposx_i+5;
        jetposx2_i <= jetposx2_i+5;
        jetposx3_i <= jetposx3_i+5;
        jetposx4_i <= jetposx4_i+5;
        jetposx5_i <= jetposx5_i+5;
        jetposx6_i <= jetposx6_i+5;
        jetposx7_i <= jetposx7_i+5;
        jetposx8_i <= jetposx8_i+5;
        jetposx9_i <= jetposx9_i+5;
        jetposx10_i <= jetposx10_i+5;
        jetposx11_i <= jetposx11_i+5;
    
    end
    else if ((cnt_i == 249999)) 
    begin
        jetposy_i <= jetposy_i ;
        jetposy2_i <= jetposy2_i;
        jetposy3_i <= jetposy3_i;
        jetposy4_i <= jetposy4_i;
        jetposy5_i <= jetposy5_i;
        jetposy6_i <= jetposy6_i;
        jetposy7_i <= jetposy7_i;
        jetposy8_i <= jetposy8_i;
        jetposy9_i <= jetposy9_i;
        jetposy10_i <= jetposy10_i;
        jetposy11_i <= jetposy11_i;
        jetposx_i <= jetposx_i +xspeed_i;
        jetposx2_i <= jetposx2_i+xspeed_i;
        jetposx3_i <= jetposx3_i+xspeed_i;
        jetposx4_i <= jetposx4_i+xspeed_i;
        jetposx5_i <= jetposx5_i+xspeed_i;
        jetposx6_i <= jetposx6_i+xspeed_i;
        jetposx7_i <= jetposx7_i+xspeed_i;
        jetposx8_i <= jetposx8_i+xspeed_i;
        jetposx9_i <= jetposx9_i+xspeed_i;
        jetposx10_i <= jetposx10_i+xspeed_i;
        jetposx11_i <= jetposx11_i+xspeed_i;
    end     
    else 
    begin
        jetposy_i <= jetposy_i;
        jetposy2_i <= jetposy2_i;
        jetposy3_i <= jetposy3_i;
        jetposy4_i <= jetposy4_i;
        jetposy5_i <= jetposy5_i;
        jetposy6_i <= jetposy6_i;
        jetposy7_i <= jetposy7_i;
        jetposy8_i <= jetposy8_i;
        jetposy9_i <= jetposy9_i;
        jetposy10_i <= jetposy10_i;
        jetposy11_i <= jetposy11_i;
        jetposx_i <= jetposx_i;
        jetposx2_i <= jetposx2_i;
        jetposx3_i <= jetposx3_i;
        jetposx4_i <= jetposx4_i;
        jetposx5_i <= jetposx5_i;
        jetposx6_i <= jetposx6_i;
        jetposx7_i <= jetposx7_i;
        jetposx8_i <= jetposx8_i;
        jetposx9_i <= jetposx9_i;
        jetposx10_i <= jetposx10_i;
        jetposx11_i <= jetposx11_i;
    end
         
end

// this determine the moving direction of the jet
always @(posedge CLK, posedge arst_i)
begin
if (arst_i)
begin
     xspeed_i <= 0; 
end
else if (cnt_i == 250000)
begin
xspeed_i <= 0; 
end
else if (KBSTROBE)
begin
case(KBCODE)
        8'h23:
        begin
      xspeed_i <= 10;
        end
        8'h1C:
        begin
      xspeed_i <= -10;
        end
    default:
    begin
       xspeed_i <= 0;
      end
    endcase
end
end
/////////////////////////////////////////////////////////////////////////////

// this determine the first bulltet position during the whole game
always @(posedge CLK, posedge arst_i)
begin
   if (arst_i)
   begin
       rocketposx_i <= 319;
       rocketposy_i <= 458; 
  end
  else   if (bekilled_i)
  begin
  //reset to (o,o) and waiting for the next order
      rocketposx_i <= 0;
      rocketposy_i <= 0; 
 end
  else if (cnt_i == 249999 && shoot_i==1)
  begin
       rocketposx_i <= shootpos_i;
       rocketposy_i <= rocketposy_i - 5;
  end
  else if (cnt_i == 249999 && shoot_i==0)
  begin
       rocketposx_i <= 640;
       rocketposy_i <= 480;
  end       
  else 
  begin
       rocketposx_i <= rocketposx_i;
       rocketposy_i <= rocketposy_i; 
  end
end


// create the state machine triggered by the keyboard for the first bullet
// reset to original state if the bullet hit the top wall
// this determine where the fire position of the bullet should be
reg [1:0]nd_i,pd_i;
parameter [1:0] S1 = 00;
parameter [1:0] S2 = 01;
parameter [1:0] S3 = 10;

always @(posedge CLK, posedge arst_i)
begin
     if (arst_i)
         pd_i <= S1;
     else 
         pd_i <= nd_i;    
end

always @ (rocketposy_i, KBSTROBE, KBCODE, pd_i)//, coli_i, coli2_i, coli3_i)
begin
    case(pd_i)
    S1:begin
        if(KBSTROBE==1 && KBCODE==8'h5A)
        begin
            nd_i <= S2;
        end
        else
        begin
            nd_i <= S1;
        end
    end
    S2:begin
         nd_i <=S3;
    end
    S3:begin
    if (rocketposy_i >= 752 && rocketposy_i <= 1023) 
    begin
        nd_i<=S1;
    end
    else 
    nd_i <=S3;
    end
    default:
    begin
    nd_i <=S1;
    end
    endcase
end
always@(posedge CLK, posedge arst_i)
begin 
    if (arst_i)
    begin
         shoot_i <= 0; 
         shootpos_i <= 319;
    end
    else 
    begin
    case(pd_i)
    S1:begin
         shoot_i <= 0;
         shootpos_i <= 319;
    end
    S2:begin
         shoot_i <= 1;
    shootpos_i <= jetposx_i;
    end
    S3:begin
         shoot_i <= 1;
         shootpos_i <= shootpos_i;
    end
    default: begin
             shoot_i <= 0; 
    shootpos_i <= 319;
    end
    endcase
    end

end

//////////////////////////////////////////////////
// similar insturction to the one above for the bullet 1
// this one is for bullet2
always @(posedge CLK, posedge arst_i)
begin
   if (arst_i)
   begin
       rocketposx2_i <= 319;
       rocketposy2_i <= 458; 
  end
  else if (bekilled_i)
  begin
      rocketposx2_i <= 0;
      rocketposy2_i <= 0; 
 end
  else if (cnt_i == 249999 && shoot2_i==1)
  begin
       rocketposx2_i <= shootpos2_i;
       rocketposy2_i <= rocketposy2_i - 5;
  end
  else if (cnt_i == 249999 && shoot2_i==0)
  begin
       rocketposx2_i <= 640;
       rocketposy2_i <= 480;
  end
  else 
  begin
       rocketposx2_i <= rocketposx2_i;
       rocketposy2_i <= rocketposy2_i; 
  end
end



reg [1:0]nd2_i,pd2_i;

always @(posedge CLK, posedge arst_i)
begin
     if (arst_i)
         pd2_i <= S1;
     else 
         pd2_i <= nd2_i;    
end

always @ (rocketposy2_i, KBSTROBE, KBCODE, pd2_i, shoot_i)//, coli_i, coli2_i, coli3_i)
begin
    case(pd2_i)
    S1:begin
        if(KBSTROBE==1 && KBCODE==8'h5A && shoot_i==1)
        begin
            nd2_i <= S2;
        end
        else
        begin
            nd2_i <= S1;
        end
    end
    S2:begin
         nd2_i <=S3;
    end
    S3:begin
    if (rocketposy2_i >= 752 && rocketposy2_i <= 1023)
    begin
        nd2_i<=S1;
    end
    else 
    nd2_i <=S3;
    end
    default:
    begin
    nd2_i <=S1;
    end
    endcase
end
always@(posedge CLK, posedge arst_i)
begin 
    if (arst_i)
    begin
         shoot2_i <= 0; 
         shootpos2_i <= 319;
    end
    else 
    begin
    case(pd2_i)
    S1:begin
         shoot2_i <= 0;
         shootpos2_i <= 319;
    end
    S2:begin
         shoot2_i <= 1;
    shootpos2_i <= jetposx_i;
    end
    S3:begin
         shoot2_i <= 1;
         shootpos2_i <= shootpos2_i;
    end
    default: begin
             shoot2_i <= 0; 
    shootpos2_i <= 319;
    end
    endcase
    end

end
/////////////////////////////////////////////////
// this part determine whether all the enemy is all destroyed to enter the next level
always @ (coli_i, coli2_i, coli3_i, coli4_i , coli5_i)
begin
if (coli_i && coli2_i && coli3_i && coli4_i && coli5_i)    
        allkilled_i <=1;
    else 
        allkilled_i <=0;
end
/////////////////////////////////////////////////

// this part is a state machine for the levels
// there are two levels
reg level_i;

parameter  L1 = 0;
parameter  L2 = 1;

reg lps_i, lns_i; 

always @ (posedge CLK, posedge arst_i)
begin
    if (arst_i)
        lps_i <= L1;
    else 
        lps_i <= lns_i;    
end

always @ (lps_i, allkilled_i)
begin
    case(lps_i)
    
    L1:
    begin
        if(allkilled_i)
            lns_i <= L2;
        else 
            lns_i <= L1; 
    end           
    L2:
    begin
        if(allkilled_i)
            lns_i <= L1;
        else 
            lns_i <= L2; 
    end        
    default:
    begin
    ;
    end
    endcase
end

always @ (posedge CLK, posedge arst_i)
begin
    if(arst_i)
        level_i <= L1;     
    else
    begin
    case(lps_i)
    L1:
    begin
        level_i <= L1;
    end
    L2:
    begin
        level_i <= L2;
    end
    default:
    begin
    ;
    end
    endcase 
    end
end

///////////////////////////////////////////////////////////////////////////

//this part determine the position ands the behaviour of the 5 enemys
// their movement change according to the level signal
always @ (posedge CLK, posedge arst_i)
begin
    if (arst_i)
    begin
        enemyx_i <= 319;
        enemyy_i <= 259;
        
    end 
    else if (allkilled_i) 
    begin
        enemyx_i <= 309;
        enemyy_i <= 149;
    end     
    else if ((cnt_i == 249999)&& (level_i == L2)&& (coli_i==0)) 
    begin
        enemyx_i <= enemyx_i + espeedx_i;
        enemyy_i <= enemyy_i + espeedy_i;
    end     
    else if ((cnt_i == 249999)&& (level_i == L2)&& (coli_i==1)) 
    begin
        enemyx_i <= 0;
        enemyy_i <= 0;
    end     
    else if ((cnt_i == 249999)&& (level_i == L1)&& (coli_i==0)) 
    begin
        enemyx_i <= enemyx_i + espeedx_i;
        enemyy_i <= enemyy_i;
    end     
    else if ((cnt_i == 249999)&& (level_i == L1)&& (coli_i==1)) 
    begin
        enemyx_i <= 0;
        enemyy_i <= 0;
    end     

    else 
    begin
        enemyx_i <= enemyx_i;
        enemyy_i <= enemyy_i;
      
    end
         
end

always @(posedge CLK, posedge arst_i)
begin
if (arst_i)
begin
     espeedx_i <= 1; 
     espeedy_i <= 1; 
end
else if (coli_i)
begin
     espeedx_i <= 1; 
     espeedy_i <= 1; 
end
else if (cnt_i == 250000 && level_i == L2 && (enemyx_i <= 155 || enemyx_i >= 485))
begin
     espeedx_i <= -espeedx_i; 
     espeedy_i <= espeedy_i;
end
else if (cnt_i == 250000 && level_i == L2 && (enemyy_i >= 724 && enemyy_i <= 1023 || enemyy_i <= 724 && enemyy_i >= 479))
begin
     espeedx_i <= espeedx_i; 
     espeedy_i <= -espeedy_i;
end
else if(level_i == L2)
begin
     espeedx_i <= espeedx_i; 
     espeedy_i <= espeedy_i; 
end
else if (cnt_i == 250000 && level_i == L1 && (enemyx_i >= 350 || enemyx_i <= 300))
begin
     espeedx_i <= -espeedx_i; 
     espeedy_i <= 0;
end

else
begin
     espeedx_i <= espeedx_i; 
     espeedy_i <= espeedy_i;
end
end
//e2
always @ (posedge CLK, posedge arst_i)
begin
    if (arst_i)
    begin
        enemyx2_i <= 419;
        enemyy2_i <= 259;
        
    end 
    else if (allkilled_i) 
    begin
        enemyx2_i <= 440;
        enemyy2_i <= 209;
    end     
    else if ((cnt_i == 249999)&& (level_i == L2)&& (coli2_i==0)) 
    begin
        enemyx2_i <= enemyx2_i + espeedx2_i;
        enemyy2_i <= enemyy2_i + espeedy2_i;
    end     
    else if ((cnt_i == 249999)&& (level_i == L2)&& (coli2_i==1)) 
    begin
        enemyx2_i <= 0;
        enemyy2_i <= 0;
    end     
    else if ((cnt_i == 249999)&& (level_i == L1)&& (coli2_i==0)) 
    begin
        enemyx2_i <= enemyx2_i + espeedx2_i;
        enemyy2_i <= enemyy2_i;
    end     
    else if ((cnt_i == 249999)&& (level_i == L1)&& (coli2_i==1)) 
    begin
        enemyx2_i <= 0;
        enemyy2_i <= 0;
    end     

    else 
    begin
        enemyx2_i <= enemyx2_i;
        enemyy2_i <= enemyy2_i;
      
    end
         
end

always @(posedge CLK, posedge arst_i)
begin
if (arst_i)
begin
     espeedx2_i <= -2; 
     espeedy2_i <= 1; 
end
else if (coli2_i)
begin
     espeedx2_i <= 1; 
     espeedy2_i <= 1; 
end
else if (cnt_i == 250000 && level_i == L2 && (enemyx2_i <= 155 || enemyx2_i >= 485))
begin
     espeedx2_i <= -espeedx2_i; 
     espeedy2_i <= espeedy2_i;
end
else if (cnt_i == 250000 && level_i == L2 && (enemyy2_i >= 724 && enemyy2_i <= 1023 || enemyy2_i <= 724 && enemyy2_i >= 479))
begin
     espeedx2_i <= espeedx2_i; 
     espeedy2_i <= -espeedy2_i;
end
else if(level_i == L2)
begin
     espeedx2_i <= espeedx2_i; 
     espeedy2_i <= espeedy2_i; 
end
else if (cnt_i == 250000 && level_i == L1 && (enemyx2_i >= 450 || enemyx2_i <= 400))
begin
     espeedx2_i <= -espeedx2_i; 
     espeedy2_i <= 0;
end

else
begin
     espeedx2_i <= espeedx2_i; 
     espeedy2_i <= espeedy2_i;
end
end
//
//e3
always @ (posedge CLK, posedge arst_i)
begin
    if (arst_i)
    begin
        enemyx3_i <= 219;
        enemyy3_i <= 259;
        
    end 
    else if (allkilled_i) 
    begin
        enemyx3_i <= 200;
        enemyy3_i <= 200;
    end     
    else if ((cnt_i == 249999)&& (level_i == L2)&& (coli3_i==0)) 
    begin
        enemyx3_i <= enemyx3_i + espeedx3_i;
        enemyy3_i <= enemyy3_i + espeedy3_i;
    end     
    else if ((cnt_i == 249999)&& (level_i == L2)&& (coli3_i==1)) 
    begin
        enemyx3_i <= 0;
        enemyy3_i <= 0;
    end     
    else if ((cnt_i == 249999)&& (level_i == L1)&& (coli3_i==0)) 
    begin
        enemyx3_i <= enemyx3_i + espeedx3_i;
        enemyy3_i <= enemyy3_i;
    end     
    else if ((cnt_i == 249999)&& (level_i == L1)&& (coli3_i==1)) 
    begin
        enemyx3_i <= 0;
        enemyy3_i <= 0;
    end     

    else 
    begin
        enemyx3_i <= enemyx3_i;
        enemyy3_i <= enemyy3_i;
      
    end
         
end

always @(posedge CLK, posedge arst_i)
begin
if (arst_i)
begin
     espeedx3_i <= 2; 
     espeedy3_i <= 1; 
end
else if (coli3_i)
begin
     espeedx3_i <= 2; 
     espeedy3_i <= 1; 
end
else if (cnt_i == 250000 && level_i == L2 && (enemyx3_i <= 155 || enemyx3_i >= 485))
begin
     espeedx3_i <= -espeedx3_i; 
     espeedy3_i <= espeedy3_i;
end
else if (cnt_i == 250000 && level_i == L2 && (enemyy3_i >= 724 && enemyy3_i <= 1023 || enemyy3_i <= 724 && enemyy3_i >= 479))
begin
     espeedx3_i <= espeedx3_i; 
     espeedy3_i <= -espeedy3_i;
end
else if(level_i == L2)
begin
     espeedx3_i <= espeedx3_i; 
     espeedy3_i <= espeedy3_i; 
end
else if (cnt_i == 250000 && level_i == L1 && (enemyx3_i >= 250 || enemyx3_i <= 200))
begin
     espeedx3_i <= -espeedx3_i; 
     espeedy3_i <= 0;
end

else
begin
     espeedx3_i <= espeedx3_i; 
     espeedy3_i <= espeedy3_i;
end
end
//
//e4
always @ (posedge CLK, posedge arst_i)
begin
    if (arst_i)
    begin
        enemyx4_i <= 369;
        enemyy4_i <= 159;
        
    end 
    else if (allkilled_i) 
    begin
        enemyx4_i <= 300;
        enemyy4_i <= 259;
    end     
    else if ((cnt_i == 249999)&& (level_i == L2)&& (coli4_i==0)) 
    begin
        enemyx4_i <= enemyx4_i + espeedx4_i;
        enemyy4_i <= enemyy4_i + espeedy4_i;
    end     
    else if ((cnt_i == 249999)&& (level_i == L2)&& (coli4_i==1)) 
    begin
        enemyx4_i <= 0;
        enemyy4_i <= 0;
    end     
    else if ((cnt_i == 249999)&& (level_i == L1)&& (coli4_i==0)) 
    begin
        enemyx4_i <= enemyx4_i + espeedx4_i;
        enemyy4_i <= enemyy4_i;
    end     
    else if ((cnt_i == 249999)&& (level_i == L1)&& (coli4_i==1)) 
    begin
        enemyx4_i <= 0;
        enemyy4_i <= 0;
    end     

    else 
    begin
        enemyx4_i <= enemyx4_i;
        enemyy4_i <= enemyy4_i;
      
    end
         
end

always @(posedge CLK, posedge arst_i)
begin
if (arst_i)
begin
     espeedx4_i <= 1; 
     espeedy4_i <= 1; 
end
else if (coli4_i)
begin
     espeedx4_i <= 3; 
     espeedy4_i <= 3; 
end
else if (cnt_i == 250000 && level_i == L2 && (enemyx4_i <= 155 || enemyx4_i >= 485))
begin
     espeedx4_i <= -espeedx4_i; 
     espeedy4_i <= espeedy4_i;
end
else if (cnt_i == 250000 && level_i == L2 && (enemyy4_i >= 724 && enemyy4_i <= 1023 || enemyy4_i <= 724 && enemyy4_i >= 479))
begin
     espeedx4_i <= espeedx4_i; 
     espeedy4_i <= -espeedy4_i;
end
else if(level_i == L2)
begin
     espeedx4_i <= espeedx4_i; 
     espeedy4_i <= espeedy4_i; 
end
else if (cnt_i == 250000 && level_i == L1 && (enemyx4_i >= 419 || enemyx4_i <= 250))
begin
     espeedx4_i <= -espeedx4_i; 
     espeedy4_i <= 0;
end

else
begin
     espeedx4_i <= espeedx4_i; 
     espeedy4_i <= espeedy4_i;
end
end
//
//e5
always @ (posedge CLK, posedge arst_i)
begin
    if (arst_i)
    begin
        enemyx5_i <= 269;
        enemyy5_i <= 119;
        
    end 
    else if (allkilled_i) 
    begin
        enemyx5_i <= 269;
        enemyy5_i <= 219;
    end     
    else if ((cnt_i == 249999)&& (level_i == L2)&& (coli5_i==0)) 
    begin
        enemyx5_i <= enemyx5_i + espeedx5_i;
        enemyy5_i <= enemyy5_i + espeedy5_i;
    end     
    else if ((cnt_i == 249999)&& (level_i == L2)&& (coli5_i==1)) 
    begin
        enemyx5_i <= 0;
        enemyy5_i <= 0;
    end     
    else if ((cnt_i == 249999)&& (level_i == L1)&& (coli5_i==0)) 
    begin
        enemyx5_i <= enemyx5_i + espeedx5_i;
        enemyy5_i <= enemyy5_i;
    end     
    else if ((cnt_i == 249999)&& (level_i == L1)&& (coli5_i==1)) 
    begin
        enemyx5_i <= 0;
        enemyy5_i <= 0;
    end     

    else 
    begin
        enemyx5_i <= enemyx5_i;
        enemyy5_i <= enemyy5_i;
      
    end
         
end

always @(posedge CLK, posedge arst_i)
begin
if (arst_i)
begin
     espeedx5_i <= 1; 
     espeedy5_i <= 1; 
end
else if (coli5_i)
begin
     espeedx5_i <= -3; 
     espeedy5_i <= 3; 
end
else if (cnt_i == 250000 && level_i == L2 && (enemyx5_i <= 155 || enemyx5_i >= 485))
begin
     espeedx5_i <= -espeedx5_i; 
     espeedy5_i <= espeedy5_i;
end
else if (cnt_i == 250000 && level_i == L2 && (enemyy5_i >= 724 && enemyy5_i <= 1023 || enemyy5_i <= 724 && enemyy5_i >= 479))
begin
     espeedx5_i <= espeedx5_i; 
     espeedy5_i <= -espeedy5_i;
end
else if(level_i == L2)
begin
     espeedx5_i <= espeedx5_i; 
     espeedy5_i <= espeedy5_i; 
end
else if (cnt_i == 250000 && level_i == L1 && (enemyx5_i >= 419 || enemyx5_i <= 200))
begin
     espeedx5_i <= -espeedx5_i; 
     espeedy5_i <= 0;
end

else
begin
     espeedx5_i <= espeedx5_i; 
     espeedy5_i <= espeedy5_i;
end
end
//

/////////////////////////////////////////
// this part detect the collision between the bullets and the enemys 
// if all the enemys are destroyed they will be deactivated
always @ (posedge CLK, posedge arst_i)
begin
    if (arst_i)
        coli_i <= 0; 
   else if (allkilled_i)
        coli_i <= 0;   
    else if(((rocketposx_i <= enemyx_i +5) && (rocketposx_i >= enemyx_i -5)&&(rocketposy_i <= enemyy_i +5) && (rocketposy_i >= enemyy_i -5))||
            ((rocketposx2_i <= enemyx_i +5) && (rocketposx2_i >= enemyx_i -5)&&(rocketposy2_i <= enemyy_i +5) && (rocketposy2_i >= enemyy_i -5))) 
        coli_i <=1; 
  
    else 
        coli_i <=coli_i;     
end

always @ (posedge CLK, posedge arst_i)
begin
    if (arst_i)
        coli2_i <= 0; 
    else if (allkilled_i)
            coli2_i <= 0;          
    else if(((rocketposx_i <= enemyx2_i +5) && (rocketposx_i >= enemyx2_i -5)&&(rocketposy_i <= enemyy2_i +5) && (rocketposy_i >= enemyy2_i -5))||
                    ((rocketposx2_i <= enemyx2_i +5) && (rocketposx2_i >= enemyx2_i -5)&&(rocketposy2_i <= enemyy2_i +5) && (rocketposy2_i >= enemyy2_i -5))) 
        coli2_i <=1; 
    else 
        coli2_i <=coli2_i;     
end

always @ (posedge CLK, posedge arst_i)
begin
    if (arst_i)
        coli3_i <= 0; 
    else if (allkilled_i)
        coli3_i <= 0; 
    else if(((rocketposx_i <= enemyx3_i +5) && (rocketposx_i >= enemyx3_i -5)&&(rocketposy_i <= enemyy3_i +5) && (rocketposy_i >= enemyy3_i -5))||
                    ((rocketposx2_i <= enemyx3_i +5) && (rocketposx2_i >= enemyx3_i -5)&&(rocketposy2_i <= enemyy3_i +5) && (rocketposy2_i >= enemyy3_i -5))) 
        coli3_i <=1; 
      
    else 
        coli3_i <=coli3_i;     
end

always @ (posedge CLK, posedge arst_i)
begin
    if (arst_i)
        coli4_i <= 0; 
    else if (allkilled_i)
        coli4_i <= 0; 
    else if(((rocketposx_i <= enemyx4_i +5) && (rocketposx_i >= enemyx4_i -5)&&(rocketposy_i <= enemyy4_i +5) && (rocketposy_i >= enemyy4_i -5))||
                    ((rocketposx2_i <= enemyx4_i +5) && (rocketposx2_i >= enemyx4_i -5)&&(rocketposy2_i <= enemyy4_i +5) && (rocketposy2_i >= enemyy4_i -5))) 
        coli4_i <=1;
           
    else 
        coli4_i <=coli4_i;     
end

always @ (posedge CLK, posedge arst_i)
begin
    if (arst_i)
        coli5_i <= 0; 
    else if (allkilled_i)
         coli5_i <= 0;   
    else if(((rocketposx_i <= enemyx5_i +5) && (rocketposx_i >= enemyx5_i -5)&&(rocketposy_i <= enemyy5_i +5) && (rocketposy_i >= enemyy5_i -5))||
                    ((rocketposx2_i <= enemyx5_i +5) && (rocketposx2_i >= enemyx5_i -5)&&(rocketposy2_i <= enemyy5_i +5) && (rocketposy2_i >= enemyy5_i -5))) 
        coli5_i <=1; 
        
    else 
        coli5_i <=coli5_i;     
end
/////////////////////////////////////////////////////////////////////////////
// this determine whether the bullet hit the enemy for whether to keep displaying the bullet
always @(posedge CLK, posedge arst_i)
begin
    if(arst_i)
        kill_i <=0;
    else if((rocketposy_i >= 752 && rocketposy_i <= 1023))     
        kill_i <= 0;    
    else if(((rocketposx_i <= enemyx_i +5) && (rocketposx_i >= enemyx_i -5)&&(rocketposy_i <= enemyy_i +5) && (rocketposy_i >= enemyy_i -5))
           ||((rocketposx_i <= enemyx2_i +5) && (rocketposx_i >= enemyx2_i -5)&&(rocketposy_i <= enemyy2_i +5) && (rocketposy_i >= enemyy2_i -5))
           ||((rocketposx_i <= enemyx3_i +5) && (rocketposx_i >= enemyx3_i -5)&&(rocketposy_i <= enemyy3_i +5) && (rocketposy_i >= enemyy3_i -5))
           ||((rocketposx_i <= enemyx4_i +5) && (rocketposx_i >= enemyx4_i -5)&&(rocketposy_i <= enemyy4_i +5) && (rocketposy_i >= enemyy4_i -5))
           ||((rocketposx_i <= enemyx5_i +5) && (rocketposx_i >= enemyx5_i -5)&&(rocketposy_i <= enemyy5_i +5) && (rocketposy_i >= enemyy5_i -5))) 
            kill_i <=1;    
    else 
        kill_i <=kill_i;   
end
always @(posedge CLK, posedge arst_i)
begin
    if(arst_i)
        kill2_i <=0;
    else if((rocketposy2_i >= 752 && rocketposy2_i <= 1023))     
        kill2_i <= 0;       
    else if( ((rocketposx2_i <= enemyx_i +5) && (rocketposx2_i >= enemyx_i -5)&&(rocketposy2_i <= enemyy_i +5) && (rocketposy2_i >= enemyy_i -5))
           ||((rocketposx2_i <= enemyx2_i +5) && (rocketposx2_i >= enemyx2_i -5)&&(rocketposy2_i <= enemyy2_i +5) && (rocketposy2_i >= enemyy2_i -5))
           ||((rocketposx2_i <= enemyx3_i +5) && (rocketposx2_i >= enemyx3_i -5)&&(rocketposy2_i <= enemyy3_i +5) && (rocketposy2_i >= enemyy3_i -5))
           ||((rocketposx2_i <= enemyx4_i +5) && (rocketposx2_i >= enemyx4_i -5)&&(rocketposy2_i <= enemyy4_i +5) && (rocketposy2_i >= enemyy4_i -5))
           ||((rocketposx2_i <= enemyx5_i +5) && (rocketposx2_i >= enemyx5_i -5)&&(rocketposy2_i <= enemyy5_i +5) && (rocketposy2_i >= enemyy5_i -5))) 
            kill2_i <=1;    
    else 
        kill2_i <=kill2_i;   
end

/////////////////////////////////////////////////////////////////////////////////////////////
// this part is a statemachine that will determine the position for the explosion effects
// if the bullet hit the enemy, the position of the bullet will be where the bullet was when it hit the enemy
reg [9:0]kxx_i,kxy_i;
parameter [1:0]XS1 = 00;
parameter [1:0]XS2 = 01;
parameter [1:0]XS3 = 10;
reg [1:0]pxs_i,nxs_i;
always@(posedge CLK, posedge arst_i)
begin
    if (arst_i)
        pxs_i <=XS1;
    else 
        pxs_i <= nxs_i;
end

always @ (kill_i,pxs_i)
begin
   case(pxs_i)
   XS1:
   begin
       if (kill_i)
           nxs_i <=XS2;
       else 
           nxs_i <=XS1;
   end
   XS2:
       nxs_i <= S3;
   XS3:
   begin
       if (kill_i)
           nxs_i <=XS3;
       else 
           nxs_i <=XS1;
   end        
   default:
       nxs_i <=XS1;
   endcase
end

always@(posedge CLK, posedge arst_i)
begin
    if(arst_i)
    begin
        kxx_i <=0;
        kxy_i <=0;
    end
    else 
    begin
        case(pxs_i)
        XS1:
        begin
            kxx_i <=0;
            kxy_i <=0;
        end
        XS2:
        begin
            kxx_i <=rocketposx_i;
            kxy_i <=rocketposy_i;
        end
        XS3:
        begin
            kxx_i <=kxx_i;
            kxy_i <=kxy_i;
        end
        default:
        begin
            kxx_i <=0;
            kxy_i <=0;
        end
        endcase    
    end
end

reg [9:0]kxx2_i,kxy2_i;
reg [1:0]pxs2_i,nxs2_i;
always@(posedge CLK, posedge arst_i)
begin
    if (arst_i)
        pxs2_i <=XS1;
    else 
        pxs2_i <= nxs2_i;
end

always @ (kill2_i,pxs2_i)
begin
   case(pxs2_i)
   XS1:
   begin
       if (kill2_i)
           nxs2_i <=XS2;
       else 
           nxs2_i <=XS1;
   end
   XS2:
       nxs2_i <= S3;
   XS3:
   begin
       if (kill2_i)
           nxs2_i <=XS3;
       else 
           nxs2_i <=XS1;
   end        
   default:
       nxs2_i <=XS1;
   endcase
end

always@(posedge CLK, posedge arst_i)
begin
    if (arst_i)
    begin
        kxx2_i <=0;
        kxy2_i <=0;
    end
    else
    begin
        case(pxs2_i)
        XS1:
        begin
            kxx2_i <=0;
            kxy2_i <=0;
        end
        XS2:
        begin
            kxx2_i <=rocketposx2_i;
            kxy2_i <=rocketposy2_i;
        end
        XS3:
        begin
            kxx2_i <=kxx2_i;
            kxy2_i <=kxy2_i;
        end
        default:
        begin
            kxx2_i <=0;
            kxy2_i <=0;
        end
        endcase    
    end
end

always@(posedge CLK, posedge arst_i)
begin
    if(arst_i)
    begin
        epx_i<= 0;
        epy_i <=0;
     end
    else if (kill_i)
    begin
        epx_i <= kxx_i;
        epy_i <= kxy_i;
    end
        else if (kill2_i)
    begin
        epx_i <= kxx2_i;
        epy_i <= kxy2_i;
    end
    else if  (cnt_i==12500)
    begin
         epx_i <= epx_i;
         epy_i <= epy_i;
    end
    else 
    begin
        epx_i<= epx_i;
        epy_i<= epy_i;
    
    end    
end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

// this is the counter for the delay of how long the jet will last for the explosion state
reg [29:0]cntex_i;

always @ (posedge CLK,posedge arst_i)
begin
    if (arst_i)
        cntex_i <=0;
    else if (bekilled_i)
        cntex_i <= cntex_i +1;
    else if (cntex_i == 49999999)
        cntex_i <=0;
    else 
        cntex_i <=0;            
end
// bekilled will be asserted once the enemy hits the jet
// the state will last for a specific amount of time and return back to normal until gameover
always @ (posedge CLK, posedge arst_i)
begin
     if(arst_i)
         bekilled_i <=0; 
     else if(((enemyx_i <= jetposx_i +5) && (enemyx_i >= jetposx_i -5)&&(enemyy_i <= jetposy_i +5) && (enemyy_i >= jetposy_i -5))
         ||((enemyx2_i <= jetposx_i +5) && (enemyx2_i >= jetposx_i -5)&&(enemyy2_i <= jetposy_i +5) && (enemyy2_i >= jetposy_i -5))
         ||((enemyx3_i <= jetposx_i +5) && (enemyx3_i >= jetposx_i -5)&&(enemyy3_i <= jetposy_i +5) && (enemyy3_i >= jetposy_i -5))
         ||((enemyx4_i <= jetposx_i +5) && (enemyx4_i >= jetposx_i -5)&&(enemyy4_i <= jetposy_i +5) && (enemyy4_i >= jetposy_i -5))
         ||((enemyx5_i <= jetposx_i +5) && (enemyx5_i >= jetposx_i -5)&&(enemyy5_i <= jetposy_i +5) && (enemyy5_i >= jetposy_i -5)))
         bekilled_i <= 1;
     else if (cntex_i == 49999999)    
         bekilled_i <=0;
     else
         bekilled_i<=bekilled_i;
end
// this state machine determine where the jet explode
reg [9:0]kxx_i3,kxy_i3;
reg [1:0]pxs_i3,nxs_i3;
always@(posedge CLK, posedge arst_i)
begin
    if (arst_i)
        pxs_i3 <=XS1;
    else 
        pxs_i3 <= nxs_i3;
end

always @ (bekilled_i,pxs_i3)
begin
   case(pxs_i3)
   XS1:
   begin
       if (bekilled_i)
           nxs_i3 <=XS2;
       else 
           nxs_i3 <=XS1;
   end
   XS2:
       nxs_i3 <= S3;
   XS3:
   begin
       if (bekilled_i)
           nxs_i3 <=XS3;
       else 
           nxs_i3 <=XS1;
   end        
   default:
       nxs_i3 <=XS1;
   endcase
end

always@(posedge CLK, posedge arst_i)
begin
    if (arst_i)
    begin
        kxx_i3 <=0;
        kxy_i3 <=0;
    end
    else
    begin
        case(pxs_i3)
        XS1:
        begin
            kxx_i3 <=0;
            kxy_i3 <=0;
        end
        XS2:
        begin
            kxx_i3 <=jetposx_i;
            kxy_i3 <=jetposy_i;
        end
        XS3:
        begin
            kxx_i3 <=kxx_i3;
            kxy_i3 <=kxy_i3;
        end
        default:
        begin
            kxx_i3 <=0;
            kxy_i3 <=0;
        end
        endcase    
    end
end


always@(posedge CLK, posedge arst_i)
begin
    if(arst_i)
    begin
        jepx_i_i<= 0;
        jepy_i_i <=0;
     end
    else if (bekilled_i)
    begin
        jepx_i_i <= kxx_i3;
        jepy_i_i <= kxy_i3;
    end
    else 
    begin
        jepx_i_i<= jepx_i_i;
        jepy_i_i<= jepy_i_i;
    
    end    
end
////////////////////////////////////////////////////////////////////////////

// this statemachine determines whether the game is over, it has four states
// it will change states when the jet is killed 
// once entering into the last state, the state will just hold in there and asert the gameover signal
reg [1:0]gops_i, gons_i;

parameter [1:0] go1 =00;
parameter [1:0] go2 =01;
parameter [1:0] go3 =10;
parameter [1:0] go4 =11;
always @ (posedge CLK, posedge arst_i)
begin
    if(arst_i)
        gops_i <= go1;
    else 
        gops_i <= gons_i;    
end

always @ (bekilled_i, gops_i, cntex_i)
begin
    case(gops_i)
    go1:
    begin
        if(bekilled_i && cntex_i == 14999999)
        begin
            gons_i <= go2;
        end    
        else 
        begin
            gons_i <= go1;   
        end     
    end
    go2:
    begin
        if(bekilled_i && cntex_i == 14999999)
        begin
            gons_i <= go3;
        end    
        else 
        begin
            gons_i <= go2;   
        end     
    end
    go3:
    begin
        if(bekilled_i&& cntex_i == 14999999)
        begin
            gons_i <= go4;
        end    
        else 
        begin
            gons_i <= go3;   
        end     
    end
    go4:
    begin
        if(bekilled_i && cntex_i == 14999999)
        begin
            gons_i <= go4;
        end    
        else 
        begin
            gons_i <= go4;   
        end     
    end
    default:
    begin
        gons_i <= go1;    
    end
    endcase
end

assign gameover_i = (gops_i == go4)? 1'b1:1'b0;



// This always blocks output the proper color code according to the Coordinate count and the logic for the positions of the objects
always @ (posedge CLK, posedge arst_i)
begin 
    if (arst_i || (gameover_i==1))
        CSEL <= 12'b000000000000;
    else if( (gameover_i ==0 )&&((((bekilled_i))&& (HCOORD== jepx_i_i) && (VCOORD == jepy_i_i))
              || ((bekilled_i)&& (HCOORD== jepx_i_i+1) && (VCOORD == jepy_i_i)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-1) && (VCOORD == jepy_i_i)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i) && (VCOORD == jepy_i_i +1)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i) && (VCOORD == jepy_i_i-1))
              || ((bekilled_i)&& (HCOORD== jepx_i_i+4) && (VCOORD == jepy_i_i)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-4) && (VCOORD == jepy_i_i)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i) && (VCOORD == jepy_i_i +4)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i) && (VCOORD == jepy_i_i-4))
              || ((bekilled_i)&& (HCOORD== jepx_i_i+3) && (VCOORD == jepy_i_i)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-3) && (VCOORD == jepy_i_i)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i) && (VCOORD == jepy_i_i +3)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i) && (VCOORD == jepy_i_i-3))
              || ((bekilled_i)&& (HCOORD== jepx_i_i+2) && (VCOORD == jepy_i_i+3)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-3) && (VCOORD == jepy_i_i+2)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-2) && (VCOORD == jepy_i_i-3)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i+3) && (VCOORD == jepy_i_i -2))
              || ((bekilled_i)&& (HCOORD== jepx_i_i+2) && (VCOORD == jepy_i_i+2)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-2) && (VCOORD == jepy_i_i+2)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-2) && (VCOORD == jepy_i_i-2)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i+2) && (VCOORD == jepy_i_i -2))
              || ((bekilled_i)&& (HCOORD== jepx_i_i+4) && (VCOORD == jepy_i_i+4)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-4) && (VCOORD == jepy_i_i+4)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-4) && (VCOORD == jepy_i_i-4)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i+4) && (VCOORD == jepy_i_i -4))
              || ((bekilled_i)&& (HCOORD== jepx_i_i+3) && (VCOORD == jepy_i_i+3)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-3) && (VCOORD == jepy_i_i+3)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-3) && (VCOORD == jepy_i_i-3)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i+3) && (VCOORD == jepy_i_i -3))
              || ((bekilled_i)&& (HCOORD== jepx_i_i+5) && (VCOORD == jepy_i_i)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-5) && (VCOORD == jepy_i_i)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i) && (VCOORD == jepy_i_i +5)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i) && (VCOORD == jepy_i_i-5))
              || ((bekilled_i)&& (HCOORD== jepx_i_i+6) && (VCOORD == jepy_i_i+6)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-6) && (VCOORD == jepy_i_i+6)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-6) && (VCOORD == jepy_i_i-6)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i+6) && (VCOORD == jepy_i_i -6))
              || ((bekilled_i)&& (HCOORD== jepx_i_i+7) && (VCOORD == jepy_i_i+7)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-7) && (VCOORD == jepy_i_i+7)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-7) && (VCOORD == jepy_i_i-7)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i+7) && (VCOORD == jepy_i_i -7))
              || ((bekilled_i)&& (HCOORD== jepx_i_i+8) && (VCOORD == jepy_i_i+8)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-8) && (VCOORD == jepy_i_i+8)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-8) && (VCOORD == jepy_i_i-8)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i+8) && (VCOORD == jepy_i_i -8))
              || ((bekilled_i)&& (HCOORD== jepx_i_i+9) && (VCOORD == jepy_i_i)) 
              || ((bekilled_i)&& (HCOORD== jepx_i_i-9) && (VCOORD == jepy_i_i))))    
          CSEL <= 12'b111111111101;                               
    else if((gameover_i ==0 )&&((bekilled_i == 0)&&((HCOORD >= jetposx_i-1 && HCOORD <= jetposx_i+1) &&(VCOORD >= jetposy_i-12 && VCOORD <= jetposy_i+8)
        ||(HCOORD >= jetposx2_i-1 && HCOORD <= jetposx2_i+1) &&(VCOORD >= jetposy2_i-8 && VCOORD <= jetposy2_i+4)
        ||(HCOORD >= jetposx3_i-1 && HCOORD <= jetposx3_i+1) &&(VCOORD >= jetposy3_i-2 && VCOORD <= jetposy3_i+2)
        ||(HCOORD >= jetposx4_i-1 && HCOORD <= jetposx4_i+1) &&(VCOORD >= jetposy4_i && VCOORD <= jetposy4_i+4)
        ||(HCOORD >= jetposx5_i-1 && HCOORD <= jetposx5_i+1) &&( VCOORD >= jetposy5_i &&VCOORD <= jetposy5_i+6 )
        ||(HCOORD >= jetposx6_i-1 && HCOORD <= jetposx6_i+1) &&(VCOORD >= jetposy6_i && VCOORD <= jetposy6_i+5)
        ||(HCOORD >= jetposx7_i-1 && HCOORD <= jetposx7_i+1) &&(VCOORD >= jetposy7_i-8 && VCOORD <= jetposy7_i+4)
        ||(HCOORD >= jetposx8_i-1 && HCOORD <= jetposx8_i+1) &&(VCOORD >= jetposy8_i-2 && VCOORD <= jetposy8_i+2)
        ||(HCOORD >= jetposx9_i-1 && HCOORD <= jetposx9_i+1) &&(VCOORD >= jetposy9_i && VCOORD <= jetposy9_i+4)
        ||(HCOORD >= jetposx10_i-1 && HCOORD <= jetposx10_i+1) &&( VCOORD >= jetposy10_i &&VCOORD <= jetposy10_i+6)
        ||(HCOORD >= jetposx11_i-1 && HCOORD <= jetposx11_i+1) &&(VCOORD >= jetposy11_i && VCOORD <= jetposy11_i+5))
        || (HCOORD <= 155 && HCOORD >=145) || (HCOORD >= 485 && HCOORD<=495)))
        CSEL <= 12'b111111111111;
     else if ( (gameover_i ==0 )&&(((coli_i == 0)&&(((HCOORD <= enemyx_i + 1) && (HCOORD >= enemyx_i - 1)))&&((VCOORD <= enemyy_i + 10) && (VCOORD >= enemyy_i - 10)))
        ||  ((coli_i == 0)&&(((HCOORD <= enemyx_i+6 + 1) && (HCOORD >= enemyx_i+6 - 1)))&&((VCOORD <= enemyy_i + 1) && (VCOORD >= enemyy_i-10)))
        ||  ((coli_i == 0)&&(((HCOORD <= enemyx_i-6 + 1) && (HCOORD >= enemyx_i-6 - 1)))&&((VCOORD <= enemyy_i + 1) && (VCOORD >= enemyy_i-10)))
        || ((coli2_i == 0)&&(((HCOORD <= enemyx2_i + 1) && (HCOORD >= enemyx2_i - 1)))&&((VCOORD <= enemyy2_i + 10) && (VCOORD >= enemyy2_i - 10)))
        ||  ((coli2_i == 0)&&(((HCOORD <= enemyx2_i+6 + 1) && (HCOORD >= enemyx2_i+6 - 1)))&&((VCOORD <= enemyy2_i + 1) && (VCOORD >= enemyy2_i-10)))
        ||  ((coli2_i == 0)&&(((HCOORD <= enemyx2_i-6 + 1) && (HCOORD >= enemyx2_i-6 - 1)))&&((VCOORD <= enemyy2_i + 1) && (VCOORD >= enemyy2_i-10)))
        || ((coli3_i == 0)&&(((HCOORD <= enemyx3_i + 1) && (HCOORD >= enemyx3_i - 1)))&&((VCOORD <= enemyy3_i + 10) && (VCOORD >= enemyy3_i - 10)))
        ||  ((coli3_i == 0)&&(((HCOORD <= enemyx3_i+6 + 1) && (HCOORD >= enemyx3_i+6 - 1)))&&((VCOORD <= enemyy3_i + 1) && (VCOORD >= enemyy3_i-10)))
        ||  ((coli3_i == 0)&&(((HCOORD <= enemyx3_i-6 + 1) && (HCOORD >= enemyx3_i-6 - 1)))&&((VCOORD <= enemyy3_i + 1) && (VCOORD >= enemyy3_i-10)))
        ||  ((coli4_i == 0)&&(((HCOORD <= enemyx4_i-3 + 1) && (HCOORD >= enemyx4_i-3 - 1)))&&((VCOORD <= enemyy4_i + 4) && (VCOORD >= enemyy4_i - 4)))
        ||  ((coli4_i == 0)&&(((HCOORD <= enemyx4_i+3 + 1) && (HCOORD >= enemyx4_i+3 - 1)))&&((VCOORD <= enemyy4_i + 4) && (VCOORD >= enemyy4_i - 4)))
        ||  ((coli5_i == 0)&&(((HCOORD <= enemyx5_i-3 + 1) && (HCOORD >= enemyx5_i-3 - 1)))&&((VCOORD <= enemyy5_i + 4) && (VCOORD >= enemyy5_i - 4)))
        ||  ((coli5_i == 0)&&(((HCOORD <= enemyx5_i+3 + 1) && (HCOORD >= enemyx5_i+3 - 1)))&&((VCOORD <= enemyy5_i + 4) && (VCOORD >= enemyy5_i - 4)))))  
        CSEL <= 12'b000000001111;
     else if ((gameover_i ==0 )&&(((bekilled_i ==0)&&((VCOORD <= jetposy5_i &&VCOORD >= jetposy5_i-4) &&(HCOORD >= jetposx5_i-1 && HCOORD <= jetposx5_i+1) 
       ||(VCOORD <= jetposy10_i &&VCOORD >= jetposy10_i-4) &&(HCOORD >= jetposx10_i-1 && HCOORD <= jetposx10_i+1))) 
       || ((kill_i == 0)&&(shoot_i==1)&&(HCOORD >=  rocketposx_i-1 && HCOORD <=  rocketposx_i+1) &&(VCOORD >=  rocketposy_i-2 && VCOORD <=  rocketposy_i+2))
       || ((kill2_i == 0)&&(shoot2_i==1)&&(HCOORD >=  rocketposx2_i-1 && HCOORD <=  rocketposx2_i+1) &&(VCOORD >=  rocketposy2_i-2 && VCOORD <=  rocketposy2_i+2))
       ||  ((coli_i == 0)&&(((HCOORD <= enemyx_i-3 + 1) && (HCOORD >= enemyx_i-3 - 1)))&&((VCOORD <= enemyy_i + 4) && (VCOORD >= enemyy_i - 4)))
       ||  ((coli_i == 0)&&(((HCOORD <= enemyx_i+3 + 1) && (HCOORD >= enemyx_i+3 - 1)))&&((VCOORD <= enemyy_i + 4) && (VCOORD >= enemyy_i - 4)))
       ||  ((coli2_i == 0)&&(((HCOORD <= enemyx2_i-3 + 1) && (HCOORD >= enemyx2_i-3 - 1)))&&((VCOORD <= enemyy2_i + 4) && (VCOORD >= enemyy2_i - 4)))
       ||  ((coli2_i == 0)&&(((HCOORD <= enemyx2_i+3 + 1) && (HCOORD >= enemyx2_i+3 - 1)))&&((VCOORD <= enemyy2_i + 4) && (VCOORD >= enemyy2_i - 4)))
       ||  ((coli3_i == 0)&&(((HCOORD <= enemyx3_i-3 + 1) && (HCOORD >= enemyx3_i-3 - 1)))&&((VCOORD <= enemyy3_i + 4) && (VCOORD >= enemyy3_i - 4)))
       ||  ((coli3_i == 0)&&(((HCOORD <= enemyx3_i+3 + 1) && (HCOORD >= enemyx3_i+3 - 1)))&&((VCOORD <= enemyy3_i + 4) && (VCOORD >= enemyy3_i - 4)))
       || ((coli4_i == 0)&&(((HCOORD <= enemyx4_i + 1) && (HCOORD >= enemyx4_i - 1)))&&((VCOORD <= enemyy4_i + 10) && (VCOORD >= enemyy4_i - 10)))
       ||  ((coli4_i == 0)&&(((HCOORD <= enemyx4_i+6 + 1) && (HCOORD >= enemyx4_i+6 - 1)))&&((VCOORD <= enemyy4_i + 1) && (VCOORD >= enemyy4_i-10)))
       ||  ((coli4_i == 0)&&(((HCOORD <= enemyx4_i-6 + 1) && (HCOORD >= enemyx4_i-6 - 1)))&&((VCOORD <= enemyy4_i + 1) && (VCOORD >= enemyy4_i-10)))
       || ((coli5_i == 0)&&(((HCOORD <= enemyx5_i + 1) && (HCOORD >= enemyx5_i - 1)))&&((VCOORD <= enemyy5_i + 10) && (VCOORD >= enemyy5_i - 10)))
       ||  ((coli5_i == 0)&&(((HCOORD <= enemyx5_i+6 + 1) && (HCOORD >= enemyx5_i+6 - 1)))&&((VCOORD <= enemyy5_i + 1) && (VCOORD >= enemyy5_i-10)))
       ||  ((coli5_i == 0)&&(((HCOORD <= enemyx5_i-6 + 1) && (HCOORD >= enemyx5_i-6 - 1)))&&((VCOORD <= enemyy5_i + 1) && (VCOORD >= enemyy5_i-10)))))
         CSEL <= 12'b111100000000;
    else if( (gameover_i ==0 )&&(((kill_i == 1)&&(shoot_i==1)&&(HCOORD >=  rocketposx_i-1 && HCOORD <=  rocketposx_i+1) &&(VCOORD >=  rocketposy_i-2 && VCOORD <=  rocketposy_i+2))
         || ((kill2_i == 1)&&(shoot2_i==1)&&(HCOORD >=  rocketposx2_i-1 && HCOORD <=  rocketposx2_i+1) &&(VCOORD >=  rocketposy2_i-2 && VCOORD <=  rocketposy2_i+2))
         ||  ((coli_i == 1)&&(((HCOORD <= enemyx_i + 1) && (HCOORD >= enemyx_i - 1)))&&((VCOORD <= enemyy_i + 10) && (VCOORD >= enemyy_i - 10)))
         ||  ((coli_i == 1)&&(((HCOORD <= enemyx_i+3 + 1) && (HCOORD >= enemyx_i+3 - 1)))&&((VCOORD <= enemyy_i + 4) && (VCOORD >= enemyy_i - 4)))
         ||  ((coli_i == 1)&&(((HCOORD <= enemyx_i+6 + 1) && (HCOORD >= enemyx_i+6 - 1)))&&((VCOORD <= enemyy_i + 1) && (VCOORD >= enemyy_i-10)))
         ||  ((coli_i == 1)&&(((HCOORD <= enemyx_i-3 + 1) && (HCOORD >= enemyx_i-3 - 1)))&&((VCOORD <= enemyy_i + 4) && (VCOORD >= enemyy_i - 4)))
         ||  ((coli_i == 1)&&(((HCOORD <= enemyx_i-6 + 1) && (HCOORD >= enemyx_i-6 - 1)))&&((VCOORD <= enemyy_i + 1) && (VCOORD >= enemyy_i-10)))
         ||  ((coli2_i == 1)&&(((HCOORD <= enemyx2_i + 1) && (HCOORD >= enemyx2_i - 1)))&&((VCOORD <= enemyy2_i + 10) && (VCOORD >= enemyy2_i - 10)))
         ||  ((coli2_i == 1)&&(((HCOORD <= enemyx2_i+3 + 1) && (HCOORD >= enemyx2_i+3 - 1)))&&((VCOORD <= enemyy2_i + 4) && (VCOORD >= enemyy2_i - 4)))
         ||  ((coli2_i == 1)&&(((HCOORD <= enemyx2_i+6 + 1) && (HCOORD >= enemyx2_i+6 - 1)))&&((VCOORD <= enemyy2_i + 1) && (VCOORD >= enemyy2_i-10)))
         ||  ((coli2_i == 1)&&(((HCOORD <= enemyx2_i-3 + 1) && (HCOORD >= enemyx2_i-3 - 1)))&&((VCOORD <= enemyy2_i + 4) && (VCOORD >= enemyy2_i - 4)))
         ||  ((coli2_i == 1)&&(((HCOORD <= enemyx2_i-6 + 1) && (HCOORD >= enemyx2_i-6 - 1)))&&((VCOORD <= enemyy2_i + 1) && (VCOORD >= enemyy2_i-10)))
         ||  ((coli3_i == 1)&&(((HCOORD <= enemyx3_i + 1) && (HCOORD >= enemyx3_i - 1)))&&((VCOORD <= enemyy3_i + 10) && (VCOORD >= enemyy3_i - 10)))
         ||  ((coli3_i == 1)&&(((HCOORD <= enemyx3_i+3 + 1) && (HCOORD >= enemyx3_i+3 - 1)))&&((VCOORD <= enemyy3_i + 4) && (VCOORD >= enemyy3_i - 4)))
         ||  ((coli3_i == 1)&&(((HCOORD <= enemyx3_i+6 + 1) && (HCOORD >= enemyx3_i+6 - 1)))&&((VCOORD <= enemyy3_i + 1) && (VCOORD >= enemyy3_i-10)))
         ||  ((coli3_i == 1)&&(((HCOORD <= enemyx3_i-3 + 1) && (HCOORD >= enemyx3_i-3 - 1)))&&((VCOORD <= enemyy3_i + 4) && (VCOORD >= enemyy3_i - 4)))
         ||  ((coli3_i == 1)&&(((HCOORD <= enemyx3_i-6 + 1) && (HCOORD >= enemyx3_i-6 - 1)))&&((VCOORD <= enemyy3_i + 1) && (VCOORD >= enemyy3_i-10)))
         ||  ((coli4_i == 1)&&(((HCOORD <= enemyx4_i + 1) && (HCOORD >= enemyx4_i - 1)))&&((VCOORD <= enemyy4_i + 10) && (VCOORD >= enemyy4_i - 10)))
         ||  ((coli4_i == 1)&&(((HCOORD <= enemyx4_i+3 + 1) && (HCOORD >= enemyx4_i+3 - 1)))&&((VCOORD <= enemyy4_i + 4) && (VCOORD >= enemyy4_i - 4)))
         ||  ((coli4_i == 1)&&(((HCOORD <= enemyx4_i+6 + 1) && (HCOORD >= enemyx4_i+6 - 1)))&&((VCOORD <= enemyy4_i + 1) && (VCOORD >= enemyy4_i-10)))
         ||  ((coli4_i == 1)&&(((HCOORD <= enemyx4_i-3 + 1) && (HCOORD >= enemyx4_i-3 - 1)))&&((VCOORD <= enemyy4_i + 4) && (VCOORD >= enemyy4_i - 4)))
         ||  ((coli4_i == 1)&&(((HCOORD <= enemyx4_i-6 + 1) && (HCOORD >= enemyx4_i-6 - 1)))&&((VCOORD <= enemyy4_i + 1) && (VCOORD >= enemyy4_i-10)))
         ||  ((coli5_i == 1)&&(((HCOORD <= enemyx5_i + 1) && (HCOORD >= enemyx5_i - 1)))&&((VCOORD <= enemyy5_i + 10) && (VCOORD >= enemyy5_i - 10)))
         ||  ((coli5_i == 1)&&(((HCOORD <= enemyx5_i+3 + 1) && (HCOORD >= enemyx5_i+3 - 1)))&&((VCOORD <= enemyy5_i + 4) && (VCOORD >= enemyy5_i - 4)))
         ||  ((coli5_i == 1)&&(((HCOORD <= enemyx5_i+6 + 1) && (HCOORD >= enemyx5_i+6 - 1)))&&((VCOORD <= enemyy5_i + 1) && (VCOORD >= enemyy5_i-10)))
         ||  ((coli5_i == 1)&&(((HCOORD <= enemyx5_i-3 + 1) && (HCOORD >= enemyx5_i-3 - 1)))&&((VCOORD <= enemyy5_i + 4) && (VCOORD >= enemyy5_i - 4)))
         ||  ((coli5_i == 1)&&(((HCOORD <= enemyx5_i-6 + 1) && (HCOORD >= enemyx5_i-6 - 1)))&&((VCOORD <= enemyy5_i + 1) && (VCOORD >= enemyy5_i-10)))
         || ((bekilled_i == 1)&&((HCOORD >= jetposx_i-1 && HCOORD <= jetposx_i+1) &&(VCOORD >= jetposy_i-12 && VCOORD <= jetposy_i+8)
         ||(HCOORD >= jetposx2_i-1 && HCOORD <= jetposx2_i+1) &&(VCOORD >= jetposy2_i-8 && VCOORD <= jetposy2_i+4)
         ||(HCOORD >= jetposx3_i-1 && HCOORD <= jetposx3_i+1) &&(VCOORD >= jetposy3_i-2 && VCOORD <= jetposy3_i+2)
         ||(HCOORD >= jetposx4_i-1 && HCOORD <= jetposx4_i+1) &&(VCOORD >= jetposy4_i && VCOORD <= jetposy4_i+4)
         ||(HCOORD >= jetposx5_i-1 && HCOORD <= jetposx5_i+1) &&( VCOORD >= jetposy5_i &&VCOORD <= jetposy5_i+6 )
         ||(HCOORD >= jetposx6_i-1 && HCOORD <= jetposx6_i+1) &&(VCOORD >= jetposy6_i && VCOORD <= jetposy6_i+5)
         ||(HCOORD >= jetposx7_i-1 && HCOORD <= jetposx7_i+1) &&(VCOORD >= jetposy7_i-8 && VCOORD <= jetposy7_i+4)
         ||(HCOORD >= jetposx8_i-1 && HCOORD <= jetposx8_i+1) &&(VCOORD >= jetposy8_i-2 && VCOORD <= jetposy8_i+2)
         ||(HCOORD >= jetposx9_i-1 && HCOORD <= jetposx9_i+1) &&(VCOORD >= jetposy9_i && VCOORD <= jetposy9_i+4)
         ||(HCOORD >= jetposx10_i-1 && HCOORD <= jetposx10_i+1) &&( VCOORD >= jetposy10_i &&VCOORD <= jetposy10_i+6)
         ||(HCOORD >= jetposx11_i-1 && HCOORD <= jetposx11_i+1) &&(VCOORD >= jetposy11_i && VCOORD <= jetposy11_i+5)
         || (HCOORD <= 155 && HCOORD >=145) || (HCOORD >= 485 && HCOORD<=495)))))
             CSEL <= 12'b000000000000;
    else if ((gameover_i ==0 )&&((((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i) && (VCOORD == epy_i)) 
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i+3) && (VCOORD == epy_i)) 
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i-3) && (VCOORD == epy_i)) 
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i) && (VCOORD == epy_i +3)) 
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i) && (VCOORD == epy_i-3))
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i+2) && (VCOORD == epy_i+2)) 
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i-2) && (VCOORD == epy_i+2)) 
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i-2) && (VCOORD == epy_i-2)) 
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i+2) && (VCOORD == epy_i -2))
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i+4) && (VCOORD == epy_i+4)) 
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i-4) && (VCOORD == epy_i+4)) 
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i-4) && (VCOORD == epy_i-4)) 
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i+4) && (VCOORD == epy_i -4))
              ||(((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i+3) && (VCOORD == epy_i+3)) 
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i-3) && (VCOORD == epy_i+3)) 
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i-3) && (VCOORD == epy_i-3)) 
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i+3) && (VCOORD == epy_i -3))
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i+5) && (VCOORD == epy_i)) 
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i-5) && (VCOORD == epy_i)) 
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i) && (VCOORD == epy_i +5)) 
              || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i) && (VCOORD == epy_i-5))
               ||(((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i+6) && (VCOORD == epy_i+6)) 
               || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i-6) && (VCOORD == epy_i+6)) 
               || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i-6) && (VCOORD == epy_i-6)) 
               || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i+6) && (VCOORD == epy_i -6))
               || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i+7) && (VCOORD == epy_i+7)) 
               || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i-7) && (VCOORD == epy_i+7)) 
               || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i-7) && (VCOORD == epy_i-7)) 
               || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i+7) && (VCOORD == epy_i -7))
               ||(((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i+8) && (VCOORD == epy_i+8)) 
               || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i-8) && (VCOORD == epy_i+8)) 
               || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i-8) && (VCOORD == epy_i-8)) 
               || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i+8) && (VCOORD == epy_i -8))
               || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i+9) && (VCOORD == epy_i)) 
               || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i-9) && (VCOORD == epy_i))
               || (((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i) && (VCOORD == epy_i +9)) 
               ||(((kill_i ==1)||(kill2_i ==1))&& (HCOORD== epx_i) && (VCOORD == epy_i-9))))
              CSEL <= 12'b111111111000;
    else if ((gameover_i== 0) && ((HCOORD == starx_i)&&(VCOORD == stary_i) 
             || (HCOORD == starx_i +10 )&&(VCOORD == stary_i+4) || (HCOORD == starx_i +25 )&&(VCOORD == stary_i+14) 
             || (HCOORD == starx_i +30 )&&(VCOORD == stary_i+1) || (HCOORD == starx_i +40 )&&(VCOORD == stary_i+9) 
             || (HCOORD == starx_i +50 )&&(VCOORD == stary_i+5) || (HCOORD == starx_i +66 )&&(VCOORD == stary_i+13) 
             || (HCOORD == starx_i +70 )&&(VCOORD == stary_i+18) || (HCOORD == starx_i +140 )&&(VCOORD == stary_i) 
             || (HCOORD == starx_i +137 )&&(VCOORD == stary_i) || (HCOORD == starx_i +155 )&&(VCOORD == stary_i+16)
             || (HCOORD == starx_i -8 )&&(VCOORD == stary_i+20) || (HCOORD == starx_i -10 )&&(VCOORD == stary_i) 
             || (HCOORD == starx_i -30 )&&(VCOORD == stary_i) || (HCOORD == starx_i -39 )&&(VCOORD == stary_i+17) 
             || (HCOORD == starx_i -44 )&&(VCOORD == stary_i+4) || (HCOORD == starx_i -120 )&&(VCOORD == stary_i) 
             || (HCOORD == starx_i -73 )&&(VCOORD == stary_i+1) || (HCOORD == starx_i -80 )&&(VCOORD == stary_i+3) 
             || (HCOORD == starx_i -1350 )&&(VCOORD == stary_i) || (HCOORD == starx_i -168 )&&(VCOORD == stary_i) 
             || (HCOORD == starx_i +10 )&&(VCOORD == stary_i - 3) || (HCOORD == starx_i +25 )&&(VCOORD == stary_i-3) 
             || (HCOORD == starx_i +30 )&&(VCOORD == stary_i-4) || (HCOORD == starx_i +40 )&&(VCOORD == stary_i-2) 
             || (HCOORD == starx_i +50 )&&(VCOORD == stary_i-5) || (HCOORD == starx_i +66 )&&(VCOORD == stary_i-3) 
             || (HCOORD == starx_i +70 )&&(VCOORD == stary_i-8) || (HCOORD == starx_i +140 )&&(VCOORD == stary_i-9) 
             || (HCOORD == starx_i +137 )&&(VCOORD == stary_i-13) || (HCOORD == starx_i +155 )&&(VCOORD == stary_i-2)
             || (HCOORD == starx_i -8 )&&(VCOORD == stary_i-14) || (HCOORD == starx_i -10 )&&(VCOORD == stary_i-17) 
             || (HCOORD == starx_i -30 )&&(VCOORD == stary_i-13) || (HCOORD == starx_i -39 )&&(VCOORD == stary_i-19) 
             || (HCOORD == starx_i -44 )&&(VCOORD == stary_i-17) || (HCOORD == starx_i -120 )&&(VCOORD == stary_i-20) 
             || (HCOORD == starx_i -73 )&&(VCOORD == stary_i-19) || (HCOORD == starx_i -80 )&&(VCOORD == stary_i-14) 
             || (HCOORD == starx_i -135 )&&(VCOORD == stary_i-7) || (HCOORD == starx_i -168 )&&(VCOORD == stary_i-11)
             || (HCOORD == starx_i +30 )&&(VCOORD == stary_i+44) || (HCOORD == starx_i +75 )&&(VCOORD == stary_i+84) 
             || (HCOORD == starx_i +75 )&&(VCOORD == stary_i+81) || (HCOORD == starx_i +160 )&&(VCOORD == stary_i+29) 
             || (HCOORD == starx_i +70 )&&(VCOORD == stary_i+85) || (HCOORD == starx_i +69 )&&(VCOORD == stary_i+53) 
             || (HCOORD == starx_i +120 )&&(VCOORD == stary_i+98) || (HCOORD == starx_i +130 )&&(VCOORD == stary_i+39) 
             || (HCOORD == starx_i +137 )&&(VCOORD == stary_i+156) || (HCOORD == starx_i +155 )&&(VCOORD == stary_i+66)
             || (HCOORD == starx_i -89 )&&(VCOORD == stary_i+130) || (HCOORD == starx_i -20 )&&(VCOORD == stary_i+79) 
             || (HCOORD == starx_i -130 )&&(VCOORD == stary_i+57) || (HCOORD == starx_i -39 )&&(VCOORD == stary_i+97) 
             || (HCOORD == starx_i -124 )&&(VCOORD == stary_i+48) || (HCOORD == starx_i -10 )&&(VCOORD == stary_i+133) 
             || (HCOORD == starx_i -153 )&&(VCOORD == stary_i+14) || (HCOORD == starx_i -50 )&&(VCOORD == stary_i+137) 
             || (HCOORD == starx_i -35 )&&(VCOORD == stary_i+135) || (HCOORD == starx_i -148 )&&(VCOORD == stary_i-47) 
             || (HCOORD == starx_i +16 )&&(VCOORD == stary_i - 83) || (HCOORD == starx_i +125 )&&(VCOORD == stary_i-79) 
             || (HCOORD == starx_i +80 )&&(VCOORD == stary_i-24) || (HCOORD == starx_i +43 )&&(VCOORD == stary_i-127) 
             || (HCOORD == starx_i +57 )&&(VCOORD == stary_i-125) || (HCOORD == starx_i +96 )&&(VCOORD == stary_i-103) 
             || (HCOORD == starx_i +77 )&&(VCOORD == stary_i-85) || (HCOORD == starx_i +149 )&&(VCOORD == stary_i-169) 
             || (HCOORD == starx_i +147 )&&(VCOORD == stary_i-143) || (HCOORD == starx_i +102 )&&(VCOORD == stary_i-132)
             || (HCOORD == starx_i -89 )&&(VCOORD == stary_i-44) || (HCOORD == starx_i -110 )&&(VCOORD == stary_i-97) 
             || (HCOORD == starx_i -31 )&&(VCOORD == stary_i-33) || (HCOORD == starx_i -29 )&&(VCOORD == stary_i-79) 
             || (HCOORD == starx_i -44 )&&(VCOORD == stary_i-57) || (HCOORD == starx_i -130 )&&(VCOORD == stary_i-25) 
             || (HCOORD == starx_i -74 )&&(VCOORD == stary_i-79) || (HCOORD == starx_i -89 )&&(VCOORD == stary_i-44) 
             || (HCOORD == starx_i -165 )&&(VCOORD == stary_i-37) || (HCOORD == starx_i -148 )&&(VCOORD == stary_i-111)
             ||(HCOORD == starx2_i)&&(VCOORD == stary2_i) 
              || (HCOORD == starx2_i +10 )&&(VCOORD == stary2_i+4) || (HCOORD == starx2_i +25 )&&(VCOORD == stary2_i+14) 
              || (HCOORD == starx2_i +30 )&&(VCOORD == stary2_i+1) || (HCOORD == starx2_i +40 )&&(VCOORD == stary2_i+9) 
              || (HCOORD == starx2_i +50 )&&(VCOORD == stary2_i+5) || (HCOORD == starx2_i +66 )&&(VCOORD == stary2_i+13) 
              || (HCOORD == starx2_i +70 )&&(VCOORD == stary2_i+18) || (HCOORD == starx2_i +140 )&&(VCOORD == stary2_i) 
              || (HCOORD == starx2_i +137 )&&(VCOORD == stary2_i) || (HCOORD == starx2_i +155 )&&(VCOORD == stary2_i+16)
              || (HCOORD == starx2_i -8 )&&(VCOORD == stary2_i+20) || (HCOORD == starx2_i -10 )&&(VCOORD == stary2_i) 
              || (HCOORD == starx2_i -30 )&&(VCOORD == stary2_i) || (HCOORD == starx2_i -39 )&&(VCOORD == stary2_i+17) 
              || (HCOORD == starx2_i -44 )&&(VCOORD == stary2_i+4) || (HCOORD == starx2_i -120 )&&(VCOORD == stary2_i) 
              || (HCOORD == starx2_i -73 )&&(VCOORD == stary2_i+1) || (HCOORD == starx2_i -80 )&&(VCOORD == stary2_i+3) 
              || (HCOORD == starx2_i -1350 )&&(VCOORD == stary2_i) || (HCOORD == starx2_i -168 )&&(VCOORD == stary2_i) 
              || (HCOORD == starx2_i +10 )&&(VCOORD == stary2_i - 3) || (HCOORD == starx2_i +25 )&&(VCOORD == stary2_i-3) 
              || (HCOORD == starx2_i +30 )&&(VCOORD == stary2_i-4) || (HCOORD == starx2_i +40 )&&(VCOORD == stary2_i-2) 
              || (HCOORD == starx2_i +50 )&&(VCOORD == stary2_i-5) || (HCOORD == starx2_i +66 )&&(VCOORD == stary2_i-3) 
              || (HCOORD == starx2_i +70 )&&(VCOORD == stary2_i-8) || (HCOORD == starx2_i +140 )&&(VCOORD == stary2_i-9) 
              || (HCOORD == starx2_i +137 )&&(VCOORD == stary2_i-13) || (HCOORD == starx2_i +155 )&&(VCOORD == stary2_i-2)
              || (HCOORD == starx2_i -8 )&&(VCOORD == stary2_i-14) || (HCOORD == starx2_i -10 )&&(VCOORD == stary2_i-17) 
              || (HCOORD == starx2_i -30 )&&(VCOORD == stary2_i-13) || (HCOORD == starx2_i -39 )&&(VCOORD == stary2_i-19) 
              || (HCOORD == starx2_i -44 )&&(VCOORD == stary2_i-17) || (HCOORD == starx2_i -120 )&&(VCOORD == stary2_i-20) 
              || (HCOORD == starx2_i -73 )&&(VCOORD == stary2_i-19) || (HCOORD == starx2_i -80 )&&(VCOORD == stary2_i-14) 
              || (HCOORD == starx2_i -135 )&&(VCOORD == stary2_i-7) || (HCOORD == starx2_i -168 )&&(VCOORD == stary2_i-11)
              || (HCOORD == starx2_i +30 )&&(VCOORD == stary2_i+44) || (HCOORD == starx2_i +75 )&&(VCOORD == stary2_i+84) 
              || (HCOORD == starx2_i +75 )&&(VCOORD == stary2_i+81) || (HCOORD == starx2_i +160 )&&(VCOORD == stary2_i+29) 
              || (HCOORD == starx2_i +70 )&&(VCOORD == stary2_i+85) || (HCOORD == starx2_i +69 )&&(VCOORD == stary2_i+53) 
              || (HCOORD == starx2_i +120 )&&(VCOORD == stary2_i+98) || (HCOORD == starx2_i +130 )&&(VCOORD == stary2_i+39) 
              || (HCOORD == starx2_i +137 )&&(VCOORD == stary2_i+156) || (HCOORD == starx2_i +155 )&&(VCOORD == stary2_i+66)
              || (HCOORD == starx2_i -89 )&&(VCOORD == stary2_i+130) || (HCOORD == starx2_i -20 )&&(VCOORD == stary2_i+79) 
              || (HCOORD == starx2_i -130 )&&(VCOORD == stary2_i+57) || (HCOORD == starx2_i -39 )&&(VCOORD == stary2_i+97) 
              || (HCOORD == starx2_i -124 )&&(VCOORD == stary2_i+48) || (HCOORD == starx2_i -10 )&&(VCOORD == stary2_i+133) 
              || (HCOORD == starx2_i -153 )&&(VCOORD == stary2_i+14) || (HCOORD == starx2_i -50 )&&(VCOORD == stary2_i+137) 
              || (HCOORD == starx2_i -35 )&&(VCOORD == stary2_i+135) || (HCOORD == starx2_i -148 )&&(VCOORD == stary2_i-47) 
              || (HCOORD == starx2_i +16 )&&(VCOORD == stary2_i - 83) || (HCOORD == starx2_i +125 )&&(VCOORD == stary2_i-79) 
              || (HCOORD == starx2_i +80 )&&(VCOORD == stary2_i-24) || (HCOORD == starx2_i +43 )&&(VCOORD == stary2_i-127) 
              || (HCOORD == starx2_i +57 )&&(VCOORD == stary2_i-125) || (HCOORD == starx2_i +96 )&&(VCOORD == stary2_i-103) 
              || (HCOORD == starx2_i +77 )&&(VCOORD == stary2_i-85) || (HCOORD == starx2_i +149 )&&(VCOORD == stary2_i-169) 
              || (HCOORD == starx2_i +147 )&&(VCOORD == stary2_i-143) || (HCOORD == starx2_i +102 )&&(VCOORD == stary2_i-132)
              || (HCOORD == starx2_i -89 )&&(VCOORD == stary2_i-44) || (HCOORD == starx2_i -110 )&&(VCOORD == stary2_i-97) 
              || (HCOORD == starx2_i -31 )&&(VCOORD == stary2_i-33) || (HCOORD == starx2_i -29 )&&(VCOORD == stary2_i-79) 
              || (HCOORD == starx2_i -44 )&&(VCOORD == stary2_i-57) || (HCOORD == starx2_i -130 )&&(VCOORD == stary2_i-25) 
              || (HCOORD == starx2_i -74 )&&(VCOORD == stary2_i-79) || (HCOORD == starx2_i -89 )&&(VCOORD == stary2_i-44) 
              || (HCOORD == starx2_i -165 )&&(VCOORD == stary2_i-37) || (HCOORD == starx2_i -148 )&&(VCOORD == stary2_i-111)
              ||(HCOORD == starx3_i)&&(VCOORD == stary3_i) 
              || (HCOORD == starx3_i +10 )&&(VCOORD == stary_i+4) || (HCOORD == starx3_i +25 )&&(VCOORD == stary3_i+14) 
              || (HCOORD == starx3_i +30 )&&(VCOORD == stary3_i+1) || (HCOORD == starx3_i +40 )&&(VCOORD == stary3_i+9) 
              || (HCOORD == starx3_i +50 )&&(VCOORD == stary3_i+5) || (HCOORD == starx3_i +66 )&&(VCOORD == stary3_i+13) 
              || (HCOORD == starx3_i +70 )&&(VCOORD == stary3_i+18) || (HCOORD == starx3_i +140 )&&(VCOORD == stary3_i) 
              || (HCOORD == starx3_i +137 )&&(VCOORD == stary3_i) || (HCOORD == starx3_i +155 )&&(VCOORD == stary3_i+16)
              || (HCOORD == starx3_i -8 )&&(VCOORD == stary3_i+20) || (HCOORD == starx3_i -10 )&&(VCOORD == stary3_i) 
              || (HCOORD == starx3_i -30 )&&(VCOORD == stary3_i) || (HCOORD == starx3_i -39 )&&(VCOORD == stary3_i+17) 
              || (HCOORD == starx3_i -44 )&&(VCOORD == stary3_i+4) || (HCOORD == starx3_i -120 )&&(VCOORD == stary3_i) 
              || (HCOORD == starx3_i -73 )&&(VCOORD == stary3_i+1) || (HCOORD == starx3_i -80 )&&(VCOORD == stary3_i+3) 
              || (HCOORD == starx3_i -1350 )&&(VCOORD == stary3_i) || (HCOORD == starx3_i -168 )&&(VCOORD == stary3_i) 
              || (HCOORD == starx3_i +10 )&&(VCOORD == stary3_i - 3) || (HCOORD == starx3_i +25 )&&(VCOORD == stary3_i-3) 
              || (HCOORD == starx3_i +30 )&&(VCOORD == stary3_i-4) || (HCOORD == starx3_i +40 )&&(VCOORD == stary3_i-2) 
              || (HCOORD == starx3_i +50 )&&(VCOORD == stary3_i-5) || (HCOORD == starx3_i +66 )&&(VCOORD == stary3_i-3) 
              || (HCOORD == starx3_i +70 )&&(VCOORD == stary3_i-8) || (HCOORD == starx3_i +140 )&&(VCOORD == stary3_i-9) 
              || (HCOORD == starx3_i +137 )&&(VCOORD == stary3_i-13) || (HCOORD == starx3_i +155 )&&(VCOORD == stary3_i-2)
              || (HCOORD == starx3_i -8 )&&(VCOORD == stary3_i-14) || (HCOORD == starx3_i -10 )&&(VCOORD == stary3_i-17) 
              || (HCOORD == starx3_i -30 )&&(VCOORD == stary3_i-13) || (HCOORD == starx3_i -39 )&&(VCOORD == stary3_i-19) 
              || (HCOORD == starx3_i -44 )&&(VCOORD == stary3_i-17) || (HCOORD == starx3_i -120 )&&(VCOORD == stary3_i-20) 
              || (HCOORD == starx3_i -73 )&&(VCOORD == stary3_i-19) || (HCOORD == starx3_i -80 )&&(VCOORD == stary3_i-14) 
              || (HCOORD == starx3_i -135 )&&(VCOORD == stary3_i-7) || (HCOORD == starx3_i -168 )&&(VCOORD == stary3_i-11)
              || (HCOORD == starx3_i +30 )&&(VCOORD == stary3_i+44) || (HCOORD == starx3_i +75 )&&(VCOORD == stary3_i+84) 
              || (HCOORD == starx3_i +75 )&&(VCOORD == stary3_i+81) || (HCOORD == starx3_i +160 )&&(VCOORD == stary3_i+29) 
              || (HCOORD == starx3_i +70 )&&(VCOORD == stary3_i+85) || (HCOORD == starx3_i +69 )&&(VCOORD == stary3_i+53) 
              || (HCOORD == starx3_i +120 )&&(VCOORD == stary3_i+98) || (HCOORD == starx3_i +130 )&&(VCOORD == stary3_i+39) 
              || (HCOORD == starx3_i +137 )&&(VCOORD == stary3_i+156) || (HCOORD == starx3_i +155 )&&(VCOORD == stary3_i+66)
              || (HCOORD == starx3_i -89 )&&(VCOORD == stary3_i+130) || (HCOORD == starx3_i -20 )&&(VCOORD == stary3_i+79) 
              || (HCOORD == starx3_i -130 )&&(VCOORD == stary3_i+57) || (HCOORD == starx3_i -39 )&&(VCOORD == stary3_i+97) 
              || (HCOORD == starx3_i -124 )&&(VCOORD == stary3_i+48) || (HCOORD == starx3_i -10 )&&(VCOORD == stary3_i+133) 
              || (HCOORD == starx3_i -153 )&&(VCOORD == stary3_i+14) || (HCOORD == starx3_i -50 )&&(VCOORD == stary3_i+137) 
              || (HCOORD == starx3_i -35 )&&(VCOORD == stary3_i+135) || (HCOORD == starx3_i -148 )&&(VCOORD == stary3_i-47) 
              || (HCOORD == starx3_i +16 )&&(VCOORD == stary3_i - 83) || (HCOORD == starx3_i +125 )&&(VCOORD == stary3_i-79) 
              || (HCOORD == starx3_i +80 )&&(VCOORD == stary3_i-24) || (HCOORD == starx3_i +43 )&&(VCOORD == stary3_i-127) 
              || (HCOORD == starx3_i +57 )&&(VCOORD == stary3_i-125) || (HCOORD == starx3_i +96 )&&(VCOORD == stary3_i-103) 
              || (HCOORD == starx3_i +77 )&&(VCOORD == stary3_i-85) || (HCOORD == starx3_i +149 )&&(VCOORD == stary3_i-169) 
              || (HCOORD == starx3_i +147 )&&(VCOORD == stary3_i-143) || (HCOORD == starx3_i +102 )&&(VCOORD == stary3_i-132)
              || (HCOORD == starx3_i -89 )&&(VCOORD == stary3_i-44) || (HCOORD == starx3_i -110 )&&(VCOORD == stary3_i-97) 
              || (HCOORD == starx3_i -31 )&&(VCOORD == stary3_i-33) || (HCOORD == starx3_i -29 )&&(VCOORD == stary3_i-79) 
              || (HCOORD == starx3_i -44 )&&(VCOORD == stary3_i-57) || (HCOORD == starx3_i -130 )&&(VCOORD == stary3_i-25) 
              || (HCOORD == starx3_i -74 )&&(VCOORD == stary3_i-79) || (HCOORD == starx3_i -89 )&&(VCOORD == stary3_i-44) 
              || (HCOORD == starx3_i -165 )&&(VCOORD == stary3_i-37) || (HCOORD == starx3_i -148 )&&(VCOORD == stary3_i-111)))  
             CSEL <= 12'b111111111111;                       
    else
        CSEL <= 12'b000000000000;
end


endmodule
