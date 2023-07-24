import 'package:flutter/material.dart';

import '../utils/colors.dart';

class CustomSliverAppBar extends StatelessWidget {
  final double? expandedHeight;
  final double? elevation;
  final bool? implyLeading;
  final bool? floating;
  final bool? pinned;
  final Widget? flexibleWidget;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? shadowColor;
  const CustomSliverAppBar(
      {super.key,
      this.expandedHeight,
      this.implyLeading,
      this.floating,
      this.pinned,
      this.elevation,
      this.flexibleWidget,
      this.actions,
      this.backgroundColor,
      this.shadowColor});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: implyLeading ?? true,
      expandedHeight: expandedHeight,
      floating: floating ?? true,
      backgroundColor: backgroundColor,
      shadowColor: shadowColor,
      pinned: pinned ?? true,
      elevation: elevation,
      flexibleSpace: flexibleWidget,
      actions: actions,
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final bool? implyLeading;
  final bool? centerTitle;
  final double? elevation;
  final Widget? title;
  final Widget? leading;
  final Color? color;
  final List<Widget>? actions;
  const CustomAppBar(
      {super.key,
      this.implyLeading,
      this.title,
      this.color,
      this.leading,
      this.elevation,
      this.centerTitle,
      this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: implyLeading ?? true,
      title: title,
      scrolledUnderElevation: elevation,
      leading: leading,
      backgroundColor:
          color?.withOpacity(0.3) ?? secondaryColor.withOpacity(0.3),
      elevation: elevation,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }
}
