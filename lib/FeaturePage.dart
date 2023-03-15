import 'package:flutter/material.dart';

class FeaturePage extends StatelessWidget {
  const FeaturePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            buildBackground(),
            Center(
              child: Text(
                'We appologize, but this feature has not been developed yet. We appreciate your patience!'
              ),
            )
          ],
        ),
    );
  }

  Widget buildBackground() {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/fin3.png"),
                fit: BoxFit.fill)
        )
    );
  }
}
