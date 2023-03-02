import 'package:flutter/material.dart';

class HomaPage extends StatelessWidget {
  const HomaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/backgroundHomepage.png"),
                      fit: BoxFit.fill)
              ),
            ),
            Positioned(
              top: (MediaQuery
                  .of(context)
                  .size
                  .height - 660) / 2,
              left: (MediaQuery
                  .of(context)
                  .size
                  .width - 270) / 2,
              child: Stack(
                  children: [
                    Container(
                      width: 270,
                      height: 270,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/logo.png")),
                      ),
                    ),
                    Positioned(
                        top: (MediaQuery
                            .of(context)
                            .size
                            .height - 500) / 2,
                        left: (MediaQuery
                            .of(context)
                            .size
                            .width - 245) / 2, child: Text('HealthLink',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Color(0xFF00ACC2)
                      ),
                    )),
                  ]
              ),
            ),
            Positioned(
                top: (MediaQuery
                    .of(context)
                    .size
                    .height + 60) / 2,
                left: (MediaQuery
                    .of(context)
                    .size
                    .width - 243) / 2,
                child: Container(
                    width: 250,
                    height: 36,
                    child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  width: 1, color: Color(0xFF00ACC2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  width: 1, color: Color(0xFF00ACC2)),

                            )
                        )
                    )
                )
            ),
            Positioned(
              top: (MediaQuery
                  .of(context)
                  .size
                  .height + 200) / 2,
              left: (MediaQuery
                  .of(context)
                  .size
                  .width - 215) / 2, child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Color(0xFFFFFFFF),
                    minimumSize: Size(220, 45),
                    backgroundColor: Color(0xFFEF8808)
                ),
                onPressed: () {},
                child: Text('Continue')
            ),),
            Positioned(top: (MediaQuery
                .of(context)
                .size
                .height + 700) / 2,
                left: (MediaQuery
                    .of(context)
                    .size
                    .width - 177) / 2, child: TextButton(
                  onPressed: () {},
                  child: Text('Continue anonymously', style: TextStyle(fontWeight: FontWeight.w500,
                      fontSize: 19, color: Color(0xFFEF8808))),
                ))
          ],
        )
    );
  }
}
