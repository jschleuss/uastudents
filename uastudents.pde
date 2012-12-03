// Jon Schluess
/*

Rules
1. Ball count limit is set by population total, divided by 25 for performance.
2. Balls fall from the top of the window, randomly within x values and with random sizes.
3. Balls bounce off a panel's borders and go in a negative direction (friction).
4. Balls bounce off each other.

*/

PFont header;
PFont body;

// Global variables
// Sets spring, gravity, friction, margin and an array of year amounts
float spring = 0.05;
float gravity = 0.53;
float friction = -0.9;
int margin = 10;
int [] years = {25, 77, 148, 244, 611, 1251, 1535, 1804, 3596, 6867, 11804, 15108, 14734, 16035, 24537};
// declares 15 new objects -- all columns of balls
PanelOfBalls panel0, panel1, panel2, panel3, panel4, panel5, panel6, panel7, panel8, panel9, panel10, panel11, panel12, panel13, panel14;

// Setup size, no stroke, fonts adnd objects
void setup() {
  size(900, 360);
  noStroke();
  // sets fonts
  header = loadFont("Helvetica-24.vlw");
  body = loadFont("Helvetica-14.vlw");
  // Panels of balls with year amount divided by 25 and then the panel position number
  panel0 = new PanelOfBalls( years[0]/25, 0 );
  panel1 = new PanelOfBalls( years[1]/25, 1 );
  panel2 = new PanelOfBalls( years[2]/25, 2 );
  panel3 = new PanelOfBalls( years[3]/25, 3 );
  panel4 = new PanelOfBalls( years[4]/25, 4 );
  panel5 = new PanelOfBalls( years[5]/25, 5 );
  panel6 = new PanelOfBalls( years[6]/25, 6 );
  panel7 = new PanelOfBalls( years[7]/25, 7 );
  panel8 = new PanelOfBalls( years[8]/25, 8 );
  panel9 = new PanelOfBalls( years[9]/25, 9 );
  panel10 = new PanelOfBalls( years[10]/25, 10 );
  panel11 = new PanelOfBalls( years[11]/25, 11 );
  panel12 = new PanelOfBalls( years[12]/25, 12 );
  panel13 = new PanelOfBalls( years[13]/25, 13 );
  panel14 = new PanelOfBalls( years[14]/25, 14 );
}

void draw() {
  background(0);
  // assign newly created panels to new objects
  panel0.update();  
  panel1.update();  
  panel2.update();  
  panel3.update();  
  panel4.update();  
  panel5.update();  
  panel6.update();  
  panel7.update();  
  panel8.update();  
  panel9.update();  
  panel10.update();  
  panel11.update();  
  panel12.update();  
  panel13.update();  
  panel14.update();
  // fill white
  fill(255);
  // headline text
  textFont(header, 24);  
  text("University of Arkansas Fall Enrollment", margin, margin + 24);
  // body text
  textFont(body, 12);
  text("*One ball represents 25 students", margin, 2 * margin + 34);
  // Start year labels, for loop to shorten code
  text("1872", margin, height - 20);
  for (int i = 0; i < years.length + 1; i++) {
    text(1872 + i * 10, width / years.length * i + margin, height - 20);
  }
}

// Class of ball
class Ball {
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  Ball[] others;

  // constructor
  Ball(float xin, float yin, float din, int idin, Ball[] oin) {
    // pull in a ball's initial start x and y, diameter, ball ID and others
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
  } 
  
  // the rules of collision
  void collide() {
    for (int i = id + 1; i < others.length; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter + diameter;
      // prevent overlapping 
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }
  }
  
  // Move function, positioning the balls and telling them where to go
  // pull in the panel number
  void move( int whichPanel ) {
   // define the x and y of the panel's left and right size (giving it width)
   int panelLeft = width / years.length * whichPanel + margin;
   int panelRight = width / years.length + ( width / years.length * whichPanel);
   //give the balls some gravity to the x and y effect
    vy += gravity;
    x += vx;
    y += vy;
    
    // keep a ball inside the right side of its panel
    if (x + diameter/2 > panelRight) {
      // apply friction to the ball and put it inside the right panel
      x = panelRight - diameter/2;
      vx *= friction;
    }
    // keep a ball to the right of the left panel
    else if (x - diameter/2 < panelLeft) {
      // if so, position it inside the panel and apply friction
      x = panelLeft + diameter/2;
      vx *= friction;
    }
    
    // define a base for the graph/illustration
    int base = height - 40;
    // if the ball's position is greater than the base
    if (y + diameter/2 > base) {
      // put it above the base and apply friction
      y = base - diameter/2;
      vy *= friction;
    } 
    // if the ball's position is above the top of the window
    else if (y - diameter/2 < 0) {
      // put it at its radius and apply friction
      y = diameter/2;
      vy *= friction;
    }
  }
  
  // display the balls
  void display() {
    // Razorback red
    fill(190,15,52);
    ellipse(x, y, diameter, diameter);
  }
}

// Define each panel of balls
class PanelOfBalls {
  // pull an array of balls and create a whichPanel variable
  Ball [] balls;
  int whichPanel;
  
  // Contstructor
  PanelOfBalls( int numBalls, int wp ) {
   // pull in the whichPanel
   whichPanel = wp;
   // define the left and rights of the panels
   int panelLeft = width / years.length * whichPanel;
   int panelRight = width / years.length + ( width / years.length * whichPanel);
   // create number of balls
   balls = new Ball[numBalls]; 
   // create the ball characteristics, randomizing size
   for (int i = 0; i < numBalls; i++) {
     balls[i] = new Ball(random(panelLeft, panelRight), 0, random(2, 4), i, balls);
   }

  }
  
  // this function calls all the important ones that define the objects rules
  void update() {
    for (int i = 0; i < balls.length; i++) {
      balls[i].collide();
      balls[i].move( whichPanel );
      balls[i].display();  
    }
  } 
}
