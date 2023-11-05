import 'package:app_vhc/res.dart';
import 'package:app_vhc/screen/camera/camera_section.dart';
import 'package:app_vhc/screen/camera/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fc/flutter_fc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'filter_wheel_picker.dart';

enum CameraFilter { src, gray, cyan }

class CameraScreen extends FCWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    final controller = useMemo(() => CameraScreenController(), const []);

    useEffect(() {
      Future(() async {
        if (await controller.requestPermissions() == true) {
          controller.loadCameras();
        } else {
          messenger.hideCurrentSnackBar();
          messenger.showSnackBar(
              const SnackBar(content: Text("No Camera Permission")));
        }
      });
      return () => controller.dispose();
    }, const []);

    return Provider<CameraScreenController>.value(
      value: controller,
      child: const Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: CameraSection(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: FilterWheelPicker(),
                ),
                Expanded(child: ActionView()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActionView extends StatelessWidget {
  const ActionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Semantics(
          label: "Pick from gallery",
          child: SvgPicture.asset(Res.image),
        ),
        Semantics(
          label: "Shot",
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              color: Color(0xffFFED90),
              shape: BoxShape.circle,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
              decoration: const BoxDecoration(
                color: Color(0xffFFB800),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(Res.shot, width: 22, height: 18),
            ),
          ),
        ),
        Semantics(
          label: "Swap camera",
          child: SvgPicture.asset(Res.swap_camera),
        ),
      ],
    );
  }
}
