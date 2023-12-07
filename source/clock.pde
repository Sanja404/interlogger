//Моя программа v2.00

import processing.serial.*;
import meter.*;
import processing.sound.*;
import controlP5.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;



Meter am, an;



int ss;
int mm;
int hh;
int v;
int vv;
int pozX;
int pozY;
float internalPressure;
float internalTemperature;
String myString = null;
Serial myPort;
//String data;

int newSensorReading;
int newSensorReading1;

int i = 0;

boolean reset = false;
boolean analog = true; // аналоговые часы
int fon = 0;

int Y_AXIS = 1;
int X_AXIS = 2;
color b1, b2, c1, c2;

PImage img1; // для вставки изображения
PImage img2;
PImage img3;

SoundFile sample;
int atime=1;

int cx, cy;          // Аналоговые часы
float secondsRadius;
float minutesRadius;
float hoursRadius;
float clockDiameter;

ControlP5 cp5; // кнопки
boolean trigger = true;

PrintWriter  fileoutput;
String [] tq;
String  tqTime;
//String setDateFormat;


void setup() {
  size (1050, 300);
  pozX=90;
  pozY=105;
  internalPressure=705.0;
  internalTemperature=3.0;
  //холст
  b1 = color(255);
  b2 = color(150);
  c1 = color(204, 102, 0);
  c2 = color(0, 102, 153);

  // данные с ардуино
  myPort = new Serial(this, "COM3", 9600);
  myPort.clear();
  myString = myPort.readStringUntil('\n');
  myString = null;
  // рисуем шкалы

  am = new Meter(this, 355, 45);
  //int mx = am.getMeterX();
  //int my = am.getMeterY();
  //int mw = am.getMeterWidth();
  am.setMeterWidth(300);
  am.setMinInputSignal(700);
  am.setMaxInputSignal(800);
  //am.setArcMinDegrees(0.0); // (start)
  //am.setArcMaxDegrees(360.0); // ( end)
  am.setMinScaleValue(700.0);
  am.setMaxScaleValue(800.0);
  am.setTitle("Pressure");
  am.setShortTicsBetweenLongTics(0);
  // am.setUp(0, 360, 0.0f, 360.0f, 0.0f, 360.0f);
  am.setDisplayWarningMessagesToOutput(false);
  am.setDisplayLastScaleLabel(true);
  String[] scaleLabels = {"700", "725", "750", "775", "800"};
  am.setScaleLabels(scaleLabels);
  //am.setTicMarkOffsetFromPivotPoint(20);
  //am.setLongTicMarkLength(120);
  //am.setShortTicsBetweenLongTics(60);
  //am.setNeedleLength(180);
  am.setDisplayDigitalMeterValue(true);
  //am.setDisplayMinimumValue(true);
  //am.setDisplayMaximumValue(true);
  //am.setDisplayMinimumNeedle(true);
  am.setDisplayMaximumNeedle(true);


  an = new Meter(this, 700, 45);
  an.setMeterWidth(300);
  an.setMinInputSignal(0);
  an.setMaxInputSignal(400);
  //an.setArcMinDegrees(0.0); // (start)
  //an.setArcMaxDegrees(360.0); // ( end)
  an.setMinScaleValue(0.0);
  an.setMaxScaleValue(40.0);
  an.setTitle("Temperature");
  an.setShortTicsBetweenLongTics(0);
  // an.setUp(0, 360, 0.0f, 360.0f, 0.0f, 360.0f);
  an.setDisplayWarningMessagesToOutput(false);
  an.setDisplayLastScaleLabel(true);
  String[] scaleLabelsAA = {"0", "5", "10", "15", "20", "25", "30", "35", "40"};
  an.setScaleLabels(scaleLabelsAA);
  //am.setTicMarkOffsetFromPivotPoint(20);
  //am.setLongTicMarkLength(120);
  //am.setShortTicsBetweenLongTics(60);
  //am.setNeedleLength(180);
  an.setDisplayMinimumValue(true);
  //an.setDisplayMaximumValue(true);
  an.setDisplayDigitalMeterValue(true);
  //an.setDisplayMinimumNeedle(true);
  an.setDisplayMaximumNeedle(true);


  img1 = loadImage("imagemon.jpg"); //изображение
  img2 = loadImage("imageran.jpg");
  img3 = loadImage("image03.jpg");

  sample = new SoundFile(this, "1.aif"); //звук

  int radius = min(width, height) / 2; //Аналоговые часы
  secondsRadius = radius * 0.72;
  minutesRadius = radius * 0.60;
  hoursRadius = radius * 0.50;
  clockDiameter = radius * 1.8;

  cx = width / 6;
  cy = height / 2;

  cp5 = new ControlP5(this); //кнопки
  cp5.addButton("BTN")
    .setPosition(1, 1)
    .setSize(30, 18);
  //.setPosition(380,223)

  cp5.addButton("BTN2")
    .setPosition(33, 1)
    .setSize(30, 18);

  cp5.addButton("SAVE")
    .setPosition(65, 1)
    .setSize(30, 18);

 /* cp5.addSlider("Pr")
    .setRange(700, 800)
    .setValue(704)
    .setPosition(1010, 50)
    .setSize(10, 100)
    //.setNumberOfTickMarks(7)
    .setSliderMode(Slider.FLEXIBLE)
    ;
    */
    //setDateFormat("%Y-%m-%d %H:%M:%S");
    
    
    //setDateFormat =  
    LocalDateTime now = LocalDateTime.now();
    
    String isoDateTime = now.format(DateTimeFormatter.ISO_DATE_TIME);   //для лога
    String [] tq = isoDateTime.split("T");
    String  tqTimeq =  tq[1].substring(0, 8);
    String  tqTimeq1 = tq[1].substring(0, 2);
    String  tqTimeq2 = tq[1].substring(3, 5);
    String  tqTimeq3 = tq[1].substring(6, 8);
    String  tqTimeq4 = tq[0].substring(5, 7);
    String  tqTimeq5 = tq[0].substring(8, 10);
    String  tqTime = tqTimeq4 + tqTimeq5 + tqTimeq1 + tqTimeq2 + tqTimeq3; 
    
    println("Текущяя дата: " + tq[0]);
    //println(tqTime);
    println("Текущее время: " +tqTimeq);
    //print(tqTimeq1); print(tqTimeq2); println(tqTimeq3);
    //fileoutput = createWriter( tq[0] + "_" + tqTime + "_positions.txt");
    fileoutput = createWriter("log"+tqTime+".txt");                         //open  file
    
  

}

void draw() {

  while (myPort.available() > 0) {
    myString = myPort.readStringUntil('\n');
    if (myString != null) {
      println(myString);

      String[] q = splitTokens(myString);
      internalPressure = parseFloat (q[0]);
      internalTemperature = parseFloat (q[1]);
    }
  }

  if (trigger == true) {
    fantasyCalor ();
  } else {
    if (fon >=4) {
      fon = 0;
      background(002, 003, 128);
    }
  }
  if (fon == 2) {
    background(102, 153, 255);  // светлый фон
    image(img3, 0, 0);
  } else if (fon == 0) {
    background(002, 003, 128);  //тёмный фон
  } else if (fon == 3) {
    image(img1, 0, 0);         //изоброжение луны
  } else if (fon == 1) {
    image(img2, 0, 0);         //изоброжение радуги
  }
  if (analog == true) {
    timeText();
  } else {
    timeAnalog ();
  }

  if  ((minute() == 0 ) && (second() == 0)) {
    if (atime == 1) {
      sample.play(1); // ЗВУК
      atime ++;
      SAVE ();       // и лог
     fileoutput.print (tqTime);
     fileoutput.print (" ") ;
     fileoutput.println( myString  );
     fileoutput.flush();
    }
  } else atime = 1;
  
  //cp5.get(Slider.class, "Pr").setValue(internalPressure);
  
  



  setGradient(370, 30, 615, 80, c1, c2, Y_AXIS);
  setGradient(370, 160, 615, 80, c2, c1, X_AXIS);





  if (keyPressed) {
    println("key");
    if (key=='r') {
      reset = true;
    } else if (key=='a') {
      analog = true;
    } else if (key=='c') {
      analog = false;
    }
  }


  if (reset == true) {
    println("Reset");
    am.setMaximumValue(-0.-1f);
    am.setMinimumValue(0.1f);
    an.setMaximumValue(-0.-1f);
    an.setMinimumValue(0.1f);
    reset = false;
  }
  /*if (i++ == 3) {
   am.setDisplayLastScaleLabel(true);
   an.setDisplayLastScaleLabel(true);
   }
   if (i >= 6) {
   am.setDisplayLastScaleLabel(false);
   an.setDisplayLastScaleLabel(false);
   i = 0;
   }*/
  //int newSensorReading;
  //int newSensorReading1;
    //newSensorReading = (int)random(0, 255);
  newSensorReading =  (int) internalPressure;
  newSensorReading1 = (int) internalTemperature*10;

  am.updateMeter(newSensorReading  );
  an.updateMeter(newSensorReading1 );
 
 
  delay(10);
}

void fantasyCalor () {

  if (hour() <=8 ) {
    fon = 0;                 // с 0 до 8
  }
  if ((hour() >=8 ) && (hour() <12)) {
    fon = 1;                 // с 8 до 12
  }
  if ((hour() >=12  ) && (hour() <19)) {
    fon = 2;                 // с 12 д 18
  }
  if (hour() >= 19 ) {
    fon = 3;                 // остальное время
  }
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();
  //отрисовка двух линий

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  } else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}

void timeText() {
  textSize(45);
  int s = second();  // Значения в диапазоне 0 - 59
  int m = minute();  // Значения в диапазоне 0 - 59
  int h = hour();    // Значения в диапазоне 0 - 23
  int d = day();    // Значения в диапазоне 1 - 31
  int mt = month();   // Значения в диапазоне 1 - 12
  int y = year();

  fill(0, 0, 2);
  strokeWeight(1);
  stroke(0);                // черная обводка
  fill(122, 93, 215, 140);
  ellipse(190, 152, 258, 230);
  fill(152, 123, 255, 140);
  ellipse(176, 143, 268, 240);

  fill(0, 10, 50);
  String v = String.valueOf(h % 10);
  String vv = String.valueOf(h / 10);
  text(vv, pozX, pozY);
  text(v, pozX+20, pozY);
  text(":", pozX+40, pozY);
  v = String.valueOf(m % 10);
  vv = String.valueOf(m / 10);
  text(vv, pozX+50, pozY);
  text(v, pozX+70, pozY);
  text(":", pozX+90, pozY);
  v = String.valueOf(s % 10);
  vv = String.valueOf(s / 10);
  text(vv, pozX+100, pozY);
  text(v, pozX+120, pozY);

  v = String.valueOf(d % 10);
  vv = String.valueOf(d / 10);
  text(vv, pozX, pozY+40);
  text(v, pozX+20, pozY+40);
  text(".", pozX+40, pozY+40);
  v = String.valueOf(mt % 10);
  vv = String.valueOf(mt / 10);
  text(vv, pozX+50, pozY+40);
  text(v, pozX+70, pozY+40);
  text(".", pozX+90, pozY+40);
  v = String.valueOf(y);
  text(v, pozX+100, pozY+40);

  text(internalTemperature, pozX+15, pozY+80);
  text("C", pozX+155, pozY+80);
  text(internalPressure, pozX-5, pozY+120);
}


void timeAnalog () {
  // background(0);  // Аналоговые часы

  // Draw the clock background
  fill(80, 0, 80, 140);
  noStroke();
  ellipse(cx, cy, clockDiameter, clockDiameter);

  // Angles for sin() and cos() start at 3 o'clock;
  // subtract HALF_PI to make them start at the top
  float s = map(second(), 0, 60, 0, TWO_PI) - HALF_PI;
  float m = map(minute() + norm(second(), 0, 60), 0, 60, 0, TWO_PI) - HALF_PI;
  float h = map(hour() + norm(minute(), 0, 60), 0, 24, 0, TWO_PI * 2) - HALF_PI;

  // Draw the hands of the clock
  stroke(255);
  strokeWeight(1);
  line(cx, cy, cx + cos(s) * secondsRadius, cy + sin(s) * secondsRadius);
  strokeWeight(2);
  line(cx, cy, cx + cos(m) * minutesRadius, cy + sin(m) * minutesRadius);
  strokeWeight(4);
  line(cx, cy, cx + cos(h) * hoursRadius, cy + sin(h) * hoursRadius);

  // Draw the minute ticks
  strokeWeight(2);
  beginShape(POINTS);
  for (int a = 0; a < 360; a+=6) {
    float angle = radians(a);
    float x = cx + cos(angle) * secondsRadius;
    float y = cy + sin(angle) * secondsRadius;
    vertex(x, y);
  }
  endShape();
}

void BTN () {

  println("clic1");


  if (trigger == true) {
    analog = !analog;
  } else {
    fon++;
  }
}

void BTN2 () {

  println("clic2");

  trigger=!trigger;
}

void SAVE () {
  println("clic3");
   

  LocalDateTime now = LocalDateTime.now();
    String isoDateTime = now.format(DateTimeFormatter.ISO_DATE_TIME);
    String [] tq = isoDateTime.split("T");
    String  tqTime = tq[1].substring(0, 8);
   println (tqTime);
   fileoutput.print (tqTime);
   fileoutput.print (" ") ;
   fileoutput.println( myString  );
   fileoutput.flush();
   //filename.close();
  
}
   //cp5.saveProperties(("hello.json"));

//void keyPressed() {
  // default properties load/save key combinations are
  // alt+shift+l to load properties
  // alt+shift+s to save properties
  //if (key=='1') {
    //cp5.saveProperties(("hello.json"));
  //} 
  //else if (key=='2') {
  //  cp5.loadProperties(("hello.json"));
  //}
//}
