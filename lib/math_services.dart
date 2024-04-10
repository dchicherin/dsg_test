import 'dart:ui';

class MathServices {
  //Checking if lines intersect
  bool checkIntersection(Offset a1, Offset b1, Offset a2, Offset b2) {
    double a = a1.dx;
    double b = a1.dy;
    double c = b1.dx;
    double d = b1.dy;
    double p = a2.dx;
    double q = a2.dy;
    double r = b2.dx;
    double s = b2.dy;
    double det = (c - a) * (s - q) - (r - p) * (d - b);
    if (det == 0) {
      return false;
    } else {
      double lambda = ((s - q) * (r - a) + (p - r) * (s - b)) / det;
      double gamma = ((b - d) * (r - a) + (c - a) * (s - b)) / det;
      if ((0 < lambda && lambda < 0.99) && (0 < gamma && gamma < 0.99)) {
        print("det is $det, lambda is $lambda gamma is $gamma");
      }

      return (0 < lambda && lambda < 0.99) && (0 < gamma && gamma < 0.99);
    }
  }
}
