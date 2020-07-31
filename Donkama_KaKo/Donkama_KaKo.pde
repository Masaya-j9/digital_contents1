//ドンカマ：テストプログラム

int cnt1 = 0;
int cnt2 = 0;
int tnp1 = 30;
int tnp2 = 20;

int score = 0;

int r = 50;

void setup(){
  size(400,300);
  frameRate(60);
  cnt1 = tnp1;
  cnt2 = tnp2;
}

void draw(){
  background(255);
  fill(128);
  ellipse(width/4,height/2,r,r);
  ellipse(width*3/4,height/2,r,r);
  
  noFill();
  ellipse(width/4,height/2,r+cnt1*5,r+cnt1*5);
  ellipse(width*3/4,height/2,r+cnt2*5,r+cnt2*5);
  
  text(score,width/2,height/2);
  
  cnt1--;
  cnt2--;
  
  if(cnt1 < -tnp1){
    score += cnt1;
    cnt1 += tnp1;
  }
  if(cnt2 < -tnp2){
    score += cnt2;
    cnt2 += tnp2;
  }
}

void keyPressed(){
    if(key == 'f'){
      score += 10 - abs(cnt1);
      cnt1 = tnp1;
    }
    if(key == 'j'){
      score += 10 - abs(cnt2);
      cnt2 = tnp2;
    }
}
