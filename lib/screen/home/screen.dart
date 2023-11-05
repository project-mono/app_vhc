import 'package:app_vhc/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../camera/filter_wheel_picker.dart';
import 'action_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);

    const titleStyle = TextStyle(fontSize: 40);
    const subtitleStyle = TextStyle(fontSize: 20, color: Color(0xff8A8A8A));
    const contentStyle =
        TextStyle(fontSize: 18, color: Color(0xff7B7B7B), fontFamily: "Lora");

    const title = "Virtual\nHair Color";
    const subtitle = "AI Camera App";
    const content =
        "It's time for change! Try a new hair shade has never been easier! have a fun with this app you can choose best hair color for yourself with our AI technology.";

    onTry() {
      router.push(Uri(path: "/camera").toString());
    }

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 47),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 112),
                      child: Text(title, style: titleStyle),
                    ),
                    Text(subtitle, style: subtitleStyle),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(content, style: contentStyle),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: ActionButton(
                    onTap: onTry,
                    title: "Try Now Free",
                    subtitle: "Limited access of filters",
                    gradient: const RadialGradient(
                      center: Alignment(-1 + 0.0648, -1 - 0.0698),
                      radius: 0.9396,
                      colors: [Color(0xffB2E3FF), Color(0xff00A3FF)],
                      stops: [0, 1],
                    ),
                    shadow: const [
                      BoxShadow(
                        offset: Offset(10, 10),
                        blurRadius: 20,
                        spreadRadius: 0,
                        color: Color.fromRGBO(0, 163, 255, 0.10),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: ActionButton(
                    title: "Buy Premium Now",
                    subtitle: "Get unlimited access to all files",
                    gradient: RadialGradient(
                      center: Alignment(-1 + 0.0648, -1 + 0.5),
                      radius: 1.2006,
                      colors: [Color(0xffFFED91), Color(0xffFFB800)],
                      stops: [0, 1],
                    ),
                    shadow: [
                      BoxShadow(
                        offset: Offset(10, 10),
                        blurRadius: 20,
                        spreadRadius: 0,
                        color: Color.fromRGBO(255, 214, 0, 0.10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
          Positioned(
            left: 25,
            top: 70.5,
            child: SvgPicture.asset(Res.more, semanticsLabel: "More"),
          ),
          // hot layout preload
          const IgnorePointer(
            ignoring: true,
            child: Opacity(opacity: 0, child: FilterWheelPicker()),
          ),
        ]),
      ),
    );
  }
}
