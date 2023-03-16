import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final BuildContext parentContext;

  const SettingsPage({Key? key, required this.parentContext}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences prefs;
  String? doctorAvatar;
  bool isManDocSelected = false;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      doctorAvatar = prefs.getString('DoctorAvatar');
      isManDocSelected = doctorAvatar == 'assets/male_avatar.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(
              color: Colors.black,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.logout_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          buildBackground(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(
                height: 75,
              ),
              const Text("Choose your favorite doctor avatar :",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
              const SizedBox(
                height: 75,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      prefs.setString(
                          'DoctorAvatar', 'assets/female_avatar.png');
                      setState(() {
                        doctorAvatar = 'assets/female_avatar.png';
                        isManDocSelected = false;
                      });
                      //Navigator.pop(context);
                    },
                    child: Container(
                      decoration: isManDocSelected
                          ? null
                          : BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withOpacity(0.3),
                            ),
                      child: Image.asset("assets/female_avatar.png",
                          width: 150, height: 150),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      prefs.setString('DoctorAvatar', 'assets/male_avatar.png');
                      setState(() {
                        doctorAvatar = 'assets/male_avatar.png';
                        isManDocSelected = true;
                      });
                      //Navigator.pop(context);
                    },
                    child: Container(
                      decoration: isManDocSelected
                          ? BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withOpacity(0.3),
                            )
                          : null,
                      child: Image.asset("assets/male_avatar.png",
                          width: 150, height: 150),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

Widget buildBackground() {
  return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/fin3.png"), fit: BoxFit.fill)));
}
