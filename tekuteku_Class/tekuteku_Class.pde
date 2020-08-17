//初期設定
//何か変更するときはここをいじってね
int fr = 60; //フレームレート
int sx = 30; // マス目の大きさX
int sy = 30; // マス目の大きさY
int sp = 10; // スピード
String stageName = "Stage_Hard1.txt";// ステージ名

class Tekuteku{
  
  //本プログラム
  int[][] stage = new int[0][0]; //ステージデータ
  int myX,myY;  // 自機の位置
  int myLife;   // 自機ライフ
  int myDirect; // 自機の向き
  int itemCnt;  // アイテムの数
  int score;    // スコア
    
  int speed; // 一マス移動あたりの速さ．大きければ遅い
  int timer = -1; // 移動タイマー．
  int tmpDirect=-1; // 向きの予約．

  boolean gameContinue = false;
  /*********************
  ステージの番号メモ
  0,null = 空間．出たらアウト．
  1      = 道．安全．
  2      = アイテム．全部とれ．
  3      = ゴール．タドリツキナサイ．
  4,5,6,7= 初期スポーン地点．左から上・右・下・左．
  **********************/
  void init(String st, int sp, int lf){
    //初期化設定．
    //引数... st:ステージファイル名 sp:ゲームスピード lf:ライフ
    
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
    //ステージ読み込み．
    //ひきすう filename:ステージファイル名
  
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
    //向き変更かんすう．
    //keyPressedに入れてほしい
    
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
    //ステージ表示関数．
    //軽量化のために，画面内のモノだけ描写するようにしたい．
    //引数　dx,dy:move()用の座標ずれ
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
    //一マス一マスの描写関数．
    //引数 x,y:座標 type:マス目情報．上記参照
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
    //移動関数．
    //ゲームスピードに合わせて疑似なめらか移動を行う．
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
    //移動後処理関数．
    //移動した先が何かで処理を変えましょう．
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
    //ゲームオーバー処理．
    //ひっきすう clear:クリアか否か．
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
