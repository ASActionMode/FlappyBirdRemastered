birdInit();
fade = 0;
is_fade = 0;
phase = titlePhase;
groundx = 0;



audio_set_master_gain(0,0.1);

playbutton = new Button(12,171,playScript,spr_playbutton);

leaderbutton = new Button(80,171,noScript,spr_leaderbutton);

//jump_flag = 0;