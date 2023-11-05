import 'package:app_vhc/res.dart';
import 'package:app_vhc/screen/camera/controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CameraSection extends StatelessWidget {
  const CameraSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CameraScreenController>(context);
    const aspectRatio = 355.0 / 467.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(47),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          children: [
            Positioned.fill(
              child: ValueListenableBuilder(
                valueListenable: controller.selectedCamera,
                builder: (_, camera, fallback) => camera == null //
                    ? fallback!
                    : CameraView(camera: camera),
                child: Container(color: const Color(0xff000000)),
              ),
            ),
            Positioned(
              right: 13,
              bottom: 46,
              child: Semantics(
                label: "Flash",
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffffffff),
                  ),
                  child: SvgPicture.asset(Res.flash),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraView extends StatefulWidget {
  final CameraDescription camera;
  const CameraView({required this.camera, super.key});

  @override
  State<StatefulWidget> createState() {
    return CameraViewState();
  }
}

class CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  late CameraController controller;

  _initController() {
    controller = CameraController(widget.camera, ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initController();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controller.value.isInitialized == true
        ? CameraPreview(controller)
        : Container(color: const Color(0xff000000));
  }
}
