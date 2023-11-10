//void setup() {
//  size(1200, 750, P3D);
//  surface.setTitle("Porject 3 - Flock2D");
//  camera = new Camera();
//  camera.position = new PVector(600, 375, 900);
//  generateBoids();
//}

//Camera camera;
//float depth = 750;

////boids
//int numBoids = 200;
//Vec2 pos[] = new Vec2[numBoids];
//Vec2 vel[] = new Vec2[numBoids];
//Vec2 acc[] = new Vec2[numBoids];
//float bw = 25; //boid width
//float bh = 50; //boid width

////Params
//float sepForce_maxD = 40;
//float separationScale = 40000;

//float attraction_maxD = 100;
//float attractionForce_scale = 1000;

//float alignment_maxDist = 100;
//float align_scale = 500;

//void generateBoids() {
//  for (int i = 0; i < numBoids; i++) {
//    pos[i] = new Vec2(random(100, 1000), random(100, 600));
//    vel[i] = new Vec2(random(-200, 200), random(-200, 200));
//    acc[i] = new Vec2(0, 0);
//  }
//}

//void keyPressed()
//{
//  camera.HandleKeyPressed();

//  if (key == 'z') {
//    generateBoids();
//  }
//  if (key == ' ') {
//    paused = !paused;
//  }
//}

//void keyReleased()
//{
//  camera.HandleKeyReleased();
//}

//void update(float dt) {
  
//  //integration
//  for (int i = 0; i < numBoids; i++) {
//    vel[i] = vel[i].plus(acc[i].times(dt));
//    vel[i] = vel[i].plus(new Vec2(random(-20, 20), random(-20, 20))); // random noise
//    vel[i].clampToLength(500); //maxspeed
//    pos[i] = pos[i].plus(vel[i].times(dt));
//    acc[i] = new Vec2(0, 0);
    
//    //turning once it is getting close to boundaries
//    if (pos[i].x+200 > width) {
//      vel[i].x = vel[i].x - 20;
//    }
//    if (pos[i].x-200 < 0) {
//      vel[i].x = vel[i].x + 20;
//    }
//    if (pos[i].y-100 < 0) {
//      vel[i].y = vel[i].y + 30;
//    }
//    if (pos[i].y+100 > height) {
//      vel[i].y = vel[i].y - 30;
//    }
    
//  }


//  //forces
//  for (int i = 0; i < numBoids; i++) {
//    //Separation Force
//    for (int j = 0; j < numBoids; j++) {
//      float dist = pos[i].distanceTo(pos[j]);
//      if (dist < 0.01|| dist > sepForce_maxD) continue; //i==j??
//      Vec2 seperationForce = pos[i].minus(pos[j]);
//      seperationForce.setToLength(separationScale/pow(dist, 1));
//      acc[i] = acc[i].plus(seperationForce);
//    }
    
//    //Attraction Force
//    Vec2 avgPos = getNeighborPos(attraction_maxD, i);
//    Vec2 attractionForce = avgPos.minus(pos[i]);
//    if (attractionForce.lengthSqr() > 0.01) {
//      attractionForce.normalize();
//      attractionForce.mul(attractionForce_scale);
//      acc[i] = acc[i].plus(attractionForce);
//    }

//    //Alignment Force
//    Vec2 avgNeighborVel = getNeighborVel(alignment_maxDist, i);
//    Vec2 towards = avgNeighborVel.minus(vel[i]);
//    if (towards.lengthSqr() > 0.01) {
//      towards.normalize();
//      acc[i] = acc[i].plus(towards.times(align_scale));
//    }
//  }
//}

//Vec2 getNeighborPos(float attraction_maxD, int index) {
//  Vec2 sum = pos[index];
//  Vec2 p = pos[index];
//  int count = 1;
//  for (int i = 0; i < numBoids; i++) {
//    float dist = pos[i].distanceTo(p);
//    if (dist < 0.01 || dist > attraction_maxD) continue; //i==j??
//    sum = sum.plus(pos[i]);
//    count++;
//  }

//  sum.x /= count;
//  sum.y /= count;

//  //fill(255);
//  //circle(sum.x, sum.y, 2*10);
//  //println(sum);
//  return sum;
//}

//Vec2 getNeighborVel(float alignment_maxDist, int index) {
//  Vec2 sum = vel[index];
//  Vec2 p = pos[index];
//  int count = 1;
//  for (int i = 0; i < numBoids; i++) {
//    float dist = pos[i].distanceTo(p);
//    if (dist < 0.01 || dist > alignment_maxDist) continue; //i==j??
//    Vec2 v = new Vec2(vel[i].x, vel[i].y);
//    v.normalize();
//    v.times(1/dist);
//    sum = sum.plus(v);
//    count++;
//  }
  
//  //sum.times(1/count);
//  //println(sum);
//  return sum;
//}

//void collisionDetection() {
//  for(int i = 0; i < numBoids; i++) {
//    for(int j = 0; j < numBoids; j++) {
//      if(i != j && pos[i].distanceTo(pos[j]) < 3+3) {
//        fill(255, 0, 0);
//        circle(pos[i].x, pos[j].y, 2*30);
//        //paused = true;
//        //break;
//      }
//    }
//  }
//}

//boolean paused = false;
//void draw() {
//  background(0);
//  float dt = 1/frameRate;
//  camera.Update(dt);
//  int substeps = 1;
//  if(!paused) {
//    for(int i = 0; i < substeps; i++) {
//      update(dt/substeps);
//    }
//  }
  
//  lightFalloff(2, 0.0, 2);
//  specular(120, 120, 180);
//  shininess(5);
//  ambientLight(255,255,255);
//  lightSpecular(255,255,255);
//  directionalLight(140, 140, 110, 1, 1, 1);
//  directionalLight(140, 140, 110, 0, 1, -1);
//  directionalLight(50, 50, 50, 0, -1, 0); 
//  sphereDetail(3);
  
//  //collisionDetection();
//  fill(100, 100, 200);
//  stroke(255);
//  strokeWeight(2);

//  //drawing boid
//  for (int i = 0; i < numBoids; i++) {
//    fill(100, 100, 200);
//    stroke(255);
//    pushMatrix();
//    translate(pos[i].x, pos[i].y);
//    //circle(0, 0, 2*10);
//    //Vec2 up = new Vec2(1, 0);
//    //float dotProd = dot(up, vel[i].normalized());
//    //dotProd = clamp(dotProd, -1, 1);
//    //float angleDiff = acos(dotProd);
//    //rotate(angleDiff);
//    //println(pos[i]);
//    //triangle(0, -bh/2, -bw/2, bh/2, bw/2, bh/2);
    
//    noStroke();
//    sphere(2*3);

//    ////separation radius
//    //noFill();
//    //stroke(255, 0, 0);
//    //circle(0, 0, 2*sepForce_maxD);

//    ////attraction radius
//    //noFill();
//    //stroke(0, 0, 255);
//    //circle(0, 0, 2*attraction_maxD);

//    ////alignment radius
//    //noFill();
//    //stroke(0, 255, 0);
//    //circle(0, 0, 2*alignment_maxDist);

//    fill(255);
//    stroke(255);
//    strokeWeight(2);
//    Vec2 dir = vel[i].normalized().times(10);
//    line(0, 0, dir.x, dir.y);
//    popMatrix();
//  }

//  noFill();
//  rect(0, 0, 1200, 750);
//}

////-----------------
//// Vector Library
////-----------------

////Vector Library
////CSCI 5611 Vector 2 Library [Example]
//// Stephen J. Guy <sjguy@umn.edu>

//public class Vec2 {
//  public float x, y;
  
//  public Vec2(float x, float y){
//    this.x = x;
//    this.y = y;
//  }
  
//  public String toString(){
//    return "(" + x+ "," + y +")";
//  }
  
//  public float length(){
//    return sqrt(x*x+y*y);
//  }
  
//  public float lengthSqr() {
//    return x*x+y*y;
//  }
  
//  public Vec2 plus(Vec2 rhs){
//    return new Vec2(x+rhs.x, y+rhs.y);
//  }
  
//  public void add(Vec2 rhs){
//    x += rhs.x;
//    y += rhs.y;
//  }
  
//  public Vec2 minus(Vec2 rhs){
//    return new Vec2(x-rhs.x, y-rhs.y);
//  }
  
//  public void subtract(Vec2 rhs){
//    x -= rhs.x;
//    y -= rhs.y;
//  }
  
//  public Vec2 times(float rhs){
//    return new Vec2(x*rhs, y*rhs);
//  }
  
//  public void mul(float rhs){
//    x *= rhs;
//    y *= rhs;
//  }
  
//  public void clampToLength(float maxL){
//    float magnitude = sqrt(x*x + y*y);
//    if (magnitude > maxL){
//      x *= maxL/magnitude;
//      y *= maxL/magnitude;
//    }
//  }
  
//  public void setToLength(float newL){
//    float magnitude = sqrt(x*x + y*y);
//    x *= newL/magnitude;
//    y *= newL/magnitude;
//  }
  
//  public void normalize(){
//    float magnitude = sqrt(x*x + y*y);
//    x /= magnitude;
//    y /= magnitude;
//  }
  
//  public Vec2 normalized(){
//    float magnitude = sqrt(x*x + y*y);
//    return new Vec2(x/magnitude, y/magnitude);
//  }
  
//  public float distanceTo(Vec2 rhs){
//    float dx = rhs.x - x;
//    float dy = rhs.y - y;
//    return sqrt(dx*dx + dy*dy);
//  }
//}

//Vec2 interpolate(Vec2 a, Vec2 b, float t){
//  return a.plus((b.minus(a)).times(t));
//}

//float interpolate(float a, float b, float t){
//  return a + ((b-a)*t);
//}

//float dot(Vec2 a, Vec2 b){
//  return a.x*b.x + a.y*b.y;
//}

//float cross(Vec2 a, Vec2 b){
//  return a.x*b.y - a.y*b.x;
//}


//Vec2 projAB(Vec2 a, Vec2 b){
//  return b.times(a.x*b.x + a.y*b.y);
//}

//float clamp(float f, float min, float max){
//  if (f < min) return min;
//  if (f > max) return max;
//  return f;
//}
