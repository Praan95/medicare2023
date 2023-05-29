import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BackgroundWaveContainer extends StatelessWidget {
  BackgroundWaveContainer({
    Key? key,
    required this.height,
    required this.child,
  }) : super(key: key);

  late Widget child;
  late double height;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
        clipper: BackgroundWaveClipper(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.teal, Color.fromARGB(255, 91, 224, 193)],
          )),
          child: child,
        ));
  }
}

class BackgroundWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    final p0 = size.height;
    path.lineTo(0.0, p0);

    final controlPoint = Offset(size.width * 0.02, size.height * 0.85);
    final endPoint = Offset(size.width * 0.25, size.height * 0.85);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width * 0.75, size.height * 0.85);

    final controlPoint2 = Offset(size.width * 0.98, size.height * 0.85);
    final endPoint2 = Offset(size.width, size.height * 0.7);
    path.quadraticBezierTo(
        controlPoint2.dx, controlPoint2.dy, endPoint2.dx, endPoint2.dy);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BackgroundWaveClipper oldClipper) => oldClipper != this;
}
