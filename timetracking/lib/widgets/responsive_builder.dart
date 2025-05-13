import 'package:flutter/material.dart';

enum DeviceScreenType {
  mobile,
  tablet,
  desktop,
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    DeviceScreenType deviceType,
    Size size,
  ) builder;

  const ResponsiveBuilder({Key? key, required this.builder}) : super(key: key);

  DeviceScreenType _getDeviceType(MediaQueryData mediaQuery) {
    final width = mediaQuery.size.width;

    if (width < 600) {
      return DeviceScreenType.mobile;
    } else if (width < 1200) {
      return DeviceScreenType.tablet;
    } else {
      return DeviceScreenType.desktop;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceType = _getDeviceType(mediaQuery);

    return builder(context, deviceType, mediaQuery.size);
  }
}
