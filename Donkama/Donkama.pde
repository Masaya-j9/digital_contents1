int cnt1 = 0;
int cnt2 = 0;
int tnp1 = 15;
int tnp2 = 10;

int r = 50;

void setup(){
  size(400,300);
  frameRate(20);
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
  
  cnt1--;
  cnt2--;
}

void keyPressed(){
    if(key == 'f'){
      cnt1 = tnp1;
    }
    if(key == 'j'){
      cnt2 = tnp2;
    }
}
