import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WhitrCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final String? title;
  const WhitrCard({Key? key, required this.child, this.title, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(10.0),
      decoration: buildBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            FittedBox(
              child: Text(
                title!,
                style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
          ],
          child,
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5.0),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)]);
}
