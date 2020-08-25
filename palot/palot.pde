class Palot {
  int size = 70;

  int count = 10; //birds counts
  int timeLimit = 30;
  int randNumber1 = int(random(1, 5)); 
  int randNumber2 = int(random(-3, -1));
  int vanishCount = 0;

  int houseSize = 270;
  int answerSize = 50;
  int countDown;
  int nextAnswer;
  int ms;
  int finishPalotCount;
  int scene;
  int set = 0;
  int correctAnswer;
  int incorrectAnswer1;
  int incorrectAnswer2;
  int palotCount;

  int answerLeftButtonX, answerLeftButtonY, 
    answerMiddleButtonX, answerMiddleButtonY, 
    answeRightButtonX, answerRightButtonY;
  int answerChoice;

  float border = count * 0.5;

  char keyAnswer;
  char temp;

  String answerNumeric;
  String answerLeft;
  String answerMiddle;
  String answerRight;

  boolean answerPress = false;

  PImage houseImage;
  PImage palot;
  PImage yourAnswerImage;
  PImage selectOneImage;
  PImage selectTwoImage;
  PImage selectThreeImage;
  PImage answerLeftButtonImage;
  PImage answerMiddleButtonImage;
  PImage answerRightButtonImage;

  int[] rectX = new int[count];
  int[] rectY = new int[count];
  int[] dx = new int[count];
  int[] dy = new int[count];

  boolean yourAnswer;

  PImage[] palot1 = new PImage[count];
  PImage[] palot2 = new PImage[count];
  PImage[] palot3 = new PImage[count];
  boolean[] rectJudge = new boolean[count];

  void timeKeeper() {
    ms = millis() / 1000;
    fill(255);  
    countDown = timeLimit - ms;
    if (countDown > 0) {
      text("COUNT DOWN:" + countDown, width / 2, 50);
    } else if (countDown == 0) {
      text("FINISH!:", width / 2, 50);
      nextAnswer = 0;
      scene = 2;
    }
  }

  void init() {
    houseImage = loadImage("images/bg_house.jpg");
    yourAnswerImage = loadImage("images/your.png");
    selectOneImage = loadImage("images/p1.png");
    selectTwoImage = loadImage("images/p2.png");
    selectThreeImage = loadImage("images/p3.png");
    answerLeftButtonImage = loadImage("images/p1.png");
    answerMiddleButtonImage = loadImage("images/p2.png");
    answerRightButtonImage = loadImage("images/p3.png");
    answerLeftButtonY = height - 50;
    answerMiddleButtonY = height - 50;
    answerRightButtonY = height - 50;
    for (int i = 0; i < count; i++) {
      if (i > count / 2) {
        rectX[i] = (int)random(size * 3 / 4, width - size * 4);
        rectY[i] = (int)random(size * 2, height - size * 2);
      } else {
        rectX[i] = (int)random(size * 4, width / 4);
        rectY[i] = (int)random(size * 2, height - size * 2);
      }    
      dx[i] = (int)random(1, 3);
      dy[i] = (int)random(1, 3);
      rectJudge[i] = true;
      palot1[i] = loadImage("images/palot.png");
    }
  }

  void printvector() {
    for (int i = 0; i < count; i++) {    
      println("dx[" + i + "] = " + dx[i]);
      println("dy[" + i + "] = " + dy[i]);
    }
    println();
  }

  //void palotCount(){
  //  println("palotCount: " + liveOnPalotCount());
  //}

  void drawRect() {
    fill(255, 0, 0);
    for (int i = 0; i < count; i++) {
      if (rectJudge[i]) {
        image(palot1[i], rectX[i], rectY[i]);
        //rect(rectX[i], rectY[i], size, size);
      }
    }
  }

  void drawHouse() {  
    image(houseImage, width / 2, height / 2);
    //rect(width /2, height / 2, houseSize, houseSize);
  }

  void move() {
    for (int i = 0; i < count; i++) {
      if (rectX[i] < size / 2 || rectX[i] > width - size / 2) {
        dx[i] *= -1;
      }  
      if (rectY[i] < size / 2 || rectY[i] > height - size / 2) {
        dy[i] *= -1;
      }      
      rectX[i] += dx[i];
      rectY[i] += dy[i];
    }
    if (scene == 2) {
      for (int i = 0; i < count; i++) {
        dx[i] = 0;
        dy[i] = 0;
      }
    }
  }

  void judgeRect() {
    for (int i = 0; i < count; i++) {
      if (width / 2 - houseSize / 2 < rectX[i] - size / 2

        && rectX[i] + size / 2 < width / 2 + houseSize / 2 

        && height / 2 - houseSize / 2 < rectY[i] - size / 2

        && rectY[i] + size / 2 < height / 2 + houseSize / 2 ) {
        //rectJudge[i] = false;
        dx[i] = 0;
        dy[i] = 0;
      }
    }
  }

  int liveOnPalotCount() {
    int cnt = 0;
    for (int i = 0; i < count; i++) {
      if (dx[i] == 0 && dy[i] == 0) {
        cnt++;
      }
    }
    return cnt;
  }

  void palotBack() {
    palotCount = liveOnPalotCount();
    int set = (int)random(0, count);
    int randDirect = (int)random(0, 4);    
    println("palotCount: " + palotCount);
    if (dx[set] == 0 && dy[set] == 0 && palotCount > border) {
      switch(randDirect) {
      case 0: // up
        rectX[set] = width / 2;
        rectY[set] = 50;
        break;
      case 1: // left
        rectX[set] = width / 3;
        ;
        rectY[set] = height / 2;
        break;
      case 2: // right         
        rectX[set] = int(width * 2 / 3.0);
        rectY[set] = height / 2;
        break;
      case 3: // bottom
        rectX[set] = width / 2;
        rectY[set] = height - 100;
        break;
      }
      dx[set] = (int)random(1, 3);
      dy[set] = (int)random(1, 3);
    }
  }

  void keyPressed() {
    keyAnswer = key;
    if (key == '1' || key == '2' || key == 3) {
      temp = keyAnswer;
    }
  }

  void answerSet() {
  }

  int i = 0;

  void answerScreen() {       
    int correctAnswer;
    int incorrectAnswer1;
    int incorrectAnswer2;  
    int randNumeric = 0;
    fill(255);
    background(0);
    text("How many birds are at home?", width / 2, height / 2 - 100);
    image(yourAnswerImage, width / 5, answerLeftButtonY);
    image(answerLeftButtonImage, width * 2 / 5, answerLeftButtonY);
    image(answerMiddleButtonImage, width * 3 / 5, answerLeftButtonY);
    image(answerRightButtonImage, width *  4 / 5, answerLeftButtonY);
    //text(keyAnswer, width * 2 / 3, height - 37);    
    correctAnswer = palotCount;
    incorrectAnswer1 = palotCount + randNumber1;
    incorrectAnswer2 = palotCount + randNumber2;

    if (set == 0) {
      randNumeric = int(random(1, 4));
      set++;
    }

    if (randNumeric == 1) {
      answerLeft = str(correctAnswer);
      answerMiddle = str(incorrectAnswer1);
      answerRight = str(incorrectAnswer2);
      answerNumeric = str(correctAnswer);
    } else if (randNumeric == 2) {
      answerLeft = str(incorrectAnswer2);
      answerMiddle = str(correctAnswer);
      answerRight = str(incorrectAnswer1);
      answerNumeric = str(correctAnswer);
    } else {
      answerLeft = str(incorrectAnswer1);
      answerMiddle = str(incorrectAnswer2);
      answerRight = str(correctAnswer);
      answerNumeric = str(correctAnswer);
    }
    text(answerLeft, width / 4, height / 2);
    text(answerMiddle, width / 2, height / 2);
    text(answerRight, width * 3 / 4, height / 2);
    image(selectOneImage, width/4-100, height/2-12);
    image(selectTwoImage, width/2-100, height/2-12);
    image(selectThreeImage, width*3/4-100, height/2-12);
    //println("answerLeft: "  + answerLeft);
    //println("answerMiddle: "  + answerMiddle);
    //println("answerRight: "  + answerRight);
    println();
    //if(mouseButton == "1" || mouseButton == "2" || mouseButton == "3"){

    //temp = keyAnswer;    
    //println("keyAnswer: " + keyAnswer);
    println("palotCount: " + palotCount);
    //println("keyAnswer: " + keyAnswer);
    println("answerChoice: " + answerChoice);
    println("answerPress: " + answerPress);
    if (answerPress) {
      println("temp: " + temp);
      println();
      scene = 3;
    }
  }

  boolean answerJudge() {
    //println("temp in judge: " + temp);
    boolean result = false;
    if (answerPress) {
      if (answerChoice == 1) {
        if (answerLeft == answerNumeric) {
          result = true;
        } else {
          result = false;
        }
      } else if (answerChoice == 2) {
        if (answerMiddle == answerNumeric) {
          result = true;
        } else {
          result = false;
        }
      } else if (answerChoice == 3) {
        if (answerRight == answerNumeric) {
          result = true;
        } else {
          result = false;
        }
      }
    }
    return result;
  }

  void resultScreen() {
    background(0);
    yourAnswer = answerJudge();
    if (yourAnswer) {
      text("That's correct!", width / 2, height / 2);
    } else {
      text("wrong!", width / 2, height / 2);
    }
  }

  void mousePressed() {
    if (answerLeftButtonY - answerSize / 2<= mouseY && mouseY <= answerLeftButtonY + answerSize) {
      if (width * 2 / 5.0 - answerSize / 2 <= mouseX && mouseX <= width * 2 / 5.0 + answerSize / 2) {
        answerChoice = 1;
      } else if (width * 3 / 5.0 - answerSize / 2 <= mouseX && mouseX <= width * 3 / 5.0 + answerSize / 2) {
        answerChoice = 2;
      } else if (width * 4 / 5.0 - answerSize / 2 <= mouseX && mouseX <= width * 4 / 5.0 + answerSize) {
        answerChoice = 3;
      }
      scene = 3;
      answerPress = true;
    }
  }

  void mouseReleased() {
    if (answerLeftButtonY - answerSize / 2 <= mouseY && mouseY <= answerLeftButtonY + answerSize) {
      if (width * 2 / 5 - answerSize / 2 <= mouseX && mouseX <= width * 2 / 5 + answerSize / 2) {
        answerChoice = 1;
      } else if (width * 3 / 5 - answerSize / 2 <= mouseX && mouseX <= width * 3 / 5 + answerSize / 2) {
        answerChoice = 2;
      } else if (width * 4 / 5 - answerSize / 2 <= mouseX && mouseX <= width * 4 / 5 + answerSize) {
        answerChoice = 3;
      }
      scene = 3;
      answerPress = true;
    }
  }
}

Palot p;

void setup() {  
  p = new Palot();
  frameRate(60);
  size(1280, 720);
  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER);
  p.init();
  textSize(50);
  p.scene = 1;
  p.keyAnswer = 63;
}

void draw() {  
  if (p.scene == 1) {
    p.printvector();
    background(0);
    p.timeKeeper();   
    println("countDown:" + p.countDown);
    p.drawRect();
    p.drawHouse();
    p.judgeRect();
    p.palotBack();  
    p.move();
  } else if (p.scene == 2) {
    p.answerScreen();
  } else if (p.scene == 3) {
    p.resultScreen();
  }
  //println("answerLeft: "  + answerLeft);
  //println("answerMiddle: "  + answerMiddle);
  //println("answerRight: "  + answerRight);
}
