int[][] stage = new int[0][0];
int myX,myY;  // 自機の位置
int myLife;   // 自機ライフ
int myDirect; // 自機の向き
int itemCnt;  // アイテムの数
int score;    // スコア

int sx=40,sy = 40; // マス目の大きさ
  
int speed; // 一マス移動あたりの速さ．大きければ遅い
int timer; // 移動タイマー．
int tmpDirect=-1; // 向きの予約．
  /*********************
  ステージの番号メモ
  0,null = 空間．出たらアウト．
  1      = 道．安全．
  2      = アイテム．全部とれ．
  3      = ゴール．タドリツキナサイ．
  4,5,6,7= 初期スポーン地点．左から上・右・下・左．
  **********************/
void init(String st, int sp){
  //初期化設定．
  //引数... st:ステージファイル名 sp:ゲームスピード
  
  loadStage(st);
  speed = sp;
  myLife = 3;
  score = 0;
  timer = 0;
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

void fileimage(int x,int y,String filename){
  //画像読み込み関数
  //今のところ使う予定なし．
  //ひきすう x:表示座標x　ｙ：表示座標y filename:画像ファイル名
  
  PImage img = loadImage(filename);
  image(img,x,y);
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
  ellipse(width/2,height/2,sx,sy);
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

void getItem(){
  //アイテム取得関数．
  //めっちゃ単純だけど関数化．
  stage[myY][myX] = 1;
  itemCnt --;
}

void move(){
  //移動関数．
  //ゲームスピードに合わせ，
  if(tmpDirect==-1)tmpDirect = myDirect;
  if(timer < speed){
    timer++;
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
  }else{
    println(tmpDirect);
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
    showStage(0,0);
    tmpDirect = -1;
  }
}


void setup(){
  size(720,480);
  frameRate(30);
  init("testStage.txt",10);
}
void draw(){
  move();
}

void keyPressed(){
  turn();
}
