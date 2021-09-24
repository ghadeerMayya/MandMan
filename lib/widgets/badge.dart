import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget? childd;
  final String value;
  final Color color;

  const Badge({
    required this.value,
    required this.color,
    required this.childd,
  });

  @override
  Widget build(BuildContext context) {
    final Widget child=childd!;
    return Stack(
      alignment: Alignment.center,
      children: [
       child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color != null ? color : Theme.of(context).accentColor,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
            constraints: BoxConstraints(minHeight: 16, minWidth: 16),
          ),
        )
      ],
    );
  }
}
