//Setting
int fr = 60; // Frame Rate
int sx = 30; // mass Size X
int sy = 30; // mass Size Y
int sp = 10; // Game Speed
String stageName = "Stage_Hard1.txt";// Stage Name

class Tekuteku{
  int[][] stage = new int[0][0]; //stage Data
  int myX,myY;  // XY
  int myLife;   // Life
  int myDirect; // Direct ^0 >1 _2 <3
  int itemCnt;  // items
  int score;    // Score
    
  int speed; // Game Speed (frame/1mass)
  int timer = -1; // move TimerCnt
  int tmpDirect=-1; // Direct Tmp

  boolean gameContinue = false; //is Gaming
  /*********************
  ステージの番号メモ
  0,null = out
  1      = road
  2      = item
  3      = goal
  4,5,6,7= spawn and Direct
  **********************/
  
  void init(String st, int sp, int lf){
    //st:stageName sp:gameSpeed lf:Life
    
    itemCnt = 0;
    speed = sp;
    myLife = lf;
    score = 0;
    timer = 0;
    tmpDirect=-1;
    stage = new int[0][0];
    loadStage(st);
    gameContinue = true;
  }

  void loadStage(String filename){
    //filename:File Name
  
    String[] lines = loadStrings(filename);
    for(int i=0; i<lines.length;i++){
        int[] tmp = new int[0];
        for(int j=0; j<lines[i].length();j++){
          tmp =(int[])append(tmp,int(lines[i].charAt(j))-48);
          if(tmp[j] == 2)itemCnt ++;
          if(tmp[j] >= 4 && tmp[j] <= 7){
            myX = j;
            myY = i;
            myDirect = tmp[j] - 4;
          }
        }
        stage = (int[][])append(stage,tmp);
    }
  }

  void turn(){
    //Prease enter KeyPressed()
    
    if(keyCode == UP){
      myDirect = 0;
    }else if(keyCode == RIGHT){
      myDirect = 1;
    }else if(keyCode == DOWN){
      myDirect = 2;
    }else if(keyCode == LEFT){
      myDirect = 3;
    }
  }

  void showStage(int dx,int dy){
    //軽量化のために，画面内のモノだけ描写するようにしたい．
    //dx,dy:CoordinateGap for move()
    background(0);
    int wCnt = width/sx+2;
    int hCnt = height/sy+2;
    
    showBlock(width/2+dx,height/2+dy,stage[myY][myX]);
    for(int i=0; i<=hCnt/2; i++){
      for(int j=0; j<=wCnt/2; j++){
        try{
          showBlock(width/2+dx + sx*j, height/2+dy + sy*i, stage[myY+i][myX+j]);
        }catch(Exception e){}
        try{
          showBlock(width/2+dx - sx*j, height/2+dy + sy*i, stage[myY+i][myX-j]);
        }catch(Exception e){}
        try{
          showBlock(width/2+dx + sx*j, height/2+dy - sy*i, stage[myY-i][myX+j]);
        }catch(Exception e){}
        try{
          showBlock(width/2+dx - sx*j, height/2+dy - sy*i, stage[myY-i][myX-j]);
        }catch(Exception e){}
      }
    }
    fill(255);
    ellipse(width/2,height/2,sx,sy);
    textAlign(LEFT,BOTTOM);
    textSize(30);
    text("Life:"+myLife,0,height);
  }
  void showBlock(int x, int y,int type){
    //x,y:Coordinate type:mass Type
    noStroke();
    rectMode(CENTER);
    
    switch(type){
      case 2:
      fill(255);
      rect(x,y,sx,sy);
      fill(0,128,255);
      ellipse(x,y,sx/2,sy/2);
      break;
      
      case 3:
      if(itemCnt > 0){
        fill(255);
        rect(x,y,sx,sy);
      }else{
        fill(200,255,64);
        rect(x,y,sx,sy);
      }
      break;
      
      case 1:
      case 4:
      case 5:
      case 6:
      case 7:
      fill(255);
      rect(x,y,sx,sy);
      break;
      
      default:
    }
    
    rectMode(CORNER);
    stroke(1);
  }  

  void move(){
    //move
    if(timer >= speed){
      timer = 0;
      switch(tmpDirect){
        case 0:
        myY--;
        break;
        case 1:
        myX++;
        break;
        case 2:
        myY++;
        break;
        case 3:
        myX--;
      }
      score --;
      showStage(0,0);
      tmpDirect = -1;
      movedProcessing();
    }
    if(gameContinue){
      if(tmpDirect==-1)tmpDirect = myDirect;
      switch(tmpDirect){
        case 0:
        showStage(0,sy * timer / speed);
        break;
        case 1:
        showStage(-sx * timer / speed,0);
        break;
        case 2:
        showStage(0,-sy * timer / speed);
        break;
        case 3:
        showStage(sx * timer / speed,0);
      }
      timer++;
    }
  }

  void movedProcessing(){
    //moved Process
    int type = stage[myY][myX];
    switch(type){
      case 2:
      score += 100;
      stage[myY][myX] = 1;
      itemCnt --;
      break;
      
      case 3:
      if(itemCnt <= 0){
        gameover(true);
      }
      break;
      
      case 1:
      case 4:
      case 5:
      case 6:
      case 7:
      //ただの道
      break;
      
      default:
      miss();
    }
  }

  void miss(){
    if(myLife <= 0){
      gameover(false);
    }else{
      gameContinue = false;
      textSize(100);
      fill(200,0,0);
      text("MISS! Press The Enter",width/2-500,height/2+10);
      textSize(16);
    }
  }

  void gameover(boolean clear){
    // clear:is Clear?
    textSize(100);
    if(clear){
      fill(200,200,100);
    }else{
      fill(200,0,0);
    }
    text("GAME OVER",width/2-200,height/2+10);
    textSize(16);
    gameContinue = false;
    timer = -1;
  }

}

Tekuteku teck;
void setup(){
  size(1280,720);
  frameRate(fr);
  teck = new Tekuteku();
  teck.loadStage(stageName);
  teck.showStage(0,0);
  textSize(100);
  fill(200,200,100);
  text("Press the Enter",width/2-350,height/5+10);
  textSize(16);
}
void draw(){
  if(teck.gameContinue){
    teck.move();
  }
}

void keyPressed(){
  teck.turn();
  if(keyCode == ENTER){
    if(teck.timer == -1)teck.init(stageName,sp,3);
    else teck.init(stageName,sp,teck.myLife-1);
  }
}
