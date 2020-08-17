int[] accuracyData = {15,10};//Good / normal


class Donkama{
  int tapN = 2; //tapper Num
  int[] tapBPM; //as Name
  int[] tapCnt; //BPMcnt
  String[] tapKey; //as Name

  int[] tapX; //as Name
  int[] tapY; //as Name
  int   tapR; //as Name

  int life; //my Life
  int score; //as Name
  int invCnt; //Muteki Cnt

  boolean ingame; // is Gaming?
  void init(){
    ingame = false;
    life = 3;
    score = 0;
    tapBPM = new int[tapN];
    tapCnt = new int[tapN];
    tapKey = new String[tapN];
    tapX = new int[tapN];
    tapY = new int[tapN];
    tapR = 50;
    for(int i=0; i<tapN; i++){
      tapBPM[i] = int(random(30,200));
      tapCnt[i] = 0;
    
      boolean isin;
      do{
        tapX[i] = int(random(tapR,width-tapR));
        tapY[i] = int(random(tapR,height-tapR));
        isin = false;
        for(int j=0; j<i; j++){
          if(dist(tapX[i],tapY[i],tapX[j],tapY[j]) < tapR*2)isin=true;
        }
      }while(isin);
      
      String tmp;
      do{
        tmp = str(char(int(random(int('a'),int('z')+1))));
        isin = false;
        for(int j=0;j<i;j++){
          if(tmp == tapKey[j])isin = true;
        }
      }while(isin);
      tapKey[i] = tmp;
    }
    invCnt = 0;
    
    tapBPM[0]=60;
    tapBPM[1]=75;
    
    background(0);
    move();
    text("Press the Enter",width/2,height/2);
  }

  void move(){
    background(0);
    
    for(int i=0; i<tapN; i++){
      if(invCnt>0)fill(150,150,250);
      else fill(150);
      ellipse(tapX[i],tapY[i],tapR*2,tapR*2);
      textAlign(CENTER,CENTER);
      fill(255);
      textSize(25);
      text(tapKey[i],tapX[i],tapY[i]);
      tapCnt[i]+=1;
      noFill();
      ellipse(tapX[i],tapY[i],(tapR+(tapBPM[i]-tapCnt[i]))*2,(tapR+(tapBPM[i]-tapCnt[i]))*2);
      
      if(tapBPM[i] - tapCnt[i] < -accuracyData[0]){
        miss();
        tapCnt[i] -= tapBPM[i];
      }
    }
      textAlign(LEFT,BOTTOM);
    text("Life:"+life,0,height);
      textAlign(RIGHT,BOTTOM);
    text("Score:"+score,width,height);
    
    if(invCnt > 0)invCnt --;
  }

  void tap(char keychar){
    if(keyCode == ENTER)ingame=true;
    int k=-1;
    for(int i = 0; i<tapN; i++){
      if(keychar == tapKey[i].charAt(0))k=i;
    }if(k==-1)return;
  
    print(k);
    if(abs(tapBPM[k] - tapCnt[k]) < accuracyData[1]){
      if(invCnt <= 0)score += (accuracyData[1]-abs(tapBPM[k] - tapCnt[k]))*5;
      tapCnt[k] -= tapBPM[k];
    }else if(abs(tapBPM[k] - tapCnt[k]) < accuracyData[0]){
      miss();
      tapCnt[k] -= tapBPM[k];
    }
  }  

  void miss(){
    if(invCnt <= 0){
    if(life <= 0){gameover();return;}
      life --;
      invCnt = 90;
    }
  }
  void gameover(){
    ingame = false;
    text("GAMEOVER\nscore:"+score,width/2,height/2);
  }

}

Donkama dnkm;

void setup(){
  size(1280,720);
  stroke(255);
  frameRate(30);
  dnkm = new Donkama();
  dnkm.init();
}

void draw(){
  if(dnkm.ingame)dnkm.move();
}

void keyPressed(){
  dnkm.tap(key);
}
