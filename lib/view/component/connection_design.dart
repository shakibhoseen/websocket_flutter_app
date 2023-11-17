import 'package:flutter/material.dart';

class ConnectionDesign extends StatelessWidget {
  MaterialColor color;
   ConnectionDesign({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = [color.shade700, color.shade600,  color.shade500, color.shade400, color.shade300, color.shade200,  ];
    return mainCard(colors, colors.length-1);
  }
}

Widget mainCard(List<Color> colors, int index){
  if(index<0) return Icon(Icons.add);

  return CircleCard(color: colors[index], child: mainCard(colors, index-1));
}

Widget CircleCard({ required final color, required Widget child}){
  return Container(
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
       color: color,
    ),
    child: child,
  );
}