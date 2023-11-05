import 'package:app_vhc/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ActionButton extends StatelessWidget {
  final Gradient? gradient;
  final List<BoxShadow>? shadow;
  final String title;
  final String subtitle;
  final Function()? onTap;
  const ActionButton({
    required this.title,
    required this.subtitle,
    this.gradient,
    this.shadow,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(color: Color(0xffffffff), fontSize: 20);
    const subtitleStyle = TextStyle(color: Color(0xffffffff), fontSize: 12);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: gradient,
          boxShadow: shadow,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(title, style: titleStyle),
                  Text(subtitle, maxLines: 2, style: subtitleStyle),
                ],
              ),
            ),
            SvgPicture.asset(
              Res.arrow_right,
              width: 11,
              height: 27,
            )
          ],
        ),
      ),
    );
  }
}
