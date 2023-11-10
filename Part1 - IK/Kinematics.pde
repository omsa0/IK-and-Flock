//toggles movement and speed restrictions
boolean restricted = true;
float scale = 0.2; //speeds up or slows down movement, but keeping their relative velocities and restrictions
boolean leftReaching = false; //to indicate which arm is reaching

void solve() {

  Vec2 startToGoal, startToEndEffector;
  float dotProd, angleDiff;

  //so only one hand reaches out
  if (goal.distanceTo(endPoint_right) > goal.distanceTo(endPoint_left)) {
    leftReaching = true;
    //Update left wrist joint
    startToGoal = goal.minus(start_left1);
    startToEndEffector = endPoint_left.minus(start_left1);
    dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
    dotProd = clamp(dotProd, -1, 1);
    angleDiff = acos(dotProd);
    if (restricted) angleDiff = clamp(angleDiff, -0.1 * scale, 0.1 * scale);   //Velocity limit
    if (cross(startToGoal, startToEndEffector) < 0)
      la1 += angleDiff;
    else
      la1 -= angleDiff;
    //if (restricted) la1 = clamp(la1, -PI * 3/4, PI/2); // joint limits
    fk(); //Update link positions with fk (e.g. end effector changed)


    //Update left shoulder joint
    startToGoal = goal.minus(start_l2);
    startToEndEffector = endPoint_left.minus(start_l2);
    dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
    dotProd = clamp(dotProd, -1, 1);
    angleDiff = acos(dotProd);
    if (restricted) angleDiff = clamp(angleDiff, -0.1 * scale, 0.1 * scale);   //Velocity limit
    if (cross(startToGoal, startToEndEffector) < 0)
      la0 += angleDiff;
    else
      la0 -= angleDiff;
    //if (restricted) la0 = clamp(la0, -PI * 3/4, PI/2); // joint limits
    fk(); //Update link positions with fk (e.g. end effector changed)
  } else {
    leftReaching = false;

    //Update right wrist joint
    startToGoal = goal.minus(start_right1);
    startToEndEffector = endPoint_right.minus(start_right1);
    dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
    dotProd = clamp(dotProd, -1, 1);
    angleDiff = acos(dotProd);
    if (restricted) angleDiff = clamp(angleDiff, -0.1 * scale, 0.1 * scale);   //Velocity limit
    if (cross(startToGoal, startToEndEffector) < 0)
      ra1 += angleDiff;
    else
      ra1 -= angleDiff;
    //if (restricted) ra1 = clamp(ra1, -PI/2, (PI * 3/4)); // joint limits
    fk(); //Update link positions with fk (e.g. end effector changed)


    //Update right shoulder joint
    startToGoal = goal.minus(start_l2);
    startToEndEffector = endPoint_right.minus(start_l2);
    dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
    dotProd = clamp(dotProd, -1, 1);
    angleDiff = acos(dotProd);
    if (restricted) angleDiff = clamp(angleDiff, -0.1 * scale, 0.1 * scale);   //Velocity limit
    if (cross(startToGoal, startToEndEffector) < 0)
      ra0 += angleDiff;
    else
      ra0 -= angleDiff;
    //if (restricted) ra0 = clamp(ra0, -PI/2, (PI * 3/4)); // joint limits
    fk(); //Update link positions with fk (e.g. end effector changed)
  }


  //Update middle spine joint
  startToGoal = goal.minus(start_l1);
  if (leftReaching) startToEndEffector = endPoint_left.minus(start_l1);
  else startToEndEffector = endPoint_right.minus(start_l1);
  dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
  dotProd = clamp(dotProd, -1, 1);
  angleDiff = acos(dotProd);
  if (restricted) angleDiff = clamp(angleDiff, -0.07 * scale, 0.07 * scale);   //Velocity limit
  if (cross(startToGoal, startToEndEffector) < 0)
    a1 += angleDiff;
  else
    a1 -= angleDiff;
  if (restricted) a1 = clamp(a1, -PI/2, (PI/2)); // joint limits
  fk(); //Update link positions with fk (e.g. end effector changed)


  //Update root joint
  startToGoal = goal.minus(root);
  if (startToGoal.length() < .0001) return;
  if (leftReaching) startToEndEffector = endPoint_left.minus(root);
  else startToEndEffector = endPoint_right.minus(root);
  dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
  dotProd = clamp(dotProd, -1, 1);
  angleDiff = acos(dotProd);
  if (restricted) angleDiff = clamp(angleDiff, -0.05 * scale, 0.05 * scale);   //Velocity limit
  if (cross(startToGoal, startToEndEffector) < 0)
    a0 += angleDiff;
  else
    a0 -= angleDiff;
  if (restricted) a0 = clamp(a0, -PI * 3/4, -(PI * 1/4)); // joint limits
   fk(); //Update link positions with fk (e.g. end effector changed)

  println("Angle 0:", a0, "Angle 1:", a1, "Left 0:", la0, "Left 1", la1, "Right 0", ra0, "Right 1", ra1);
}

void fk() {
  start_l1 = new Vec2(cos(a0)*l0, sin(a0)*l0).plus(root);
  start_l2 = new Vec2(cos(a0+a1)*l1, sin(a0+a1)*l1).plus(start_l1);

  start_left1 = new Vec2(cos(a0+a1+la0)*ll0, sin(a0+a1+la0)*ll0).plus(start_l2);
  endPoint_left = new Vec2(cos(a0+a1+la0+la1)*ll1, sin(a0+a1+la0+la1)*ll1).plus(start_left1);

  start_right1 = new Vec2(cos(a0+a1+ra0)*rl0, sin(a0+a1+ra0)*rl0).plus(start_l2);
  endPoint_right = new Vec2(cos(a0+a1+ra0+ra1)*rl1, sin(a0+a1+ra0+ra1)*rl1).plus(start_right1);
  //println(start_right1, endPoint_right, start_left1, endPoint_left);
}



void solveGoal(Vec2 goal) {
  
  Vec2 startToGoal, startToEndEffector;
  float dotProd, angleDiff;

  //so only one hand reaches out
  if (leftReaching) {
    //Update left wrist joint
    startToGoal = goal.minus(start_left1);
    startToEndEffector = endPoint_left.minus(start_left1);
    dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
    dotProd = clamp(dotProd, -1, 1);
    angleDiff = acos(dotProd);
    if (restricted) angleDiff = clamp(angleDiff, -0.1 * scale, 0.1 * scale);   //Velocity limit
    if (cross(startToGoal, startToEndEffector) < 0)
      la1 += angleDiff;
    else
      la1 -= angleDiff;
    //if (restricted) la1 = clamp(la1, -PI * 3/4, PI/2); // joint limits
    fk(); //Update link positions with fk (e.g. end effector changed)


    //Update left shoulder joint
    startToGoal = goal.minus(start_l2);
    startToEndEffector = endPoint_left.minus(start_l2);
    dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
    dotProd = clamp(dotProd, -1, 1);
    angleDiff = acos(dotProd);
    if (restricted) angleDiff = clamp(angleDiff, -0.1 * scale, 0.1 * scale);   //Velocity limit
    if (cross(startToGoal, startToEndEffector) < 0)
      la0 += angleDiff;
    else
      la0 -= angleDiff;
    //if (restricted) la0 = clamp(la0, -PI * 3/4, PI/2); // joint limits
    fk(); //Update link positions with fk (e.g. end effector changed)
  } else {
    //Update right wrist joint
    startToGoal = goal.minus(start_right1);
    startToEndEffector = endPoint_right.minus(start_right1);
    dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
    dotProd = clamp(dotProd, -1, 1);
    angleDiff = acos(dotProd);
    if (restricted) angleDiff = clamp(angleDiff, -0.1 * scale, 0.1 * scale);   //Velocity limit
    if (cross(startToGoal, startToEndEffector) < 0)
      ra1 += angleDiff;
    else
      ra1 -= angleDiff;
    //if (restricted) ra1 = clamp(ra1, -PI/2, (PI * 3/4)); // joint limits
    fk(); //Update link positions with fk (e.g. end effector changed)


    //Update right shoulder joint
    startToGoal = goal.minus(start_l2);
    startToEndEffector = endPoint_right.minus(start_l2);
    dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
    dotProd = clamp(dotProd, -1, 1);
    angleDiff = acos(dotProd);
    if (restricted) angleDiff = clamp(angleDiff, -0.1 * scale, 0.1 * scale);   //Velocity limit
    if (cross(startToGoal, startToEndEffector) < 0)
      ra0 += angleDiff;
    else
      ra0 -= angleDiff;
    //if (restricted) ra0 = clamp(ra0, -PI/2, (PI * 3/4)); // joint limits
    fk(); //Update link positions with fk (e.g. end effector changed)
  }


  //Update middle spine joint
  startToGoal = goal.minus(start_l1);
  if (leftReaching) startToEndEffector = endPoint_left.minus(start_l1);
  else startToEndEffector = endPoint_right.minus(start_l1);
  dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
  dotProd = clamp(dotProd, -1, 1);
  angleDiff = acos(dotProd);
  if (restricted) angleDiff = clamp(angleDiff, -0.07 * scale, 0.07 * scale);   //Velocity limit
  if (cross(startToGoal, startToEndEffector) < 0)
    a1 += angleDiff;
  else
    a1 -= angleDiff;
  if (restricted) a1 = clamp(a1, -PI/2, (PI/2)); // joint limits
  fk(); //Update link positions with fk (e.g. end effector changed)


  //Update root joint
  startToGoal = goal.minus(root);
  if (startToGoal.length() < .0001) return;
  if (leftReaching) startToEndEffector = endPoint_left.minus(root);
  else startToEndEffector = endPoint_right.minus(root);
  dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
  dotProd = clamp(dotProd, -1, 1);
  angleDiff = acos(dotProd);
  if (restricted) angleDiff = clamp(angleDiff, -0.05 * scale, 0.05 * scale);   //Velocity limit
  if (cross(startToGoal, startToEndEffector) < 0)
    a0 += angleDiff;
  else
    a0 -= angleDiff;
  if (restricted) a0 = clamp(a0, -PI * 3/4, -(PI * 1/4)); // joint limits
  fk(); //Update link positions with fk (e.g. end effector changed)

  println("Angle 0:", a0, "Angle 1:", a1, "Left 0:", la0, "Left 1", la1, "Right 0", ra0, "Right 1", ra1);
}
