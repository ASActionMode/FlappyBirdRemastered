/******************************************************************************************
 * Description: This script handles every aspect of the game solely. Since game is simple
 * So every function is in here. (We'll saperate them as needed, or you can).
 *
 * Original Author(s): GrizzliusMaximus & ASActionMode
 * Last Modified: 21-11-2024 (21 November, 2024)
 * 
 * License: Apache 2.0
*
 * GitHub Repository: https://github.com/ASActionMode/FlappyBirdRemastered/tree/main
 ******************************************************************************************/

//function drawScore2(_n,_x){
//	var _nn = _n%10;
//	if (_nn == 1){
//		_x -= 6;
//	}
//	else{
//		_x -= 10;	
//	}
//	if (_n >= 10){
//		drawScore2(_n div 10,_x);
//	}
//	if (_nn == 1){
//		_x -= 2;
//	}
//	draw_sprite(spr_bignumbers,_nn,_x,48);
//}

//function drawScore(_n){
//	var _n2 = _n;
//	var _digits = 0;
//	var _size = 0;
//	while(_n > 0){
//		_digits++;
//		if (_n%10 == 1){
//			_size += 6;
//		}
//		else{
//			_size += 10;	
//		}
//		_n = _n div 10;
//	}
//	if (_digits == 0){
//		_size = 10;
//		_digits = 1;
//	}
//	var _x = 72+_size*0.5;
//	drawScore2(_n2,_x);
//}

//function drawScore(_n){
//	var _s = string(_n);
//	var _len = string_length(_s);
//	var _size = 0;
//	for (var i =0; i < _len; i++){
//		if (string_char_at(_s,i+1) == "1"){
//			_size += 6;
//		}
//		else{
//			_size += 10;
//		}
//	}
//	var _x = 72 - _size*0.5;
//	for (var i =0; i < _len; i++){
//		var _c = string_char_at(_s,i+1)
//		if (_c == "1"){
//			_x -= 2;
//			draw_sprite(spr_bignumbers,int64(_c),_x,40);
//			_x += 8;
//		}
//		else{
//			draw_sprite(spr_bignumbers,int64(_c),_x,40);
//			_x += 10;	
//		}
//	}
//}


function drawScore(_n){
	var _n_orig = _n;
	var _digits = 0;
	var _width = 0;
	// Get width
	do{
		_digits++;
		//Get right-most digit
		if (_n%10 == 1){
			_width += 6;
		}
		else{
			_width += 10;	
		}
		_n = _n div 10;
	}until (_n <= 0)
	// Find the _x position based on the _width so score is drawn on center
	var _x = 72-_width*0.5;
	
	// Draw the digits
	_n = 0;
	for (var i = _digits-1; i >= 0; i--){
		// Get left-most digit
		_n = (_n_orig div power(10,i))%10;
		if (_n == 1){
			_x -= 2;
			draw_sprite(spr_bignumbers,_n,_x,40);
			_x += 8;
		}
		else{
			draw_sprite(spr_bignumbers,_n,_x,40);
			_x += 10;	
		}
	}
}

function drawNumber(_n,_x,_y){
	do{
		var _nn = _n%10;
		draw_sprite(spr_numbers,_nn,_x,_y);
		_x -= 8;
		_n = _n div 10;
	}until(_n <= 0)
}


function smoothtrans(_src,_des,_inc){
	return _src+(_des-_src)*_inc;
}

function lintrans(_src,_des,_inc){
	var _sign = sign(_des-_src);
	return clamp(_src+_sign*_inc,min(_src,_des),max(_src,_des));
}


function groundMove(){
	groundx--;
	
	if (groundx == -24){
		groundx = 0;	
	}
}

function rotation(){
	var _mul = 2;
	if (yspd < 0){
		_mul = 4;	
	}
	image_angle = clamp(image_angle-yspd*_mul,-90,20);
}

function dyingInit(){
	if (y >= 194){
		y = 194;
	}
	phase = dyingPhase;
	image_index = 0;
	image_speed = 0;
	flash = 1;
	go_tmr = 1.2;	
	if (points > max_points){
		new_score = 1;
		ini_open("data.ini");
		ini_write_real("var","score",points);
		ini_close();
	}
}

function flyingPhase(){
	rotation();
	groundMove();

	var _isjump = (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space)) && y >= 4; //is the jump button pressed?


	if (_isjump){
		yspd = -3;
		audio_play_sound(sfx_wing,0,0);
	}
	else{
		yspd = min(4,yspd+0.2);
	}

	y += yspd;
	 
	for (var i = 0 ; i < 3; i++){
		pipex[i]--;
		if (pipex[i] == -16){
			pipex[i] = pipex[(i+2)%3]+80;	
			pipey[i] = 80+floor(random(6))*16;
		}
		if (pipex[i] > 25 && pipex[i] < 63 && !(y < pipey[i]-5 && y > pipey[i]-43)){
			audio_play_sound(sfx_hit,0,0);
			pipex[(i+1)%3]--;	
			dyingInit();
			return;
		}
		if (pipex[i] == 44){
			audio_play_sound(sfx_point,0,0);
			points++;
		}
	}
	if (y >= 196){
		audio_play_sound(sfx_hit,0,0);
		dyingInit();
		return;
	}
	
	
}

function startingPhase(){
	groundMove();
	y = ystart + sin(current_time*0.008)*2;
	var _isjump = (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space));
	if (_isjump){
		phase = flyingPhase;
		yspd = -3;
		audio_play_sound(sfx_wing,0,0);
	}
	
}

function birdInit(){
	x = 44;
	y = 128;
	yspd = 0;
	phase = startingPhase;
	
	for (var i = 2; i >= 0; i--) {
		pipex[i] = 300+80*i;
	}
	

	pipey[2] = 80+floor(random(6))*16;
	pipey[1] = 80+floor(random(6))*16;
	pipey[0] = 80+floor(random(6))*16;

	points = 0;
	show_points = 0;
	show_per = 0;
	max_points = 0;
	new_score = 0;
	flash = 0;
	getready = 0;
	go_spd = 0;
	go_y = 88;
	go_tmr = 0;
	go_score_y = 0;
	sp_x = irandom_range(25,45);
	sp_y = irandom_range(115,125);
	sp_index = 0;
	image_angle = 0;
	image_speed = 1;

	ini_open("data.ini");
	max_points  = ini_read_real("var","score",0);
	ini_close();


	spr_bird = [spr_bluebird,spr_redbird,spr_yellowbird];
	bird_index = irandom(2);
	sprite_index = spr_bird[bird_index];

	bg_index = irandom(3);
	bg_layer_id = layer_get_id("Background");
	bg_id = layer_background_get_id(bg_layer_id);
	layer_background_index(bg_id,bg_index);	
	
	// set rainy layer visiblity to true and play an rain sound when index is 3 ONLY
	var rainy_layer_id = layer_get_id("Rainy");
    if (bg_index == 3) {
        layer_set_visible(rainy_layer_id, true);
		audio_play_sound(rain_bg_sfx, 1, true)
    } else {
        layer_set_visible(rainy_layer_id, false);
		audio_stop_sound(rain_bg_sfx)
    } 
	// i love gamemaker just because of this
	//// pipe related handling not ready yet
	//if (bg_index == 1) {
	//	spr_pipe_index == spr_pipered
	//}
}

function dyingPhase(){
	rotation();
	if (y >= 194){
		y = 194;
	}
	else{
		yspd = min(4,yspd+0.2);
		y += yspd;
		if (flash == 0.1){
			audio_play_sound(sfx_die,0,0);
		}
	}
	go_tmr = max(0,go_tmr-0.01);
	if (go_tmr == 0.7){
		go_spd = -1;
		audio_play_sound(sfx_swooshing,0,0);
		
	}
	if (go_tmr == 0.01){
		go_score_y = 320;
		audio_play_sound(sfx_swooshing,0,0);
	}
	if (fade == 1){
		is_fade = 0;
		birdInit();		
	}
}

function titlePhase(){
	groundMove();
	x = 72;
	y = 120 + sin(current_time*0.008)*2;	
	if (fade == 1){
		is_fade = 0;
		birdInit();	
	}
}

function noScript(){
	//url_open("https://www.youtube.com/c/GrizzliusMaximus");
}

function playScript(){
	other.is_fade = 1;
	audio_play_sound(sfx_swooshing,0,0);
}


function Button(_x, _y,_func,_spr) constructor{
    x = _x;
    y = _y;
	func = _func;
	spr = _spr;
	static buttonPressed = function(){
		return (mouse_check_button(mb_left) && point_in_rectangle(mouse_x,mouse_y,x,y,x+52,y+29));
	}
	
	static buttonReleased = function(){
		return (mouse_check_button_released(mb_left) && point_in_rectangle(mouse_x,mouse_y,x,y,x+52,y+29));;
	}
	
    static Draw = function(){
		draw_sprite(spr,0,x,y+buttonPressed());
		if (buttonReleased()){
			script_execute(func);
		}
    }
}