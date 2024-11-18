
for (var i = 0 ; i < 3; i++){
	draw_sprite(spr_pipe,0,pipex[i],pipey[i]);
	draw_sprite_ext(spr_pipe,0,pipex[i],pipey[i]-48,1,-1,0,c_white,1);
}


draw_self();
draw_sprite(spr_ground,0,groundx,256);


go_spd =  min(4,go_spd+0.1);
go_y = min(80,go_y+go_spd);
getready = lintrans(getready,phase == startingPhase,0.05);
fade = lintrans(fade,is_fade,0.08);
flash = max(0,flash-0.05);
go_score_y = smoothtrans(go_score_y,128,0.2);

if (phase == dyingPhase && go_tmr < 0.7){
	draw_sprite(spr_gameover,0,72,go_y);
	if (go_tmr < 0.01){
		draw_sprite(spr_score,0,72,go_score_y);	
		drawNumber(show_points,112,go_score_y-11);
		drawNumber(max_points,112,go_score_y+9);
		if (go_score_y-128 < 1){
			show_per = min(1,show_per+0.03);
			show_points = floor(points*show_per);
		}
		if (show_per == 1){
			if (new_score){
				draw_sprite(spr_new,0,83,go_score_y+1);	
			}
			max_points = max(max_points,points);	
			if (points >= 10){
				draw_sprite(spr_medal,min((points div 10) -1,3),40,go_score_y+4);		
				//sp_index = ((sp_index*5+16)%35-15)/5;
				//sp_index = (sp_index+0.2+3)%7-3;
				sp_index += 0.2
				if (sp_index == 4){
					sp_index = -3;	
				}
				if (sp_index == 0){
					sp_x = irandom_range(25,45);
					sp_y = irandom_range(123,133);
				}
				draw_sprite(spr_sparkle,abs(sp_index),sp_x,sp_y);
			}
			playbutton.Draw();
			leaderbutton.Draw();
				
		}
	}
}
else if (phase == titlePhase){
	playbutton.Draw();
	leaderbutton.Draw();
	draw_sprite(spr_title,0,72,88);
	draw_sprite(spr_copyright,0,72,212);

}
else{
	drawScore(points);
}

draw_set_alpha(getready);
draw_sprite(spr_getready,0,72,88);
draw_sprite(spr_tap,0,72,136);
draw_set_alpha(1);



draw_sprite_ext(spr_pixel,0,0,0,144,256,0,c_black,fade);
draw_sprite_ext(spr_pixel,0,0,0,144,256,0,c_white,flash);