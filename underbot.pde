/* @pjs font=/data/MonsterFriendFore.otf, /data/determination.otf */
ArrayList<bullet> bullets = new ArrayList<bullet>();
boolean[] keys = new boolean[101];
PVector boxsize;
PVector player, botpos;
int bwid = 5;
int hp = 84, bhp = 126;
int heartcolour = 0, botcol = -155;

int bulcount = 0;
boolean countbul = false;
PVector nearbullet, nearvel, nearbotb, nearbotv, nearbb2, nearbv2;
String control;

PVector sizechange;

boolean guide = false;

String screen = "menu";

int tooclose;

int streamcnt = 0;
int bburstcnt = 0;
int lburstcnt = 0;
int circcnt = 0;

int currfc;

boolean cntstr = false;

PFont monsterfriend, dtmmono;

PVector botshoot = new PVector(0, 1000);

int countdown = 0;

Audio snowdintown, determi, metalcrusher;

boolean mc = false;

bulletcircle circle = new bulletcircle("cenp", 1, 8);

bulletcircle circp = new bulletcircle("cenb", 1200, 8);

int circleCount = 0;

void setup(){
  size(800, 600);
  boxsize = new PVector(200, 200);
  player = new PVector(width / 3, 400);
  botpos = new PVector(width / 3 * 2, 400);
  
  nearbullet = new PVector(0, 0);
  nearvel = new PVector(0, 0);
  nearbotb = new PVector(0, 0);
  nearbotv = new PVector(0,  0);
  nearbb2 = new PVector(0, 0);
  nearbv2 = new PVector(0, 0);
  sizechange = new PVector(0, 1000);
  control = "bot";
  
  bullets.add(new bullet(width/3*2-111, 400-111, "bot", true));
  bullets.add(new bullet(width/3*2-111, 400+111, "bot", true));
  bullets.add(new bullet(width/3*2+111, 400-111, "bot", true));
  bullets.add(new bullet(width/3*2+111, 400+111, "bot", true));
  
  bullets.add(new bullet(width/3*2-101, 400-111, "bot", true));
  bullets.add(new bullet(width/3*2-111, 400-101, "bot", true));
  
  bullets.add(new bullet(width/3*2+111, 400-101, "bot", true));
  bullets.add(new bullet(width/3*2+101, 400-111, "bot", true));
  
  bullets.add(new bullet(width/3*2+101, 400+111, "bot", true));
  bullets.add(new bullet(width/3*2+111, 400+101, "bot", true));
  
  bullets.add(new bullet(width/3*2-111, 400+101, "bot", true));
  bullets.add(new bullet(width/3*2-101, 400+111, "bot", true));
  
  monsterfriend = createFont("/data/MonsterFriendFore.otf", 48);
  dtmmono = createFont("/data/determination.otf", 48);
  
  snowdintown = new Audio("/data/snowdintown.mp3");
  determi = new Audio("/data/Undertale OST 011 - Determination.mp3");
  metalcrusher = new Audio("/data/Undertale OST 050 - Metal Crusher.mp3");
  
  metalcrusher.playbackRate = 1.05;
  
  snowdintown.loop = true;
  determi.loop = true;
  metalcrusher.loop = true;
}

void draw(){
  switch(screen){
    case "game":
      cursor();
      background(0);
      noFill();
      stroke(255);
      strokeWeight(bwid);
      rectMode(CENTER);
      rect(width/3, 400, boxsize.x, boxsize.y);
      rect(width/3*2, 400, boxsize.x, boxsize.y);
      
      noStroke();
      fill(255, 0, 0);
      rect(width / 3, 550, 126, 30);
      
      rectMode(CORNER);
      fill(255, 255, 0);
      rect(width / 3 - 63, 535, hp * 1.5, 30);
      
      rectMode(CENTER);
      noStroke();
      fill(255, 0, 0);
      rect(width / 3 * 2, 550, 126, 30);
      
      rectMode(CORNER);
      fill(255, 255, 0);
      rect(width / 3 * 2 - 63, 535, bhp, 30);
      
      if(keys[UP]) player.y -= 2;
      if(keys[LEFT]) player.x -= 2;
      if(keys[DOWN]) player.y += 2;
      if(keys[RIGHT]) player.x += 2;
      
      player.x = constrain(player.x, width/3 - boxsize.x / 2 + bwid + 6, width/3 + boxsize.x / 2 - bwid - 5);
      player.y = constrain(player.y, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
      
      botpos.x = constrain(botpos.x, width/3*2 - boxsize.x / 2 + bwid + 6, width/3*2 + boxsize.x / 2 - bwid - 5);
      botpos.y = constrain(botpos.y, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
      
      stroke(255, 155);
      strokeWeight(1);
      //line(nearbotb.x, nearbotb.y, botpos.x, botpos.y);
      
      botcontrol();
      
      runbullets();
      heart();
      botheart();
      
      spawnbullets();
      buttons();
      closelines();
      
      if(countbul){
        bulcount++;
        if(bulcount>20){
          bulcount = 0;
          countbul = false;
        }
      }
      
      if(hp == 0 && bhp > 0) screen = "botwins";
      if(bhp == 0 && hp > 0) screen = "playerwins";
    break;
    case "botwins":
      metalcrusher.pause();
      determi.play();
      noCursor();
      textAlign(CENTER);
      textFont(dtmmono);
      background(0);
      botheart();
      fill(155);
      textSize(30);
      text("you lost.", width/2, 150);
      
      pushMatrix();
      translate(mouseX+8, mouseY+8);
      rotate(radians(135));
      heartgraphic(1, 1, color(255, 0, 0));
      popMatrix();
    break;
    case "playerwins":
      metalcrusher.pause();
      snowdintown.play();
      noCursor();
      textAlign(CENTER);
      textFont(dtmmono);
      background(0);
      heart();
      fill(255, 0, 0);
      textSize(30);
      text("you won.", width/2, 150);
      
      pushMatrix();
      translate(mouseX+8, mouseY+8);
      rotate(radians(135));
      heartgraphic(1, 1, color(255, 0, 0));
      popMatrix();
    break;
    case "menu":
      snowdintown.play();
      noCursor();
      background(0);
      fill(255);
      textFont(monsterfriend);
      textSize(48);
      textAlign(CENTER);
      text("underbot", width/2, 135);
      textFont(dtmmono);
      textSize(24);
      text("play against an AI", width/2, 185);
      textSize(16);
      text("controls: arrow keys and mouse", width/2, 225);
      text("foreverlovi.github.io", width/2, 85);
      
      rectMode(CENTER);
      
      fill(255);
      mc = false;
      if(mouseX >= width/2 - 100 && mouseX <= width/2 + 100 && mouseY >= height/2 - 12 && mouseY <= height/2 + 68){
        mc = true;
        fill(255, 255, 0);
        if(mousePressed) screen = "countdown"; countdown = frameCount;
      }
      textSize(36);
      text("PLAY", width/2, height/2 + 40);
      fill(155);
      textSize(14);
      text("click to spawn bullets aimed at the grey heart,\nmove the red heart with the arrow keys.\nthe buttons on top spawn bullet patterns.", width/2, height * 0.72);
      
      pushMatrix();
      translate(mouseX+8, mouseY+8);
      rotate(radians(135));
      heartgraphic(1, 1, color(255, 0, 0));
      popMatrix();
    break;
    case "countdown":
      snowdintown.pause();
      if(frameCount - countdown > 1) metalcrusher.play();
      background(0);
      fill(255);
      textSize(48);
      text("ready", width/2, height/2 - 50);
      
      if(frameCount - countdown < 60) text("3", width/2, height/2 + 50);
      if(frameCount - countdown < 120 && frameCount - countdown > 59) text("2", width/2, height/2 + 50);
      if(frameCount - countdown < 180 && frameCount - countdown > 119) text("1", width/2, height/2 + 50);
      if(frameCount - countdown < 240 && frameCount - countdown > 179) text("good luck!", width/2, height/2 + 50);
      if(frameCount - countdown == 240) screen = "game";
    break;
  }
}
void keyPressed(){
  keys[keyCode] = true;
}

void keyReleased(){
  keys[keyCode] = false;
}

void mousePressed(){
  if(!countbul){
    if(dist(mouseX, mouseY, botpos.x, botpos.y) > 35 && dist(mouseX, mouseY, player.x, player.y) > 35){
      bullets.add(new bullet(mouseX, mouseY, "bot", false));
      countbul = true;
    } else {
      tooclose = 1055;
    }
  }
}

void botcontrol(){
  float distance = dist(nearbotb.x, nearbotb.y, botpos.x, botpos.y);
	float dist2 = dist(nearbb2.x, nearbb2.y, botpos.x, botpos.y);
  float veldiff = abs(abs(nearbotv.x) - abs(nearbotv.y));
	if(nearbb2.x * nearbotb.x < 0 && nearbb2.y * nearbotb.y < 0 && distance < 34){
		 if(nearbotb.x < botpos.x){
			 botpos.x = constrain(botpos.x + 2, width/3*2 - boxsize.x / 2 + bwid + 6, width/3*2 + boxsize.x / 2 - bwid - 5);
			 if(nearbotb.y < botpos.y) botpos.y = constrain(botpos.y - 2, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
			 if(nearbotb.y > botpos.y) botpos.y = constrain(botpos.y + 2, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
		 }
		if(nearbotb.x > botpos.x){
			 botpos.x = constrain(botpos.x - 2, width/3*2 - boxsize.x / 2 + bwid + 6, width/3*2 + boxsize.x / 2 - bwid - 5);
			 if(nearbotb.y < botpos.y) botpos.y = constrain(botpos.y - 2, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
			 if(nearbotb.y > botpos.y) botpos.y = constrain(botpos.y + 2, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
		 }
	} else {
		if(distance < 50){
			if(veldiff > 1.05){
				if(nearbotb.x > botpos.x) botpos.x = constrain(botpos.x - 2, width/3*2 - boxsize.x / 2 + bwid + 6, width/3*2 + boxsize.x / 2 - bwid - 5);
				if(nearbotb.x < botpos.x) botpos.x = constrain(botpos.x + 2, width/3*2 - boxsize.x / 2 + bwid + 6, width/3*2 + boxsize.x / 2 - bwid - 5);
				if(nearbotb.y > botpos.y) botpos.y = constrain(botpos.y - 2, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
				if(nearbotb.y < botpos.y) botpos.y = constrain(botpos.y + 2, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
			} else {
				if(distance < 19){
					if(nearbotb.x > botpos.x) botpos.x = constrain(botpos.x + 2, width/3*2 - boxsize.x / 2 + bwid + 6, width/3*2 + boxsize.x / 2 - bwid - 5);
					if(nearbotb.x < botpos.x) botpos.x = constrain(botpos.x - 2, width/3*2 - boxsize.x / 2 + bwid + 6, width/3*2 + boxsize.x / 2 - bwid - 5);
					if(nearbotb.y > botpos.y) botpos.y = constrain(botpos.y - 2, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
					if(nearbotb.y < botpos.y) botpos.y = constrain(botpos.y + 2, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
				} else {
					if(nearbotb.x > botpos.x) botpos.x = constrain(botpos.x - 2, width/3*2 - boxsize.x / 2 + bwid + 6, width/3*2 + boxsize.x / 2 - bwid - 5);
					if(nearbotb.x < botpos.x) botpos.x = constrain(botpos.x + 2, width/3*2 - boxsize.x / 2 + bwid + 6, width/3*2 + boxsize.x / 2 - bwid - 5);
					if(nearbotb.y > botpos.y) botpos.y = constrain(botpos.y + 2, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
					if(nearbotb.y < botpos.y) botpos.y = constrain(botpos.y - 2, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
				}
			}
		}
	}
}

class bullet {
  PVector pos;
  PVector vel = new PVector(0, 0);
  String dir = "";
  boolean sti;
  int fc = frameCount;
  bullet(float x, float y, String directed, boolean still){
    dir = directed;
    sti = still;
    pos = new PVector(x, y);
    setvelocity();
  }
  void setvelocity(){
    switch(dir){
      case "player":
        vel = new PVector(pos.x - player.x, pos.y - player.y);
        if(abs(vel.y) > abs(vel.x)) vel.div(abs(vel.y) / 3);
        if(abs(vel.x) > abs(vel.y)) vel.div(abs(vel.x) / 3);
      break;
      case "bot":
        vel = new PVector(pos.x - botpos.x, pos.y - botpos.y);
        if(abs(vel.y) > abs(vel.x)) vel.div(abs(vel.y) / 3);
        if(abs(vel.x) > abs(vel.y)) vel.div(abs(vel.x) / 3);
      break;
      case "cenb":
	vel = PVector.fromAngle(atan2(pos.y - 400, pos.x - width/3*2));
	vel.mult(3);
      break;
      case "cenp":
	vel = PVector.fromAngle(atan2(pos.y - 400, pos.x - width/3));
	vel.mult(3);
      break;
    }
    if(sti) vel = new PVector(0, 0);
  }
  void run(){
    noStroke();
    fill(255);
    if(sti) fill(255, 0);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate((frameCount % 365) / 4);
    ellipse(0, 0, 10, 6);
    popMatrix();
    
    if(frameCount - fc > 45) pos.sub(vel);
    if(frameCount - fc == 30) setvelocity();
  }
}

void runbullets(){
  float nearness = 999;
  int nearindex = 0;
  float nearnessb = 999;
  int nearindb = 0;
  int nearindb2 = 0;
  for(int i = 0; i < bullets.size(); i++){
    bullet b = bullets.get(i);
    b.run();
    if(dist(b.pos.x, b.pos.y, player.x, player.y) < 10){
      hp -= 1;
      hp = constrain(hp, 0, 84);
      bullets.remove(i);
      heartcolour = 255;
    }
    if(dist(b.pos.x, b.pos.y, player.x, player.y) < nearness){
      nearness = dist(b.pos.x, b.pos.y, player.x, player.y);
      nearindex = i;
    }
    
    if(dist(b.pos.x, b.pos.y, botpos.x, botpos.y) < 10){
      bhp -= 1;
      bhp = constrain(bhp, 0, 126);
      bullets.remove(i);
      botcol = -155;
    }
    if(dist(b.pos.x, b.pos.y, botpos.x, botpos.y) < nearnessb){
      nearnessb = dist(b.pos.x, b.pos.y, botpos.x, botpos.y);
			nearindb2 = nearindex;
      nearindb = i;
    }
    
    if(dist(b.pos.x, b.pos.y, width/2, 400) > width / 2){
      bullets.remove(i);
    }
  }
  if(bullets.size() > 0 && nearindex < bullets.size()){
    nearbullet.x = bullets.get(nearindex).pos.x;
    nearbullet.y = bullets.get(nearindex).pos.y;
    
    nearvel.x = bullets.get(nearindex).vel.x;
    nearvel.y = bullets.get(nearindex).vel.y;
  }
  
  if(bullets.size() > 0 && nearindb < bullets.size()){
    nearbotb.x = bullets.get(nearindb).pos.x;
    nearbotb.y = bullets.get(nearindb).pos.y;
    
    nearbotv.x = bullets.get(nearindb).vel.x;
    nearbotv.y = bullets.get(nearindb).vel.y;
  }
	
  if(bullets.size() > 0 && nearindb2 < bullets.size()){
    nearbb2.x = bullets.get(nearindb2).pos.x;
    nearbb2.y = bullets.get(nearindb2).pos.y;
    
    nearbv2.x = bullets.get(nearindb2).vel.x;
    nearbv2.y = bullets.get(nearindb2).vel.y;
  }
}

void spawnbullets(){
  if(frameCount % 16 == 0){
    bullets.add(new bullet(width/3-400+800*noise(botshoot.x), 800*noise(botshoot.y), "player", false));
  }
  
  streambullets("bottom", 3200, 200, 0, "player");
  streambullets("top", 3200, 1000, 0, "player");
  streambullets("top", 9600, 200, 0, "player");
  
  if(frameCount % 3200 == 2300) bigburst(0, "player");
  if(frameCount % 3200 == 2360) littleburst(0, "player");
  
  streamcnt = constrain(streamcnt+1, 0, 900);
  bburstcnt = constrain(bburstcnt+1, 0, 1200);
  lburstcnt = constrain(lburstcnt+1, 0, 1200);
  circcnt = constrain(circcnt+1, 0, 1600);
  circp.shoot();
  
  playercircle();
  
  aimvisual();
  botshoot.x += 0.006;
  botshoot.y += 0.006;
}

void streambullets(String place, int interval, int displace, int shift, String direct){
  if(place == "bottom"){
    if(frameCount % interval == 0 + displace) bullets.add(new bullet(width/3+shift-100, 400+120, direct, false));
    if(frameCount % interval == 3 + displace) bullets.add(new bullet(width/3+shift-80, 400+120, direct, false));
    if(frameCount % interval == 6 + displace) bullets.add(new bullet(width/3+shift-60, 400+120, direct, false));
    if(frameCount % interval == 9 + displace) bullets.add(new bullet(width/3+shift-40, 400+120, direct, false));
    if(frameCount % interval == 12 + displace) bullets.add(new bullet(width/3+shift-20, 400+120, direct, false));
    if(frameCount % interval == 15 + displace) bullets.add(new bullet(width/3+shift, 400+120, direct, false));
    if(frameCount % interval == 18 + displace) bullets.add(new bullet(width/3+shift+20, 400+120, direct, false));
    if(frameCount % interval == 21 + displace) bullets.add(new bullet(width/3+shift+40, 400+120, direct, false));
    if(frameCount % interval == 24 + displace) bullets.add(new bullet(width/3+shift+60, 400+120, direct, false));
    if(frameCount % interval == 27 + displace) bullets.add(new bullet(width/3+shift+80, 400+120, direct, false));
    if(frameCount % interval == 30 + displace) bullets.add(new bullet(width/3+shift+100, 400+120, direct, false));
  }
  if(place == "top"){
    if(frameCount % interval == 0 + displace) bullets.add(new bullet(width/3+shift-100, 400-120, direct, false));
    if(frameCount % interval == 3 + displace) bullets.add(new bullet(width/3+shift-80, 400-120, direct, false));
    if(frameCount % interval == 6 + displace) bullets.add(new bullet(width/3+shift-60, 400-120, direct, false));
    if(frameCount % interval == 9 + displace) bullets.add(new bullet(width/3+shift-40, 400-120, direct, false));
    if(frameCount % interval == 12 + displace) bullets.add(new bullet(width/3+shift-20, 400-120, direct, false));
    if(frameCount % interval == 15 + displace) bullets.add(new bullet(width/3+shift, 400-120, direct, false));
    if(frameCount % interval == 18 + displace) bullets.add(new bullet(width/3+shift+20, 400-120, direct, false));
    if(frameCount % interval == 21 + displace) bullets.add(new bullet(width/3+shift+40, 400-120, direct, false));
    if(frameCount % interval == 24 + displace) bullets.add(new bullet(width/3+shift+60, 400-120, direct, false));
    if(frameCount % interval == 27 + displace) bullets.add(new bullet(width/3+shift+80, 400-120, direct, false));
    if(frameCount % interval == 30 + displace) bullets.add(new bullet(width/3+shift+100, 400-120, direct, false));
  }
}

void aimvisual(){
  noFill();
  stroke(255, 105);
  strokeWeight(2);
  ellipse(width/3-400+800*noise(botshoot.x), 800*noise(botshoot.y), 8, 8);
}

class bulletcircle {
  int cnt = frameCount;
  String dir;
  int shift;
  int spd;
  bulletcircle(String direct, int shiftright, int speed){
          cnt = frameCount;
	  dir = direct;
	  shift = shiftright;
	  spd = speed;
  }
  void shoot(){
	if(frameCount - cnt < 2) bullets.add(new bullet(width/3+shift, 400 - 175, dir, false));
	if(frameCount - cnt == spd) bullets.add(new bullet(width/3+40+shift, 400 - 170, dir, false));
	if(frameCount - cnt == spd*2) bullets.add(new bullet(width/3+83+shift, 400 - 151, dir, false));
	if(frameCount - cnt == spd*3) bullets.add(new bullet(width/3+122+shift, 400 - 122, dir, false));
	if(frameCount - cnt == spd*4) bullets.add(new bullet(width/3+151+shift, 400 - 83, dir, false));
	if(frameCount - cnt == spd*5) bullets.add(new bullet(width/3+170+shift, 400 - 40, dir, false));
	if(frameCount - cnt == spd*6) bullets.add(new bullet(width/3+175+shift, 400, dir, false));
	if(frameCount - cnt == spd*7) bullets.add(new bullet(width/3+170+shift, 400 + 40, dir, false));
	if(frameCount - cnt == spd*8) bullets.add(new bullet(width/3+151+shift, 400 + 83, dir, false));
	if(frameCount - cnt == spd*9) bullets.add(new bullet(width/3+122+shift, 400 + 122, dir, false));
	if(frameCount - cnt == spd*10) bullets.add(new bullet(width/3+83+shift, 400 + 151, dir, false));
	if(frameCount - cnt == spd*11) bullets.add(new bullet(width/3+40+shift, 400 + 170, dir, false));
	if(frameCount - cnt == spd*12) bullets.add(new bullet(width/3+shift, 400 + 175, dir, false));
	if(frameCount - cnt == spd*13) bullets.add(new bullet(width/3-40+shift, 400 + 170, dir, false));
	if(frameCount - cnt == spd*14) bullets.add(new bullet(width/3-83+shift, 400 + 151, dir, false));
	if(frameCount - cnt == spd*15) bullets.add(new bullet(width/3-122+shift, 400 + 122, dir, false));
	if(frameCount - cnt == spd*16) bullets.add(new bullet(width/3-151+shift, 400 + 83, dir, false));
	if(frameCount - cnt == spd*17) bullets.add(new bullet(width/3-170+shift, 400 + 40, dir, false));
	if(frameCount - cnt == spd*18) bullets.add(new bullet(width/3-175+shift, 400, dir, false));
	if(frameCount - cnt == spd*19) bullets.add(new bullet(width/3-170+shift, 400 - 40, dir, false));
	if(frameCount - cnt == spd*20) bullets.add(new bullet(width/3-151+shift, 400 - 83, dir, false));
	if(frameCount - cnt == spd*21) bullets.add(new bullet(width/3-122+shift, 400 - 122, dir, false));
	if(frameCount - cnt == spd*22) bullets.add(new bullet(width/3-83+shift, 400 - 151, dir, false));
	if(frameCount - cnt == spd*23) bullets.add(new bullet(width/3-40+shift, 400 - 170, dir, false));
  }
}

void playercircle(){
  if(frameCount % 1900 == 8) bullets.add(new bullet(width/3, 400 - 175, "cenp", false));
  if(frameCount % 1900 == 16 && frameCount % 2300 > 7) bullets.add(new bullet(width/3+40, 400 - 170, "cenp", false));
  if(frameCount % 1900 == 24 && frameCount % 2300 > 15) bullets.add(new bullet(width/3+83, 400 - 151, "cenp", false));
  if(frameCount % 1900 == 30 && frameCount % 2300 > 23) bullets.add(new bullet(width/3+122, 400 - 122, "cenp", false));
  if(frameCount % 1900 == 36 && frameCount % 2300 > 29) bullets.add(new bullet(width/3+151, 400 - 83, "cenp", false));
  if(frameCount % 1900 == 42 && frameCount % 2300 > 35) bullets.add(new bullet(width/3+170, 400 - 40, "cenp", false));
  if(frameCount % 1900 == 48 && frameCount % 2300 > 41) bullets.add(new bullet(width/3+175, 400, "cenp", false));
  if(frameCount % 1900 == 54 && frameCount % 2300 > 47) bullets.add(new bullet(width/3+170, 400 + 40, "cenp", false));
  if(frameCount % 1900 == 60 && frameCount % 2300 > 53) bullets.add(new bullet(width/3+151, 400 + 83, "cenp", false));
  if(frameCount % 1900 == 66 && frameCount % 2300 > 59) bullets.add(new bullet(width/3+122, 400 + 122, "cenp", false));
  if(frameCount % 1900 == 72 && frameCount % 2300 > 65) bullets.add(new bullet(width/3+83, 400 + 151, "cenp", false));
  if(frameCount % 1900 == 78 && frameCount % 2300 > 71) bullets.add(new bullet(width/3+40, 400 + 170, "cenp", false));
  if(frameCount % 1900 == 84 && frameCount % 2300 > 77) bullets.add(new bullet(width/3, 400 + 175, "cenp", false));
  if(frameCount % 1900 == 90 && frameCount % 2300 > 83) bullets.add(new bullet(width/3-40, 400 + 170, "cenp", false));
  if(frameCount % 1900 == 96 && frameCount % 2300 > 89) bullets.add(new bullet(width/3-83, 400 + 151, "cenp", false));
  if(frameCount % 1900 == 102 && frameCount % 2300 > 95) bullets.add(new bullet(width/3-122, 400 + 122, "cenp", false));
  if(frameCount % 1900 == 108 && frameCount % 2300 > 101) bullets.add(new bullet(width/3-151, 400 + 83, "cenp", false));
  if(frameCount % 1900 == 114 && frameCount % 2300 > 107) bullets.add(new bullet(width/3-170, 400 + 40, "cenp", false));
  if(frameCount % 1900 == 120 && frameCount % 2300 > 113) bullets.add(new bullet(width/3-175, 400, "cenp", false));
  if(frameCount % 1900 == 126 && frameCount % 2300 > 119) bullets.add(new bullet(width/3-170, 400 - 40, "cenp", false));
  if(frameCount % 1900 == 132 && frameCount % 2300 > 125) bullets.add(new bullet(width/3-151, 400 - 83, "cenp", false));
  if(frameCount % 1900 == 138 && frameCount % 2300 > 131) bullets.add(new bullet(width/3-122, 400 - 122, "cenp", false));
  if(frameCount % 1900 == 144 && frameCount % 2300 > 137) bullets.add(new bullet(width/3-83, 400 - 151, "cenp", false)); 
  if(frameCount % 1900 == 150 && frameCount % 2300 > 143) bullets.add(new bullet(width/3-40, 400 - 170, "cenp", false));
  
  if(frameCount % 1900 == 156) bullets.add(new bullet(width/3, 400 - 175, "cenp", false));
  if(frameCount % 1900 == 162) bullets.add(new bullet(width/3+40, 400 - 170, "cenp", false));
  if(frameCount % 1900 == 168) bullets.add(new bullet(width/3+83, 400 - 151, "cenp", false));
  if(frameCount % 1900 == 174) bullets.add(new bullet(width/3+122, 400 - 122, "cenp", false));
  if(frameCount % 1900 == 180) bullets.add(new bullet(width/3+151, 400 - 83, "cenp", false));
  if(frameCount % 1900 == 186) bullets.add(new bullet(width/3+170, 400 - 40, "cenp", false));
  if(frameCount % 1900 == 192) bullets.add(new bullet(width/3+175, 400, "cenp", false));
  if(frameCount % 1900 == 198) bullets.add(new bullet(width/3+170, 400 + 40, "cenp", false));
  if(frameCount % 1900 == 204) bullets.add(new bullet(width/3+151, 400 + 83, "cenp", false));
  if(frameCount % 1900 == 210) bullets.add(new bullet(width/3+122, 400 + 122, "cenp", false));
  if(frameCount % 1900 == 216) bullets.add(new bullet(width/3+83, 400 + 151, "cenp", false));
  if(frameCount % 1900 == 222) bullets.add(new bullet(width/3+40, 400 + 170, "cenp", false));
  if(frameCount % 1900 == 228) bullets.add(new bullet(width/3, 400 + 175, "cenp", false));
  if(frameCount % 1900 == 234) bullets.add(new bullet(width/3-40, 400 + 170, "cenp", false));
  if(frameCount % 1900 == 240) bullets.add(new bullet(width/3-83, 400 + 151, "cenp", false));
  if(frameCount % 1900 == 246) bullets.add(new bullet(width/3-122, 400 + 122, "cenp", false));
  if(frameCount % 1900 == 250) bullets.add(new bullet(width/3-151, 400 + 83, "cenp", false));
  if(frameCount % 1900 == 256) bullets.add(new bullet(width/3-170, 400 + 40, "cenp", false));
  if(frameCount % 1900 == 262) bullets.add(new bullet(width/3-175, 400, "cenp", false));
  if(frameCount % 1900 == 268) bullets.add(new bullet(width/3-170, 400 - 40, "cenp", false));
  if(frameCount % 1900 == 274) bullets.add(new bullet(width/3-151, 400 - 83, "cenp", false));
  if(frameCount % 1900 == 280) bullets.add(new bullet(width/3-122, 400 - 122, "cenp", false));
  if(frameCount % 1900 == 286) bullets.add(new bullet(width/3-83, 400 - 151, "cenp", false)); 
  if(frameCount % 1900 == 292) bullets.add(new bullet(width/3-40, 400 - 170, "cenp", false));
}

void streambulletsbot(String place, int shift, String direct, int cnt){
  if(place == "bottom"){
    if(frameCount - cnt == 0) bullets.add(new bullet(width/3+shift-100, 400+120, direct, false));
    if(frameCount - cnt == 3) bullets.add(new bullet(width/3+shift-80, 400+120, direct, false));
    if(frameCount - cnt == 6) bullets.add(new bullet(width/3+shift-60, 400+120, direct, false));
    if(frameCount - cnt == 9) bullets.add(new bullet(width/3+shift-40, 400+120, direct, false));
    if(frameCount - cnt == 12) bullets.add(new bullet(width/3+shift-20, 400+120, direct, false));
    if(frameCount - cnt == 15) bullets.add(new bullet(width/3+shift, 400+120, direct, false));
    if(frameCount - cnt == 18) bullets.add(new bullet(width/3+shift+20, 400+120, direct, false));
    if(frameCount - cnt == 21) bullets.add(new bullet(width/3+shift+40, 400+120, direct, false));
    if(frameCount - cnt == 24) bullets.add(new bullet(width/3+shift+60, 400+120, direct, false));
    if(frameCount - cnt == 27) bullets.add(new bullet(width/3+shift+80, 400+120, direct, false));
    if(frameCount - cnt == 30) bullets.add(new bullet(width/3+shift+100, 400+120, direct, false));
  }
  if(place == "top"){
    if(frameCount - cnt == 0) bullets.add(new bullet(width/3+shift-100, 400-120, direct, false));
    if(frameCount - cnt == 3) bullets.add(new bullet(width/3+shift-80, 400-120, direct, false));
    if(frameCount - cnt == 6) bullets.add(new bullet(width/3+shift-60, 400-120, direct, false));
    if(frameCount - cnt == 9) bullets.add(new bullet(width/3+shift-40, 400-120, direct, false));
    if(frameCount - cnt == 12) bullets.add(new bullet(width/3+shift-20, 400-120, direct, false));
    if(frameCount - cnt == 15) bullets.add(new bullet(width/3+shift, 400-120, direct, false));
    if(frameCount - cnt == 18) bullets.add(new bullet(width/3+shift+20, 400-120, direct, false));
    if(frameCount - cnt == 21) bullets.add(new bullet(width/3+shift+40, 400-120, direct, false));
    if(frameCount - cnt == 24) bullets.add(new bullet(width/3+shift+60, 400-120, direct, false));
    if(frameCount - cnt == 27) bullets.add(new bullet(width/3+shift+80, 400-120, direct, false));
    if(frameCount - cnt == 30) bullets.add(new bullet(width/3+shift+100, 400-120, direct, false));
  }
}

void bigburst(int shift, String direct){
  for(int i = -100; i < 101; i += 100){
    bullets.add(new bullet(width/3+shift+i, 400-120, direct, false));
  }
  for(int i = -100; i < 101; i += 100){
    bullets.add(new bullet(width/3+shift+i, 400+120, direct, false));
  }
  for(int i = -100; i < 101; i += 100){
    bullets.add(new bullet(width/3+shift-120, 400+i, direct, false));
  }
  for(int i = -100; i < 101; i += 100){
    bullets.add(new bullet(width/3+shift+120, 400+i, direct, false));
  }
}
void littleburst(int shift, String direct){
  for(int i = -40; i < 41; i += 40){
    bullets.add(new bullet(width/3+shift+i, 400-120, direct, false));
  }
  for(int i = -40; i < 41; i += 40){
    bullets.add(new bullet(width/3+shift+i, 400+120, direct, false));
  }
  for(int i = -40; i < 41; i += 40){
    bullets.add(new bullet(width/3+shift-120, 400+i, direct, false));
  }
  for(int i = -40; i < 41; i += 40){
    bullets.add(new bullet(width/3+shift+120, 400+i, direct, false));
  }
}

int randomize;
void buttons(){
  noFill();
  strokeWeight(2);
  stroke(255, 100);
  if(dist(mouseX, mouseY, width/2-75, 75) < 30){ 
    stroke(255);
    if(mousePressed && streamcnt == 900){
      randomize = round(random(1));
      currfc = frameCount;
      cntstr = true;
      streamcnt = 0;
    }
  }
  if(cntstr == true && frameCount - currfc < 32){
    if(randomize == 1) streambulletsbot("bottom", width/3, "bot", currfc);
    if(randomize == 0) streambulletsbot("top", width/3, "bot", currfc);
  }
  if(frameCount - currfc > 31){
    cntstr = false;
  }
  ellipse(width/2-75, 75, 4, 4);
  ellipse(width/2-85, 75, 4, 4);
  ellipse(width/2-95, 75, 4, 4);
  ellipse(width/2-65, 75, 4, 4);
  ellipse(width/2-55, 75, 4, 4);
  
  ellipse(width/2-75, 75, 60, 60);
  
  stroke(255, 100);
  if(dist(mouseX, mouseY, width/2, 75) < 30){ 
    stroke(255);
    if(mousePressed && bburstcnt == 1200){
      bburstcnt = 0;
      bigburst(width/3, "bot");
    }
  }
  ellipse(width/2 + 10, 75 - 10, 4, 4);
  ellipse(width/2 - 10, 75 - 10, 4, 4);
  ellipse(width/2 - 10, 75 + 10, 4, 4);
  ellipse(width/2 + 10, 75 + 10, 4, 4);
  
  ellipse(width/2, 75, 60, 60);
  
  stroke(255, 100);
  if(dist(mouseX, mouseY, width/2 + 75, 75) < 30){ 
    stroke(255);
    if(mousePressed && lburstcnt == 1200){
      lburstcnt = 0;
      littleburst(width/3, "bot");
    }
  }
  ellipse(width/2 + 85, 75, 4, 4);
  ellipse(width/2 + 65, 75, 4, 4);
  ellipse(width/2 + 75, 75 - 10, 4, 4);
  ellipse(width/2 + 75, 75 + 10, 4, 4);
  
  ellipse(width/2 + 75, 75, 60, 60);
  
  stroke(255, 100);
  if(dist(mouseX, mouseY, width/2, 175) < 30){ 
    stroke(255);
    if(mousePressed && circcnt == 1600){
      circcnt = 0;
      circp = new bulletcircle("cenb", 267, 8);
      circle = new bulletcircle("cenp", 0, 8);
    }
  }
  ellipse(width/2 + 8, 175, 4, 4);
  ellipse(width/2 - 8, 175, 4, 4);
  ellipse(width/2, 175 - 8, 4, 4);
  ellipse(width/2, 175 + 8, 4, 4);
  
  ellipse(width/2, 175, 60, 60);
  
  rectMode(CORNER);
  noStroke();
  fill(255, 155);
  rect(width/2 - 100, 15, 50, 20);
  rect(width/2 - 25, 15, 50, 20);
  rect(width/2 + 50, 15, 50, 20);
  rect(width/2 - 25, 115, 50, 20);
  
  rect(width/2 - 100, 15, streamcnt / 18, 20);
  rect(width/2 - 25, 15, bburstcnt / 24, 20);
  rect(width/2 + 50, 15, lburstcnt / 24, 20);
  rect(width/2 - 25, 115, circcnt / 32, 20);
}

void heart (){
  noStroke();
  fill(255 - heartcolour, 0, 0);
  beginShape();
  vertex(player.x, player.y - 4);
  vertex(player.x + 1, player.y - 4);
  vertex(player.x + 1, player.y - 6);
  vertex(player.x + 2, player.y - 6);
  vertex(player.x + 2, player.y - 7);
  vertex(player.x + 4, player.y - 7);
  vertex(player.x + 4, player.y - 8);
  vertex(player.x + 6, player.y - 8);
  vertex(player.x + 6, player.y - 7);
  vertex(player.x + 7, player.y - 7);
  vertex(player.x + 7, player.y - 6);
  vertex(player.x + 8, player.y - 6);
  vertex(player.x + 8, player.y + 2);
  vertex(player.x + 6, player.y + 2);
  vertex(player.x + 6, player.y + 4);
  vertex(player.x + 4, player.y + 4);
  vertex(player.x + 4, player.y + 6);
  vertex(player.x + 2, player.y + 6);
  vertex(player.x + 2, player.y + 8);
  vertex(player.x, player.y + 8);
  endShape();
  rectMode(CORNER);
  rect(player.x - 1, player.y - 4, 2, 12);
  rectMode(CENTER);
  beginShape();
  vertex(player.x, player.y - 4);
  vertex(player.x - 1, player.y - 4);
  vertex(player.x - 1, player.y - 6);
  vertex(player.x - 2, player.y - 6);
  vertex(player.x - 2, player.y - 7);
  vertex(player.x - 4, player.y - 7);
  vertex(player.x - 4, player.y - 8);
  vertex(player.x - 6, player.y - 8);
  vertex(player.x - 6, player.y - 7);
  vertex(player.x - 7, player.y - 7);
  vertex(player.x - 7, player.y - 6);
  vertex(player.x - 8, player.y - 6);
  vertex(player.x - 8, player.y + 2);
  vertex(player.x - 6, player.y + 2);
  vertex(player.x - 6, player.y + 4);
  vertex(player.x - 4, player.y + 4);
  vertex(player.x - 4, player.y + 6);
  vertex(player.x - 2, player.y + 6);
  vertex(player.x - 2, player.y + 8);
  vertex(player.x, player.y + 8);
  endShape();
  
  heartcolour *= 0.9;
}

void botheart(){
  noStroke();
  fill(botcol+155, botcol+155, botcol+155);
  beginShape();
  vertex(botpos.x, botpos.y - 4);
  vertex(botpos.x + 1, botpos.y - 4);
  vertex(botpos.x + 1, botpos.y - 6);
  vertex(botpos.x + 2, botpos.y - 6);
  vertex(botpos.x + 2, botpos.y - 7);
  vertex(botpos.x + 4, botpos.y - 7);
  vertex(botpos.x + 4, botpos.y - 8);
  vertex(botpos.x + 6, botpos.y - 8);
  vertex(botpos.x + 6, botpos.y - 7);
  vertex(botpos.x + 7, botpos.y - 7);
  vertex(botpos.x + 7, botpos.y - 6);
  vertex(botpos.x + 8, botpos.y - 6);
  vertex(botpos.x + 8, botpos.y + 2);
  vertex(botpos.x + 6, botpos.y + 2);
  vertex(botpos.x + 6, botpos.y + 4);
  vertex(botpos.x + 4, botpos.y + 4);
  vertex(botpos.x + 4, botpos.y + 6);
  vertex(botpos.x + 2, botpos.y + 6);
  vertex(botpos.x + 2, botpos.y + 8);
  vertex(botpos.x, botpos.y + 8);
  endShape();
  rectMode(CORNER);
  rect(botpos.x - 1, botpos.y - 4, 2, 12);
  rectMode(CENTER);
  beginShape();
  vertex(botpos.x, botpos.y - 4);
  vertex(botpos.x - 1, botpos.y - 4);
  vertex(botpos.x - 1, botpos.y - 6);
  vertex(botpos.x - 2, botpos.y - 6);
  vertex(botpos.x - 2, botpos.y - 7);
  vertex(botpos.x - 4, botpos.y - 7);
  vertex(botpos.x - 4, botpos.y - 8);
  vertex(botpos.x - 6, botpos.y - 8);
  vertex(botpos.x - 6, botpos.y - 7);
  vertex(botpos.x - 7, botpos.y - 7);
  vertex(botpos.x - 7, botpos.y - 6);
  vertex(botpos.x - 8, botpos.y - 6);
  vertex(botpos.x - 8, botpos.y + 2);
  vertex(botpos.x - 6, botpos.y + 2);
  vertex(botpos.x - 6, botpos.y + 4);
  vertex(botpos.x - 4, botpos.y + 4);
  vertex(botpos.x - 4, botpos.y + 6);
  vertex(botpos.x - 2, botpos.y + 6);
  vertex(botpos.x - 2, botpos.y + 8);
  vertex(botpos.x, botpos.y + 8);
  endShape();
  
  botcol *= 0.9;
}

void heartgraphic (float x, float y, color col){
  pushMatrix();
  translate(-x, -y);
  noStroke();
  fill(col);
  beginShape();
  vertex(x, y - 4);
  vertex(x + 1, y - 4);
  vertex(x + 1, y - 6);
  vertex(x + 2, y - 6);
  vertex(x + 2, y - 7);
  vertex(x + 4, y - 7);
  vertex(x + 4, y - 8);
  vertex(x + 6, y - 8);
  vertex(x + 6, y - 7);
  vertex(x + 7, y - 7);
  vertex(x + 7, y - 6);
  vertex(x + 8, y - 6);
  vertex(x + 8, y + 2);
  vertex(x + 6, y + 2);
  vertex(x + 6, y + 4);
  vertex(x + 4, y + 4);
  vertex(x + 4, y + 6);
  vertex(x + 2, y + 6);
  vertex(x + 2, y + 8);
  vertex(x, y + 8);
  endShape();
  rectMode(CORNER);
  rect(x - 1, y - 4, 2, 12);
  rectMode(CENTER);
  beginShape();
  vertex(x, y - 4);
  vertex(x - 1, y - 4);
  vertex(x - 1, y - 6);
  vertex(x - 2, y - 6);
  vertex(x - 2, y - 7);
  vertex(x - 4, y - 7);
  vertex(x - 4, y - 8);
  vertex(x - 6, y - 8);
  vertex(x - 6, y - 7);
  vertex(x - 7, y - 7);
  vertex(x - 7, y - 6);
  vertex(x - 8, y - 6);
  vertex(x - 8, y + 2);
  vertex(x - 6, y + 2);
  vertex(x - 6, y + 4);
  vertex(x - 4, y + 4);
  vertex(x - 4, y + 6);
  vertex(x - 2, y + 6);
  vertex(x - 2, y + 8);
  vertex(x, y + 8);
  endShape();
  popMatrix();
}

void closelines(){
  noFill();
  stroke(255, tooclose);
  strokeWeight(2);
  ellipse(player.x-1, player.y-1, 70, 70);
  ellipse(botpos.x-1, botpos.y-1, 70, 70);
  
  tooclose *= 0.94;
}
