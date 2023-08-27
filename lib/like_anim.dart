import 'package:flutter/cupertino.dart';

class Like_animation extends StatefulWidget{
  const Like_animation({super.key,required this.child,required this.isanimating,this.duration=const Duration(milliseconds: 150),this.onend,this.smalllike=false});
  final Widget child;
  final bool isanimating;
  final Duration duration;
  final VoidCallback? onend;
  final bool smalllike;


  @override
  State<StatefulWidget> createState() {
    return _likeanimatiosstate();
  }

}

class _likeanimatiosstate extends State<Like_animation> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> scale;

@override
  void initstate(){
    super.initState();
    controller=AnimationController(vsync: this,duration: Duration(milliseconds:widget.duration.inMilliseconds~/2 ),

    );
    scale=Tween<double>(begin: 1,end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant Like_animation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(widget.isanimating!=oldWidget.isanimating){
      startanimation();
    }
  }
  startanimation()async{
if(widget.isanimating|| widget.smalllike){
  await controller.forward();
  await controller.reverse();
  await Future.delayed(const Duration(milliseconds: 200));
  if(widget.onend!=null){
    widget.onend!();
  }
}
  }
  @override
  void dispose() {

    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: scale,child: widget.child,);
  }

}