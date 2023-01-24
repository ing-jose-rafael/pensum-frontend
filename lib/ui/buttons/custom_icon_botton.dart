import 'package:flutter/material.dart';

class CustomIconBotton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final IconData icon;
  final bool isFilled;
  final Color color;

  const CustomIconBotton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.isFilled = false,
    this.color = Colors.indigo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => onPressed(),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          Text(text, style: TextStyle(color: Colors.white)),
        ],
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(StadiumBorder()),
        backgroundColor: MaterialStateProperty.all(color.withOpacity(0.5)),
        overlayColor: MaterialStateProperty.all(color.withOpacity(0.3)),
      ),
    );
  }
}
