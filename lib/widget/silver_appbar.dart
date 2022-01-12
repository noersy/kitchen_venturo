import 'package:flutter/material.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/spacing.dart';

class SilverAppBar extends StatelessWidget {
  final Widget body, title;
  final bool? back, notScrolled, tabs;
  final List<Widget>? actions;
  final bool pinned, floating;

  const SilverAppBar({
    Key? key,
    required this.title,
    required this.body,
    required this.pinned,
    required this.floating,
    this.actions,
    this.back, this.notScrolled, this.tabs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        body: body,
        headerSliverBuilder: (BuildContext context, _) {
          return <Widget>[
            SliverAppBar(
              elevation: 4,
              actions: actions,
              primary: false,
              leading: back != null ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              ) : null,
              backgroundColor: ColorSty.white,
              iconTheme: const IconThemeData(color: ColorSty.primary),
              title: tabs ?? false ? title : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  title,
                  const SizedBox(width: SpaceDims.sp32),
                  const SizedBox(width: SpaceDims.sp24),
                ],
              ),
              pinned: pinned,
              floating: floating,
              forceElevated: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
          ];
        },
      ),
    );
  }
}
class MainSilverAppBar extends StatelessWidget {
  final Widget body, title;
  final bool? back;
  final bool? isExpand;
  final List<Widget>? actions;
  final bool pinned, floating;

  const MainSilverAppBar({
    Key? key,
    required this.title,
    required this.body,
    required this.pinned,
    required this.floating,
    this.actions,
    this.back, this.isExpand = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        body: body,
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 4,
              actions: actions,
              primary: false,
              leading: back != null ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              ) : null,
              backgroundColor: ColorSty.white,
              iconTheme: const IconThemeData(color: ColorSty.primary),
              title: isExpand! ? Align(alignment : Alignment.center, child: title) : title,
              pinned: pinned,
              floating: floating,
              forceElevated: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
          ];
        },
      ),
    );
  }
}
