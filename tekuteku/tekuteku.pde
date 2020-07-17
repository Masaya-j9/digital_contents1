int[][] stage;
int myX,myY;
int myLife;
int myDirect;
int itemCnt;
int score;
  
int speed;
  /*********************
  ステージの番号メモ
  0,null = 空間．出たらアウト．
  1      = 道．安全．
  2      = アイテム．全部とれ．
  3      = ゴール．タドリツキナサイ．
  4,5,6,7= 初期スポーン地点．左から上・右・下・左．
  **********************/
void init(String st, int sp){
  loadStage(st);
  speed = sp;
  myLife = 3;
  score = 0;
}

void loadStage(String filename){
  String[] lines = loadStrings(filename);
  for(int i=0; i<lines.length;i++){
    for(int j=0; j<lines[i].length();j++){
      stage[i][j] = int(lines[i].charAt(j));
      if(stage[i][j] == 2)itemCnt ++;
      if(stage[i][j] >= 4 && stage[i][j] <= 7){
        myX = j;
        myY = i;
        myDirect = stage[i][j] - 4;
      }
    }
  }
}

void turn(){
  switch(key){
    case UP:
    myDirect = 0;
    break;
    case RIGHT:
    myDirect = 1;
    break;
    case DOWN:
    myDirect = 2;
    break;
    case LEFT:
    myDirect = 3;
  }
}

void fileimage(int x,int y,String filename){
  PImage img = loadImage(filename);
  image(img,x,y);
}

void showStage(){
  noStroke();
  
}
void showBlock(int x, int y){
  
}

void getItem(){
  stage[myY][myX] = 1;
  itemCnt --;
}

void setup(){
  size(720,480);
  frameRate(30);
}
void draw(){
  rect(0,0,40,40);
}

void keyPressed(){
  turn();
}
