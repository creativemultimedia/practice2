import 'package:flutter/material.dart';
import 'package:practice2/wallpaper.dart';

void main() {
  runApp(MaterialApp(
    home: wallpaper(),
  ));
}
class slide extends StatefulWidget {
  const slide({Key? key}) : super(key: key);

  @override
  State<slide> createState() => _slideState();
}

class _slideState extends State<slide> with SingleTickerProviderStateMixin{
  AnimationController? controller;
  Animation<Offset>? offset;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, -1.0))
        .animate(controller!);
    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Align(
        alignment: Alignment.bottomCenter,
        child: SlideTransition(
          position: offset!,
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: Column(
              children: [
                Text("Hello"),
                Text("Hello"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



