public boolean circleLine(Vec2 center, float r, Vec2 l_start, Vec2 l_dir, float l_len) {
  //Compute W - a displacement vector pointing from the start of the line segment to the center of the circle
  Vec2 toCircle = center.minus(l_start);

  //Solve quadratic equation for intersection point (in terms of l_dir and toCircle)
  float a = 1.0;  //Lenght of l_dir (we noramlized it)
  float b = -2*dot(l_dir, toCircle); //-2*dot(l_dir,toCircle)
  float c = toCircle.lengthSqr() - (r)*(r); //different of squared distances

  float d = b*b - 4*a*c; //discriminant

  if (d >=0 ) {
    //If d is positive we know the line is colliding, but we need to check if the collision line within the line segment
    //  ... this means t will be between 0 and the lenth of the line segment
    float t1 = (-b - sqrt(d))/(2.0*a);
    float t2 = (-b + sqrt(d))/(2.0*a);
    //println(hit.t,t1,t2);
    if (t1 > 0 && t1 < l_len) {
      return true;
    } else if (t2 > 0 && t2 < l_len) {
      return true;
    }
  }
  return false;
}
