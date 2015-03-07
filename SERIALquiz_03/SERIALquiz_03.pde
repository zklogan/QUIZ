
import processing.serial.*;


//SERIAL
int bgcolor;           // Background color
int fgcolor;           // Fill color
Serial myPort;                       // The serial port
int[] serialInArray = new int[3];    // Where we'll put what we receive
int serialCount = 0;                 // A count of how many bytes we receive
int xpos, ypos;                 // Starting position of the ball
boolean firstContact = false;        // Whether we've heard from the microcontroller

//BUTTONS
int rectX, rectY;      // Position of square button
int circleX, circleY;  // Position of circle button
int rectSize = 90;     // Diameter of rect
int circleSize = 93;   // Diameter of circle
color rectColor, circleColor, baseColor;
color rectHighlight, circleHighlight;
color currentColor;
boolean rectOver = false;
boolean circleOver = false;

//TEXT
//QUESTIONS
int interval;
char letter;
String words = "Press t for True, f for false. To Advance Questions Press Enter";
String[] questions = new String[10];
String[] answers =new String[10];
int currentQuestion;


void setup() {
  size(700, 400, P3D);
  background(0);

  // Print a list of the serial ports, for debugging purposes:
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[8];
  myPort = new Serial(this, portName, 9600);

  textFont(createFont("Ariel", 36));
  rectColor = color(0);
  rectHighlight = color(51);
  circleColor = color(255);
  circleHighlight = color(204);
  baseColor = color(102);
  currentColor = baseColor;
  circleX = width/2+circleSize/2+10;
  circleY = height/2;
  rectX = width/2-rectSize-10;
  rectY = height/2-rectSize/2;
  ellipseMode(CENTER);

  //QUESTIONS

  currentQuestion=0;
  String[] lines = loadStrings("list.txt");
  for (int i=0; i<lines.length; i++) {
    String[] temp = split(lines[i], ",");
    questions[i] = temp[0];
    answers[i] = temp[1];
    println("Question :"+temp[0]);
    println("Answer :"+temp[1]);
  }
}

void draw() {

  //TEXT BOX
  fill(0);
  noStroke();
  rect(0, 0, width, 150);

  //TEXT
  fill(255);
  textSize(20);
  text(words, 50, 70, 540, 300);
}


void keyPressed() {
  //SERIAL

  //  if (answers.equals(currentQuestion) == "TRUE") {
  //  if(answers[currentQuestion] == "TRUE" || (key =='t')){

  //    if(key=='t'|| key=='T'){
  //      myPort.write('Y');
  //    }

  if (answers[currentQuestion] == "TRUE" ) {
    if (key=='t'||key=='T') {
      myPort.write('Y');
    }
  }

  if (answers[currentQuestion] == "FALSE") {
    if (key=='f'||key=='F') {
      myPort.write('Y'); 
      //display answer token
    }
  }

  if (key == ENTER) {
    changeQuestion();
    myPort.write('X');
  }
}


//SERIAL COMM
void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller. 
  // Otherwise, add the incoming byte to the array:
  if (firstContact == false) {
    if (inByte == 'A') { 
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('A');       // ask for more
      println("CONTACT ESTABLISHED");
    }
  } 
  else {
    // Add the latest byte from the serial port to array:
    println(" ");
    println("******");
    println(inByte);
    println("******");
    println(" ");
    //    serialInArray[serialCount] = inByte;
    //    serialCount++;
    //
    //    // If we have 3 bytes:
    //    if (serialCount > 2 ) {
    //      xpos = serialInArray[0];
    //      ypos = serialInArray[1];
    //      fgcolor = serialInArray[2];
    //
    //      // print the values (for debugging purposes only):
    //      println(xpos + "\t" + ypos + "\t" + fgcolor);
    //
    //      // Send a capital A to request new sensor readings:
    //      myPort.print('A');
    //      // Reset serialCount:
    //      serialCount = 0;
    //    }
  }
}

void changeQuestion() {
  words = questions[currentQuestion];
  println("Answer is  " + answers[currentQuestion]);


  currentQuestion = currentQuestion+1;

  if (currentQuestion>questions.length-1) {
    //    currentQuestion = questions.length-1;
    exit();
  }
}









/*
void update(int x, int y) {
 if ( overCircle(circleX, circleY, circleSize) ) {
 circleOver = true;
 rectOver = false;
 } 
 else if ( overRect(rectX, rectY, rectSize, rectSize) ) {
 rectOver = true;
 circleOver = false;
 } 
 else {
 circleOver = rectOver = false;
 }
 }
 
 void mousePressed() {
 if (circleOver) {
 currentColor = circleColor;
 //myPort.write('T');
 }
 if (rectOver) {
 currentColor = rectColor;
 //myPort.write('F');
 }
 }
 
 boolean overRect(int x, int y, int width, int height) {
 if (mouseX >= x && mouseX <= x+width && 
 mouseY >= y && mouseY <= y+height) {
 return true;
 } 
 else {
 return false;
 }
 }
 
 boolean overCircle(int x, int y, int diameter) {
 float disX = x - mouseX;
 float disY = y - mouseY;
 if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
 return true;
 } 
 else {
 return false;
 }
 }
 */
