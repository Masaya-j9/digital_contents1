int selectButtonFlag;
PImage doncamaButton, doncamaHoverButton, 
  teqteqButton, teqteqHoverButton, 
  howPalotButton, howPalotHoverButton;
PImage easyButton, easyHoverButton, 
  normalButton, normalHoverButton, 
  hardButton, hardHoverButton; 
PImage backDiffButton, backDiffHoverButton, 
  backMainButton, backMainHoverButton, 
  restartButton, restartHoverButton;
PImage level, game;
int imageSizeX = 200, imageSizeY = 100;
int interval = 350;
int choice;
int diffChoice;
int endChoice;
int diffLevel;
int gameName;
int gseq;
int leftButtonX, leftButtonY, 
  middleButtonX, middleButtonY, 
  rightButtonX, rightButtonY;
int startTitleX, startTitleY;
int diffTitleX, diffTitleY;
int endTitleX, endTitleY;
String scene = "end";

////////////////////////donkama

Donkama dnkm;

int[] accuracyData = {15, 10};//Good / normal

class Donkama {
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

  boolean ingame = false;
  void init(int lf, int n) {
    ingame = false;
    life = lf;
    tapN = n;
    score = 0;
    tapBPM = new int[tapN];
    tapCnt = new int[tapN];
    tapKey = new String[tapN];
    tapX = new int[tapN];
    tapY = new int[tapN];
    tapR = 50;
    for (int i=0; i<tapN; i++) {
      tapBPM[i] = int(random(30, 200));
      tapCnt[i] = 0;

      boolean isin;
      do {
        tapX[i] = int(random(tapR, width-tapR));
        tapY[i] = int(random(tapR, height-tapR));
        isin = false;
        for (int j=0; j<i; j++) {
          if (dist(tapX[i], tapY[i], tapX[j], tapY[j]) < tapR*2)isin=true;
        }
      } while (isin);

      String tmp;
      do {
        tmp = str(char(int(random(int('a'), int('z')+1))));
        isin = false;
        for (int j=0; j<i; j++) {
          if (tmp == tapKey[j])isin = true;
        }
      } while (isin);
      tapKey[i] = tmp;
    }
    invCnt = 0;

    tapBPM[0]=60;
    tapBPM[1]=75;

    background(0);
    move();
    text("Press the Enter", width/2, height/2);
  }
  
  void now(){
    background(0);
    for (int i=0; i<tapN; i++) {
      ellipse(tapX[i], tapY[i], tapR*2, tapR*2);
      textAlign(CENTER, CENTER);
      fill(255);
      textSize(25);
      text(tapKey[i], tapX[i], tapY[i]);
      noFill();
      stroke(255,255,255);
      ellipse(tapX[i], tapY[i], (tapR+(tapBPM[i]-tapCnt[i]))*2, (tapR+(tapBPM[i]-tapCnt[i]))*2);
    }
    textAlign(LEFT, BOTTOM);
    text("Life:"+life, 0, height);
    textAlign(RIGHT, BOTTOM);
    text("Score:"+score, width, height);
    text("Press the Enter", width/2, height/2);
  }

  void move() {
    background(0);

    for (int i=0; i<tapN; i++) {
      if (invCnt>0)fill(150, 150, 250);
      else fill(150);
      ellipse(tapX[i], tapY[i], tapR*2, tapR*2);
      textAlign(CENTER, CENTER);
      fill(255);
      textSize(25);
      text(tapKey[i], tapX[i], tapY[i]);
      tapCnt[i]+=1;
      noFill();
      stroke(255,255,255);
      ellipse(tapX[i], tapY[i], (tapR+(tapBPM[i]-tapCnt[i]))*2, (tapR+(tapBPM[i]-tapCnt[i]))*2);

      if (tapBPM[i] - tapCnt[i] < -accuracyData[0]) {
        miss();
        tapCnt[i] -= tapBPM[i];
      }
    }
    textAlign(LEFT, BOTTOM);
    text("Life:"+life, 0, height);
    textAlign(RIGHT, BOTTOM);
    text("Score:"+score, width, height);

    if (invCnt > 0)invCnt --;
  }

  void tap(char keychar) {
    if (keyCode == ENTER)ingame=true;
    int k=-1;
    for (int i = 0; i<tapN; i++) {
      if (keychar == tapKey[i].charAt(0))k=i;
    }
    if (k==-1)return;

    print(k);
    if (abs(tapBPM[k] - tapCnt[k]) < accuracyData[1]) {
      if (invCnt <= 0)score += (accuracyData[1]-abs(tapBPM[k] - tapCnt[k]))*5;
      tapCnt[k] -= tapBPM[k];
    } else if (abs(tapBPM[k] - tapCnt[k]) < accuracyData[0]) {
      miss();
      tapCnt[k] -= tapBPM[k];
    }
  }  

  void miss() {
    if (invCnt <= 0) {
      if (life <= 0) {
        gameover();
        return;
      }
      life --;
      invCnt = 90;
    }
  }
  void gameover() {
    ingame = false;
    text("GAMEOVER\nscore:"+score, width/2, height/2);
    gseq = 11;
  }
}

////////////////////////

/////////////////////// tekuteku
//Setting

int fr = 60; // Frame Rate
int sx = 30; // mass Size X
int sy = 30; // mass Size Y
int sp = 10; // Game Speed
String stageName = "Stage_Hard1.txt";// Stage Name

Tekuteku teck;

class Tekuteku {
  int[][] stage = new int[0][0]; //stage Data
  int myX, myY;  // XY
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

  void init(String st, int sp, int lf) {
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

  void loadStage(String filename) {
    //filename:File Name

    String[] lines = loadStrings(filename);
    for (int i=0; i<lines.length; i++) {
      int[] tmp = new int[0];
      for (int j=0; j<lines[i].length(); j++) {
        tmp =(int[])append(tmp, int(lines[i].charAt(j))-48);
        if (tmp[j] == 2)itemCnt ++;
        if (tmp[j] >= 4 && tmp[j] <= 7) {
          myX = j;
          myY = i;
          myDirect = tmp[j] - 4;
        }
      }
      stage = (int[][])append(stage, tmp);
    }
  }

  void turn() {
    //Prease enter KeyPressed()

    if (keyCode == UP) {
      myDirect = 0;
    } else if (keyCode == RIGHT) {
      myDirect = 1;
    } else if (keyCode == DOWN) {
      myDirect = 2;
    } else if (keyCode == LEFT) {
      myDirect = 3;
    }
  }

  void showStage(int dx, int dy) {
    //軽量化のために，画面内のモノだけ描写するようにしたい．
    //dx,dy:CoordinateGap for move()
    background(0);
    int wCnt = width/sx+2;
    int hCnt = height/sy+2;

    showBlock(width/2+dx, height/2+dy, stage[myY][myX]);
    for (int i=0; i<=hCnt/2; i++) {
      for (int j=0; j<=wCnt/2; j++) {
        try {
          showBlock(width/2+dx + sx*j, height/2+dy + sy*i, stage[myY+i][myX+j]);
        }
        catch(Exception e) {
        }
        try {
          showBlock(width/2+dx - sx*j, height/2+dy + sy*i, stage[myY+i][myX-j]);
        }
        catch(Exception e) {
        }
        try {
          showBlock(width/2+dx + sx*j, height/2+dy - sy*i, stage[myY-i][myX+j]);
        }
        catch(Exception e) {
        }
        try {
          showBlock(width/2+dx - sx*j, height/2+dy - sy*i, stage[myY-i][myX-j]);
        }
        catch(Exception e) {
        }
      }
    }
    fill(255);
    ellipse(width/2, height/2, sx, sy);
    textAlign(LEFT, BOTTOM);
    textSize(30);
    text("Life:"+myLife, 0, height);
  }
  void showBlock(int x, int y, int type) {
    //x,y:Coordinate type:mass Type
    noStroke();
    rectMode(CENTER);

    switch(type) {
    case 2:
      fill(255);
      rect(x, y, sx, sy);
      fill(0, 128, 255);
      ellipse(x, y, sx/2, sy/2);
      break;

    case 3:
      if (itemCnt > 0) {
        fill(255);
        rect(x, y, sx, sy);
      } else {
        fill(200, 255, 64);
        rect(x, y, sx, sy);
      }
      break;

    case 1:
    case 4:
    case 5:
    case 6:
    case 7:
      fill(255);
      rect(x, y, sx, sy);
      break;

    default:
    }

    rectMode(CORNER);
    stroke(1);
  }  

  void move() {
    //move
    if (timer >= speed) {
      timer = 0;
      switch(tmpDirect) {
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
      showStage(0, 0);
      tmpDirect = -1;
      movedProcessing();
    }
    if (gameContinue) {
      if (tmpDirect==-1)tmpDirect = myDirect;
      switch(tmpDirect) {
      case 0:
        showStage(0, sy * timer / speed);
        break;
      case 1:
        showStage(-sx * timer / speed, 0);
        break;
      case 2:
        showStage(0, -sy * timer / speed);
        break;
      case 3:
        showStage(sx * timer / speed, 0);
      }
      timer++;
    }
  }

  void movedProcessing() {
    //moved Process
    int type = stage[myY][myX];
    switch(type) {
    case 2:
      score += 100;
      stage[myY][myX] = 1;
      itemCnt --;
      break;

    case 3:
      if (itemCnt <= 0) {
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

  void miss() {
    if (myLife <= 0) {
      gameover(false);
    } else {
      gameContinue = false;
      textSize(100);
      fill(200, 0, 0);
      text("MISS! Press The Enter", width/2-500, height/2+10);
      textSize(16);
    }
  }

  void gameover(boolean clear) {
    // clear:is Clear?
    textSize(100);
    if (clear) {
      fill(200, 200, 100);
    } else {
      fill(200, 0, 0);
    }
    text("GAME OVER", width/2-200, height/2+10);
    //textSize(16);
    gameContinue = false;
    timer = -1;
    gseq = 11;
  }
}
/////////////////////// 
void loadButton() {
  doncamaButton = loadImage("select_doncama.png");
  doncamaHoverButton = loadImage("select_doncama_hover.png");
  teqteqButton = loadImage("select_teqteq.png");
  teqteqHoverButton = loadImage("select_teqteq_hover.png");
  howPalotButton = loadImage("select_how.png");
  howPalotHoverButton = loadImage("select_how_hover.png");

  easyButton = loadImage("select_easy.png"); 
  easyHoverButton = loadImage("select_easy_hover.png");
  normalButton = loadImage("select_normal.png");
  normalHoverButton = loadImage("select_normal_hover.png");
  hardButton = loadImage("select_hard.png");
  hardHoverButton = loadImage("select_hard_hover.png");

  backDiffButton = loadImage("back_diff.png");
  backDiffHoverButton = loadImage("back_diff_hover.png");
  backMainButton = loadImage("back_main.png");
  backMainHoverButton = loadImage("back_main_hover.png");
  restartButton = loadImage("restart.png");
  restartHoverButton = loadImage("restart_hover.png");

  leftButtonX = width / 4;
  leftButtonY = height * 2 / 3 + 50; 
  middleButtonX = width / 2;
  middleButtonY = height * 2 / 3 + 50;
  rightButtonX = width * 3 / 4;
  rightButtonY = height * 2 / 3 + 50;
  startTitleX = width / 2;
  startTitleY = imageSizeY + 100;
  diffTitleX = width / 2;
  diffTitleY = imageSizeY + 100;
  endTitleX = width / 2;
  endTitleY = imageSizeY + 100;
}



void setup() {
  size(1280, 720);
  dnkm = new Donkama();
  teck = new Tekuteku();
  //teck.loadStage(stageName);
  //teck.showStage(0, 0);
  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER);
  textSize(100);
  loadButton();  
  //dnkm.init();
}

void viewScore() {
  int score = 114514;
  String scr = str(score);
  textSize(128);
  fill(255);
  text(scr, width/4, height/4);
}

void donkamaSet(){
  if(gseq == 2){
    dnkm.move();
    dnkm.init(10,2);   
    noLoop();
    dnkm.ingame = true;    
    //dnkm.init();    
  }  
}

int gameCount = 0;

void draw() {  
  println("gseq: " + gseq);
  println("choice: " + choice);
  println("diffChoice: " + diffChoice);
  println("dnkm.ingame: " + dnkm.ingame);
  println("teck.gameContinue: " + teck.gameContinue);
  println();
  if (gseq == 0) { //game select
    startScreen();
  } else if (gseq == 1) { // diffculty
    diffScreen();
  } else if (gseq == 2) {
    println("gseq = 2");
    //dnkm.init();
    if(dnkm.ingame){
      dnkm.move();
    }else{
      dnkm.now();
    }
    //donkamaSet();    
    //donkama easy
  } else if (gseq == 3) {
    println("gseq = 3");
    //donkamaSet();
    //dnkm.ingame = true; 
    if(dnkm.ingame){
      dnkm.move();
    }else{
      dnkm.now();
    }
    //donkama normal    
  } else if(gseq == 4){
    println("gseq = 4");
    //dnkm.ingame = true; 
    if(dnkm.ingame){
      dnkm.move();
    }else{
      dnkm.now();
    }
    //donkama hard
  } else if(gseq == 5){
    println("gseq = 5");
    // tekuteku easy
    if(teck.timer==-1)teck.showStage(0, 0);
    if(teck.gameContinue){
      teck.move();
    }
  } else if(gseq == 6){
    println("gseq = 6");
    // tekuteku normal
    //teck.showStage(0, 0);
    if(teck.timer==-1)teck.showStage(0, 0);
    if(teck.gameContinue){
      teck.move();
    }
  } else if(gseq == 7){
    println("gseq = 7");
    // tekuteku hard
    //teck.showStage(0, 0);
    if(teck.timer==-1)teck.showStage(0, 0);
    if(teck.gameContinue){
      teck.move();
    }
  } else if(gseq == 8){
    println("gseq = 8");
    // parrot easy
  } else if(gseq == 9){
    println("gseq = 9");
    // parrot normal
  } else if(gseq == 10){
    println("gseq = 10");
    // parrot hard
  } else if(gseq == 11){
    // end
    endScreen();
  }
}

void printScene() {
  println("scene:" + scene);
}

void showStartHover(int choice) {
  if (choice == 1) {
    image(doncamaHoverButton, leftButtonX, leftButtonY);
    image(teqteqButton, middleButtonX, middleButtonY);
    image(howPalotButton, rightButtonX, rightButtonY);
  } else if (choice == 2) {
    image(doncamaButton, leftButtonX, leftButtonY);
    image(teqteqHoverButton, middleButtonX, middleButtonY);
    image(howPalotButton, rightButtonX, rightButtonY);
  } else if (choice == 3) {
    image(doncamaButton, leftButtonX, leftButtonY);
    image(teqteqButton, middleButtonX, middleButtonY);
    image(howPalotHoverButton, rightButtonX, rightButtonY);
  }
  gseq = 1;
  diffScreen();
}

void showDiffHover(int diffChoice) {
  if (diffChoice == 1) {
    image(easyHoverButton, leftButtonX, leftButtonY);
    image(normalButton, middleButtonX, middleButtonY);
    image(hardButton, rightButtonX, rightButtonY);
    if(choice == 1){
      dnkm.init(10,2);
      gseq = 2;
    } else if(choice == 2){
      stageName = "Stage_Easy"+int(random(2)+1)+".txt";
      teck.loadStage(stageName);
      sp=20;
      teck.showStage(0, 0);
      gseq = 5;
    } else if(choice == 3){
      gseq = 8;
    }
  } else if (diffChoice == 2) {
    image(easyButton, leftButtonX, leftButtonY);
    image(normalHoverButton, middleButtonX, middleButtonY);
    image(hardButton, rightButtonX, rightButtonY);
    if(choice == 1){
      dnkm.init(5,2);
      gseq = 3;
    } else if(choice == 2){
      stageName = "Stage_Normal"+int(random(2)+1)+".txt";
      teck.loadStage(stageName);
      sp=10;
      teck.showStage(0, 0);
      gseq = 6;
    } else if(choice == 3){
      gseq = 9;
    }
  } else if (diffChoice == 3) {
    image(easyButton, leftButtonX, leftButtonY);
    image(normalButton, middleButtonX, middleButtonY);
    image(hardHoverButton, rightButtonX, rightButtonY);
    if(choice == 1){
      dnkm.init(10,3);
      gseq = 4;
    } else if(choice == 2){
      stageName = "Stage_Hard"+int(random(2)+1)+".txt";
      teck.loadStage(stageName);
      sp=5;
      teck.showStage(0, 0);
      gseq = 7;
    } else if(choice == 3){
      gseq = 10;
    }
  }
}

void showEndHover(int diffChoice) {
  if (diffChoice == 1) {
    image(backDiffHoverButton, leftButtonX, leftButtonY);
    image(backMainButton, middleButtonX, middleButtonY);
    image(restartButton, rightButtonX, rightButtonY);
  } else if (diffChoice == 2) {
    image(backDiffButton, leftButtonX, leftButtonY);
    image(backMainHoverButton, middleButtonX, middleButtonY);
    image(restartButton, rightButtonX, rightButtonY);
  } else if (diffChoice == 3) {
    image(backDiffButton, leftButtonX, leftButtonY);
    image(backMainButton, middleButtonX, middleButtonY);
    image(restartHoverButton, rightButtonX, rightButtonY);
  }
  gseq = 0;
}

void mousePressed() {
  if (gseq == 0) {
    if (leftButtonY - imageSizeY / 2 <= mouseY  && mouseY <= leftButtonY + imageSizeY / 2) {
      if (leftButtonX - imageSizeX / 2 <= mouseX  && mouseX <= leftButtonX + imageSizeX / 2) {
        choice = 1;
        showStartHover(choice);
        //selectDiff();
      } else if (middleButtonX - imageSizeX / 2 <= mouseX  && mouseX <= middleButtonX + imageSizeX / 2) {
        choice=2;
        showStartHover(choice);
        //Mainscreen();
      } else if (rightButtonX - imageSizeX <= mouseX  && mouseX <= rightButtonX + imageSizeX / 2) {
        choice = 3;
        showStartHover(choice);
      }
      showStartHover(choice);
    }
  } else if (gseq == 1) {
    if (leftButtonY - imageSizeY / 2 <= mouseY  && mouseY <= leftButtonY + imageSizeY / 2) {
      if (leftButtonX - imageSizeX / 2 <= mouseX  && mouseX <= leftButtonX + imageSizeX / 2) {
        diffChoice = 1;
        //showDiffHover(diffChoice);
        //selectDiff();
      } else if (middleButtonX - imageSizeX / 2 <= mouseX  && mouseX <= middleButtonX + imageSizeX / 2) {
        diffChoice = 2;
        //showDiffHover(diffChoice);
        //Mainscreen();
      } else if (rightButtonX - imageSizeX <= mouseX  && mouseX <= rightButtonX + imageSizeX / 2 ) {
        diffChoice = 3;
        //showDiffHover(diffChoice);
      }
    }
    showDiffHover(diffChoice);
  } else if (gseq == 2) {
    if (leftButtonY - imageSizeY / 2 <= mouseY  && mouseY <= leftButtonY + imageSizeY / 2) {
      if (leftButtonX - imageSizeX / 2 <= mouseX  && mouseX <= leftButtonX + imageSizeX / 2) {
        endChoice = 1;
        //showEndHover(diffChoice);
        //selectDiff();
      } else if (middleButtonX - imageSizeX / 2 <= mouseX  && mouseX <= middleButtonX + imageSizeX / 2) {
        endChoice = 2;
        //showDiffHover(diffChoice);
        //Mainscreen();
      } else if (rightButtonX - imageSizeX <= mouseX  && mouseX <= rightButtonX + imageSizeX / 2 ) {
        endChoice = 3;
        //showDiffHover(diffChoice);
      }
    }
    showEndHover(diffChoice);
  }
}  

void setHUD() {
  if (diffLevel == 1) {
    level = loadImage("diff_easy.png");
  } else if (diffLevel == 2) {
    level = loadImage("diff_normal.png");
  } else if (diffLevel == 3) {
    level = loadImage("diff_hard.png");
  }
  if (gameName == 1) {
    game = loadImage("select_doncama.png");
  } else if (gameName == 2) {
    game = loadImage("select_how.png");
  } else if (gameName==3) {
    game = loadImage("select_teqteq.png");
  }
}

void startScreen() {
  background(0);
  //diffLevel = getLevel();
  //gameName = getGamename();
  setHUD();
  //image(level,1,50);
  //image(game,1,100);
  text("party game!", startTitleX, startTitleY);
  image(doncamaButton, leftButtonX, leftButtonY);
  image(teqteqButton, middleButtonX, middleButtonY);
  image(howPalotButton, rightButtonX, rightButtonY);
  println(choice);
}

void diffScreen() {
  background(0);  
  setHUD();
  text("Please select the difficulty", diffTitleX, diffTitleY);
  image(easyButton, leftButtonX, leftButtonY);
  image(normalButton, middleButtonX, middleButtonY);
  image(hardButton, rightButtonX, rightButtonY);
}

void endScreen() {
  background(0);
  setHUD();
  text("Game Over!", endTitleX, endTitleY);
  image(backDiffButton, leftButtonX, leftButtonY);
  image(backMainButton, middleButtonX, middleButtonY);
  image(restartButton, rightButtonX, rightButtonY);
}

void mouseReleased() {
  if (gseq == 0) {
    if (leftButtonY - imageSizeY / 2 <= mouseY  && mouseY <= leftButtonY + imageSizeY / 2) {
      if (leftButtonX - imageSizeX / 2 <= mouseX  && mouseX <= leftButtonX + imageSizeX / 2) {
        println("choice:" + choice);
        choice = 1;
        //image(backDiffHover, width/2-100-interval, height/2-50);
        redraw();      
        //selectDiff();
      } else if (middleButtonX - imageSizeX / 2 <= mouseX  && mouseX <= middleButtonX + imageSizeX / 2) {
        println("choice:" + choice);
        choice=2;
        //image(backMainHover, width/2-100, height/2-50);
        redraw();
        //Mainscreen();
      } else if (rightButtonX - imageSizeX <= mouseX  && mouseX <= rightButtonX + imageSizeX / 2 ) {
        println("choice:" + choice);
        choice = 3;
        //image(restartHover, width/2-100+interval, height/2-50);
        redraw();
        //startGame();
        //endScreen();
      }
    }
  } else if (gseq == 1) {
    if (leftButtonY - imageSizeY / 2 <= mouseY  && mouseY <= leftButtonY + imageSizeY / 2) {
      if (leftButtonX - imageSizeX / 2 <= mouseX  && mouseX <= leftButtonX + imageSizeX / 2) {
        println("choice1111:" + choice);
        diffChoice = 1;
        //image(backDiffHover, width/2-100-interval, height/2-50);
        redraw();      
        //selectDiff();
      } else if (middleButtonX - imageSizeX / 2 <= mouseX  && mouseX <= middleButtonX + imageSizeX / 2) {
        println("choice2222:" + choice);
        diffChoice=2;
        //image(backMainHover, width/2-100, height/2-50);
        redraw();
        //Mainscreen();
      } else if (rightButtonX - imageSizeX <= mouseX  && mouseX <= rightButtonX + imageSizeX / 2 ) {
        println("choice3333:" + choice);
        diffChoice = 3;
        //image(restartHover, width/2-100+interval, height/2-50);
        redraw();
        //startGame();
        //endScreen();
      }
    }
  } else if (gseq == 2) {
  }

  redraw();
  background(0);
  println("diffChoiceaaa:" + diffChoice);
  //showDiffHover(diffChoice);  
  //if (choice == 1) {    
  //  showDiffHover(diffChoice);
  //} else if (choice == 2) {    
  //  showDiffHover(diffChoice);
  //} else {    
  //  showDiffHover(diffChoice);
  //}
  //choice = 100;
  //donkamaSet();
}

void keyPressed() {
  loop();
  if(gseq == 2 || gseq == 3 || gseq == 4){
    dnkm.tap(key);
  }
  if(gseq == 5 || gseq == 6 || gseq == 7){
    teck.turn();
    if (keyCode == ENTER) {
      if (teck.timer == -1)teck.init(stageName, sp, 3);
      else teck.init(stageName, sp, teck.myLife-1);
    }
  }
}
