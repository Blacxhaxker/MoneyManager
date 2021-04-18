import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: <Widget>[
            SizedBox(
              height: 18,
            ),
            Container(
              height: constraints.maxHeight * 0.6,
              child: Image.asset("assets/images/no_content.png", fit: BoxFit.fitWidth),
            ),
          ],
        );
      },
    );
  }
}
