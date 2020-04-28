/*
  Dino game Test
  by Jeffrey Chen
  */
  

// Importing the serial library to communicate with the Arduino 
import processing.serial.*; 

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;

// Data coming in from the data fields
// data[0] = "1" or "0"                  -- BUTTON
// data[1] = 0-4095, e.g "2049"          -- POT VALUE
// data[2] = 0-4095, e.g. "1023"        -- LDR value
String [] data;

int switchValue = 0;
int potValue = 0;
int ldrValue = 0;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 2;

// mapping pot values
float minPotValue = 0;
float maxPotValue = 4095;

//Timers used for the program
Timer dinoTimer;
Timer cactusTimer;

//Variables used to control the jump going up and coming back down
float remainingPercentage;
float elapsedPercentage;
void setup() {
  
  // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  //-- use your port name
  myPort  =  new Serial (this, "COM3",  115200); 
  
//Screen resolution and framerates set at 144 because my monitor can handle it.
  size (1000, 600);  
  frameRate(144);
  
  ellipseMode(CENTER);
  
//Dino refers to the ball while cactus refers to the block
  dinoTimer = new Timer(700);
  cactusTimer= new Timer(1000);
}
void draw () {
  if( cactusTimer.expired() ) {  
    // every loop, look for serial information
    checkSerial();
    cactusTimer.start();
  }
  background(0);
  noStroke();
  fill(255);
  textSize(32);
  text("Dino Jump Test", 10, 40 ); 
  
  drawJump();
  drawCactus();
}

void drawCactus(){ 
  float x=width * cactusTimer.getPercentageRemaining();
  fill( 240,100,100);
  rect(x,280, 20, 200);
}
  

void drawJump() {
  /*
  Uses the remaining percentage to increase the height of the ball
  while using elapsed percentage to decrease the height of the ball.
  The midpoint is set at 0.5 of the time elapsed.
  */
    remainingPercentage =  dinoTimer.getPercentageRemaining();
    elapsedPercentage = dinoTimer.getPercentageElapsed();
    if (remainingPercentage > 0.5){
        ellipse( 100, 400* remainingPercentage, 50, 50);
      }
      else if (remainingPercentage < 0.5){
        ellipse( 100, 400* elapsedPercentage, 50, 50);
      }
}

//Pressing any key will make the dino (ball) jump
void keyPressed(){
  if (dinoTimer.expired()){
    dinoTimer.start();
  }
}

// We call this to get the data 
void checkSerial() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();  
    
    //print(inBuffer);
    
    // This removes the end-of-line from the string 
    inBuffer = (trim(inBuffer));
    
    // This function will make an array of TWO items, 1st item = switch value, 2nd item = potValue
    data = split(inBuffer, ',');
   
   // we have THREE items — ERROR-CHECK HERE
   if( data.length >= 2 ) {
      switchValue = int(data[0]);           // first index = switch value 
      potValue = int(data[1]);               // second index = pot value
      ldrValue = int(data[2]);               // third index = LDR value
      
      // change the display timer
      float potInsert = map( potValue, minPotValue, maxPotValue, 500, 2000 );
      cactusTimer.setTimer( int(potInsert));
   }
  }
}
