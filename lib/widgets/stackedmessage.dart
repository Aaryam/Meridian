import 'package:flutter/material.dart';

class StackedMessage extends StatelessWidget {

  final String text;

  const StackedMessage({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
      height: 80,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        child: Text(
        '$text'
      ),
      padding: EdgeInsets.all(20),
      ),
    ),
    );
  }
}