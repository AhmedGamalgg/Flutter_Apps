import 'package:flutter/material.dart';

class CenteredSliverChild extends StatelessWidget {
  final Widget? child;
  const CenteredSliverChild({
    super.key,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5, child: Center(child: child,)));
  }
}
