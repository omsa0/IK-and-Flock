void setup() {
  size(1200, 750, P3D);
  surface.setTitle("Porject 3 - Flock");
  camera = new Camera();
  camera.position = new PVector(600, 375, 900);
  generateBoids();
}

Camera camera;
float depth = -750;

//boids
int numBoids = 500;
Vec3 pos[] = new Vec3[numBoids];
Vec3 vel[] = new Vec3[numBoids];
Vec3 acc[] = new Vec3[numBoids];
Vec3 colors[] = new Vec3[numBoids];

float bw = 25; //boid width
float bh = 50; //boid width

//Params
float sepForce_maxD = 40;
float separationScale = 40000;

float attraction_maxD = 100;
float attractionForce_scale = 20;

float alignment_maxDist = 100;
float align_scale = 600;

void generateBoids() {
  for (int i = 0; i < numBoids; i++) {
    pos[i] = new Vec3(random(100, 1000), random(100, 600), random(-600, -100));
    vel[i] = new Vec3(random(-200, 200), random(-200, 200), random(200, 700));
    acc[i] = new Vec3(0, 0, 0);
    colors[i] = new Vec3(random(100, 255), random(100, 255), random(100, 255));
  }
}

void keyPressed()
{
  camera.HandleKeyPressed();

  if (key == 'z') {
    generateBoids();
  }
  if (key == ' ') {
    paused = !paused;
  }
}

void keyReleased()
{
  camera.HandleKeyReleased();
}

void update(float dt) {
  
  //integration
  for (int i = 0; i < numBoids; i++) {
    vel[i] = vel[i].plus(acc[i].times(dt));
    vel[i] = vel[i].plus(new Vec3(random(-20,20), random(-20,20), random(-20,20))); // random noise
    
    //max/min vel
    vel[i].x = clamp(vel[i].x, -330, 330);
    vel[i].y = clamp(vel[i].y, -330, 330);
    vel[i].z = clamp(vel[i].z, -330, 330);
    
    pos[i] = pos[i].plus(vel[i].times(dt));
    acc[i] = new Vec3(0, 0, 0);
    
    //turning once it is getting close to boundaries
    if (pos[i].x+200 > width) {
      vel[i].x = vel[i].x - 20 ;
    }
    if (pos[i].x-200 < 0) {
      vel[i].x = vel[i].x + 20;
    }
    if (pos[i].y-200 < 0) {
      vel[i].y = vel[i].y + 20;
    }
    if (pos[i].y+200 > height) {
      vel[i].y = vel[i].y - 20;
    }
    if (pos[i].z+100 > 0) {
      vel[i].z = vel[i].z - 20;
    }
    if (pos[i].z-100 < depth) {
      vel[i].z = vel[i].z + 20;
    }
  }


  //forces
  for (int i = 0; i < numBoids; i++) {
    //Separation Force
    for (int j = 0; j < numBoids; j++) {
      float dist = pos[i].distanceTo(pos[j]);
      if (dist < 0.01|| dist > sepForce_maxD) continue; //i==j??
      Vec3 seperationForce = pos[i].minus(pos[j]);
      seperationForce.setToLength(separationScale/pow(dist, 1));
      acc[i] = acc[i].plus(seperationForce);
    }
    
    //Attraction Force
    Vec3 avgPos = getNeighborPos(attraction_maxD, i);
    Vec3 attractionForce = avgPos.minus(pos[i]);
    if (attractionForce.lengthSqr() > 0.01) {
      attractionForce.normalize();
      attractionForce.mul(attractionForce_scale);
      acc[i] = acc[i].plus(attractionForce);
    }

    //Alignment Force
    Vec3 avgNeighborVel = getNeighborVel(alignment_maxDist, i);
    Vec3 towards = avgNeighborVel.minus(vel[i]);
    if (towards.lengthSqr() > 0.01) {
      towards.normalize();
      acc[i] = acc[i].plus(towards.times(align_scale));
    }
  }
}

Vec3 getNeighborPos(float attraction_maxD, int index) {
  Vec3 sum = pos[index];
  Vec3 p = pos[index];
  int count = 1;
  for (int i = 0; i < numBoids; i++) {
    float dist = pos[i].distanceTo(p);
    if (dist < 0.01 || dist > attraction_maxD) continue; //i==j??
    sum = sum.plus(pos[i]);
    count++;
  }

  sum.x /= count;
  sum.y /= count;

  //fill(255);
  //circle(sum.x, sum.y, 2*10);
  //println(sum);
  return sum;
}

Vec3 getNeighborVel(float alignment_maxDist, int index) {
  Vec3 sum = vel[index];
  Vec3 p = pos[index];
  int count = 1;
  for (int i = 0; i < numBoids; i++) {
    float dist = pos[i].distanceTo(p);
    if (dist < 0.01 || dist > alignment_maxDist) continue; //i==j??
    Vec3 v = new Vec3(vel[i].x, vel[i].y, vel[i].z);
    v.normalize();
    v.times(1/dist);
    sum = sum.plus(v);
    count++;
  }
  
  //sum.times(1/count);
  //println(sum);
  return sum;
}

boolean paused = false;
void draw() {
  background(10, 20, 50);
  float dt = 1/frameRate;
  camera.Update(dt);
  int substeps = 1;
  if(!paused) {
    for(int i = 0; i < substeps; i++) {
      update(dt/substeps);
    }
  }
  
  stroke(255);
  strokeWeight(2);
  
  lightSpecular(180, 180,180);
  lightFalloff(0.5, 0.005, 0);
  specular(100, 100, 100);
  shininess(3);
  ambientLight(100,100,100);
  pointLight(200, 200, 200, width/2, 0, depth/2);
  pointLight(200, 200, 200, 0, height/2, depth/2);
  pointLight(200, 200, 200, width/2, height/2, 0);
  //directionalLight(200, 200, 200, 1, 1, 1);
  //directionalLight(200, 200, 200, 1, 1, -1);
  //directionalLight(50, 50, 50, 0, -1, 0); 
  sphereDetail(10);
  
  fill(100, 100, 200);
  //drawing boid
  for (int i = 0; i < numBoids; i++) {
    fill(colors[i].x, colors[i].y, colors[i].z);
    stroke(255);
    strokeWeight(2);
    pushMatrix();
    translate(pos[i].x, pos[i].y, pos[i].z);

    noStroke();
    sphere(2*3);

    fill(255);
    Vec3 dir = vel[i].normalized().times(8);
    translate(dir.x, dir.y, dir.z);
    sphere(2*2);
    popMatrix();
  }
  
  pushMatrix();
  translate(width/2, height/2, depth/2);
  //sphere(50);//box center
  noFill();
  stroke(255);
  strokeWeight(2);
  box(width, height, depth);
  popMatrix();
}

//---------------
//Vec 3 Library
//---------------

// Vector Library
// Adapted from Vec2 Library by Stephen J. Guy <sjguy@umn.edu>

public class Vec3 {
  public float x, y, z;

  public Vec3(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  public String toString() {
    return "(" + x + ", " + y + ", " + z + ")";
  }

  public float length() {
    return sqrt(x * x + y * y + z * z);
  }

  public float lengthSqr() {
    return x * x + y * y;
  }

  public Vec3 plus(Vec3 rhs) {
    return new Vec3(x + rhs.x, y + rhs.y, z + rhs.z);
  }

  public void add(Vec3 rhs) {
    x += rhs.x;
    y += rhs.y;
  }

  public Vec3 minus(Vec3 rhs) {
    return new Vec3(x - rhs.x, y - rhs.y, z - rhs.z);
  }

  public void subtract(Vec3 rhs) {
    x -= rhs.x;
    y -= rhs.y;
    z -= rhs.z;
  }

  public Vec3 times(float rhs) {
    return new Vec3(x * rhs, y * rhs, z * rhs);
  }

  public void mul(float rhs) {
    x *= rhs;
    y *= rhs;
    z *= rhs;
  }

  public void clampToLength(float maxL) {
    float magnitude = sqrt(x * x + y * y + z * z);
    if (magnitude > maxL) {
      x *= maxL / magnitude;
      y *= maxL / magnitude;
      z *= maxL / magnitude;
    }
  }

  public void setToLength(float newL) {
    float magnitude = sqrt(x * x + y * y + z * z);
    x *= newL / magnitude;
    y *= newL / magnitude;
    z *= newL / magnitude;
  }

  public void normalize() {
    float magnitude = sqrt(x * x + y * y + z * z);
    x /= magnitude;
    y /= magnitude;
    z /= magnitude;
  }

  public Vec3 normalized() {
    float magnitude = sqrt(x * x + y * y + z * z);
    return new Vec3(x / magnitude, y / magnitude, z / magnitude);
  }

  public float distanceTo(Vec3 rhs) {
    float dx = rhs.x - x;
    float dy = rhs.y - y;
    float dz = rhs.z - z;
    return sqrt(dx * dx + dy * dy + dz * dz);
  }
}

Vec3 interpolate(Vec3 a, Vec3 b, float t) {
  return a.plus((b.minus(a)).times(t));
}

float interpolate(float a, float b, float t) {
  return a + ((b - a) * t);
}

float dot(Vec3 a, Vec3 b) {
  return a.x * b.x + a.y * b.y + a.z * b.z;
}

Vec3 cross(Vec3 a, Vec3 b) {
  float u1 = a.x;
  float u2 = a.y;
  float u3 = a.z;
  float v1 = b.x;
  float v2 = b.y;
  float v3 = b.z;
  return new Vec3(u2*v3 - u3*v2, u3*v1 - u1*v3, u1*v2-u2*v1);
}

Vec3 projAB(Vec3 a, Vec3 b) {
  return b.times(a.x * b.x + a.y * b.y + a.z * b.z);
}

float clamp(float f, float min, float max){
  if (f < min) return min;
  if (f > max) return max;
  return f;
}
