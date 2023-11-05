import 'dart:math';

import 'package:app_vhc/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fc/flutter_fc.dart';
import 'package:app_vhc/screen/camera/screen.dart' show CameraFilter;

class FilterWheelPicker extends FCWidget {
  const FilterWheelPicker({super.key});

  @override
  Widget build(BuildContext context) {
    const resMap = <CameraFilter, String>{
      CameraFilter.src: Res.filter_src,
      CameraFilter.cyan: Res.filter_cyan,
      CameraFilter.gray: Res.filter_gray,
    };

    const paddingX = 6.5;
    const extent = 16.0 + paddingX * 2;
    const focusPaddingX = 8.5;
    const focusSize = 26.0;
    const focusExtent = 26.0 + focusPaddingX * 2;

    return Stack(alignment: Alignment.center, children: [
      SizedBox(
        height: focusExtent,
        child: RotatedBox(
          quarterTurns: 3,
          child: ListWheelScrollView.useDelegate(
            itemExtent: extent,
            magnification: focusExtent / extent,
            useMagnifier: true,
            diameterRatio: focusExtent,
            physics: const SnapNearestItemScrollPhysics(extent),
            childDelegate: ListWheelChildLoopingListDelegate(
              children: List.generate(resMap.length, (index) {
                final realIndex = index % resMap.length;
                final key = resMap.keys.elementAt(realIndex);
                return Padding(
                  padding: const EdgeInsets.all(paddingX),
                  child: Transform.rotate(
                    angle: 90 / 180 * pi,
                    child: Image.asset(
                      resMap[key]!,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      const Mask(),
      const SizedBox(
        width: focusSize + 6,
        height: focusSize + 6,
        child: SelectCircle(),
      ),
    ]);
  }
}

class Mask extends StatelessWidget {
  const Mask({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).scaffoldBackgroundColor;
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                color.withAlpha(0),
                color,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
    );
  }
}

class SelectCircle extends StatelessWidget {
  const SelectCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: const Color(0xff00A3FF)),
        shape: BoxShape.circle,
      ),
    );
  }
}

class SnapNearestItemScrollPhysics extends ScrollPhysics {
  final double itemExtent;
  const SnapNearestItemScrollPhysics(this.itemExtent, {super.parent});

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SnapNearestItemScrollPhysics(itemExtent,
        parent: buildParent(ancestor));
  }

  double offset2index(double offset) {
    return offset / itemExtent;
  }

  double index2offset(double index) {
    return index * itemExtent;
  }

  double _getTargetPixels(
    ScrollMetrics position,
    Tolerance tolerance,
    double velocity,
  ) {
    double index = offset2index(position.pixels);
    if (velocity < -tolerance.velocity) {
      index -= 0.5;
    } else if (velocity > tolerance.velocity) {
      index += 0.5;
    }
    return index2offset(index.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if ((velocity < 0.0) || (velocity > 0.0)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = toleranceFor(position);
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return parent?.createBallisticSimulation(position, velocity);
  }

  @override
  bool get allowImplicitScrolling => false;
}
