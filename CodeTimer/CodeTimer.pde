Timer dinoTimer;
float remainingPercentage =0;
float elapsedPercentage =0;
void setup() {
  size (1000, 600);  
  frameRate(144);
  ellipse( 200, 400,50 ,50 );
  
  ellipseMode(CENTER);
  
  dinoTimer = new Timer(700);
}

void draw () {
  drawGraphics();
  ellipse( 100, 400, 50, 50);
}

void drawGraphics() {
 
  
  // draw title
  background(0);
  noStroke();
  fill(255);
  textSize(32);
  text("SimpleCommunication Example", 10, 40 ); 
  
  // check to see if timer is expired, then restart timer
    
    remainingPercentage =  dinoTimer.getPercentageRemaining();
    elapsedPercentage = dinoTimer.getPercentageElapsed();
    if (remainingPercentage > 0.5){
        ellipse( 100, 400* remainingPercentage, 50, 50);
      }
      else if (remainingPercentage < 0.5){
        ellipse( 100, 400* elapsedPercentage, 50, 50);
      }
}

void keyPressed(){
  dinoTimer.start();
}
