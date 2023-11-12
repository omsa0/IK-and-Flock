//make a claw looking thing
//also for flock, if I need to do it, rotation shouldnt be an issue if the agents bounding geometry is a circle
// can do 3d sim+rendering on flock otherwise only 3d rendering on the ik
//add user interaction
//claw machine arm might be a way to get moving root points


void setup() {
  size(1200, 750, P3D);
  surface.setTitle("Project 3 - Inverse Kinematics");
}

//Root
Vec2 root = new Vec2(1200/2, 750);

//lower spine
float l0 = 200;
float a0 = -PI/2; //lower spine joint

//upper spine
float l1 = 125;
float a1 = 0; //middle spine joint

//Left & Right Arm
float ll0 = 80, rl0 = 80;
float la0 = -0.3; //shoulder joints (shared joint, separate angles)
float ra0 = -la0;

//Left & Right Hand
float ll1 = 80, rl1 = 80;
float la1 = -0.3; //wrist joints
float ra1 = -la1;

float armW = 20; //Arm width

//goal
Vec2 goal = new Vec2(100, 100); //goal position
float gr = 10; //goal radius
boolean goalReached = false;

Vec2 start_l1, start_l2, start_left1, endPoint_left, start_right1, endPoint_right;

boolean goalMoving = true;
boolean paused = true;
void keyPressed() {
  if (key == 'z') {
    restricted = !restricted;
  }
  if (key == ' ') {
    paused = !paused;
  }
  if (key == 'r') {
    goalMoving = !goalMoving;
  }
}

boolean goalGrabbed = false;
void mouseClicked() {
  goalGrabbed = !goalGrabbed;
}

void draw() {

  if (goalGrabbed) {
    goal.x = mouseX;
    goal.y = mouseY;
  }

  if (!paused) {
    fk();
    if (!goalReached) solve();

    //move it to red spot
    if (goalMoving) {
      if (leftReaching && goal.distanceTo(endPoint_left) < 10) {
        goalReached = true;
        goal = new Vec2(endPoint_left.x, endPoint_left.y);
        solveGoal(new Vec2(300, 500));
        goal = new Vec2(endPoint_left.x, endPoint_left.y);
      } else if (goal.distanceTo(endPoint_right) < 10) {
        goalReached = true;
        goal = new Vec2(endPoint_right.x, endPoint_right.y);
        solveGoal(new Vec2(300, 500));
        goal = new Vec2(endPoint_right.x, endPoint_right.y);
      } else {
        goalReached = false;
      }
    }
    if (goal.distanceTo(new Vec2(300, 500)) < 1) {
      goalReached = false;
      goal = new Vec2(random(300, 900), random(300, 600));
    }
  } else {
    fk();
  }

  background(250, 250, 250);

  //IKs
  fill(224, 172, 105);
  pushMatrix();
  translate(root.x, root.y);
  rotate(a0);
  rect(0, -armW/2, l0, armW);
  popMatrix();

  pushMatrix();
  translate(start_l1.x, start_l1.y);
  rotate(a0+a1);
  rect(0, -armW/2, l1, armW);
  popMatrix();

  //left
  fill(224, 172, 255);
  pushMatrix();
  translate(start_l2.x, start_l2.y);
  rotate(a0+a1+la0);
  rect(0, -armW/2, ll0, armW);
  popMatrix();

  pushMatrix();
  translate(start_left1.x, start_left1.y);
  rotate(a0+a1+la0+la1);
  rect(0, -armW/2, ll1, armW);
  popMatrix();

  //right
  fill(255, 172, 150);
  pushMatrix();
  translate(start_l2.x, start_l2.y);
  rotate(a0+a1+ra0);
  rect(0, -armW/2, rl0, armW);
  popMatrix();

  pushMatrix();
  translate(start_right1.x, start_right1.y);
  rotate(a0+a1+ra0+ra1);
  rect(0, -armW/2, rl1, armW);
  popMatrix();

  //head
  fill(224, 172, 105);
  pushMatrix();
  translate(start_l2.x, start_l2.y - 30);
  circle(0, 0, 2*30);
  fill(0);
  circle(9, -9, 2*3);
  circle(-9, -9, 2*3);
  popMatrix();

  // place to move the goal to
  fill(255, 0, 0);
  circle(300, 500, 2*10);

  // goal
  fill(0, 0, 255);
  circle(goal.x, goal.y, 2*gr);
}
