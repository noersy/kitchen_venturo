import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitchen/providers/lang_providers.dart';
import 'package:kitchen/providers/order_providers.dart';
import 'package:kitchen/singletons/google_tools.dart';
import 'package:kitchen/singletons/shared_preferences.dart';
import 'package:kitchen/singletons/user_instance.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/widget/appbar.dart';
import 'package:kitchen/widget/detailmenu_sheet.dart';
import 'package:kitchen/widget/vp_pin_dialog.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  _logout() {
    Navigator.pushReplacementNamed(context, "/");
    Preferences.getInstance().clear();
    GoogleLogin.getInstance().logout();
    UserInstance.getInstance().clear();
    Provider.of<OrderProviders>(context, listen: false).clear();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: LangProviders(),
      builder: (context, snapshot) {
        final lang = Provider.of<LangProviders>(context).lang;

        return Scaffold(
          appBar: CostumeAppBar(
            title: "",
            dense: true,
            profileTitle: lang.profile.title,
          ),
          body: Stack(
            children: [
              Image.asset("assert/image/bg_findlocation.png"),
              SingleChildScrollView(
                primary: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: SpaceDims.sp22),
                        SizedBox(
                          height: 171,
                          width: 171,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(300.0),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                SvgPicture.asset(
                                  "assert/image/icons/user-icon.svg",
                                ),
                                Positioned(
                                  bottom: -10,
                                  child: TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      backgroundColor: ColorSty.primary,
                                      primary: ColorSty.white,
                                    ),
                                    child: SizedBox(
                                      width: 160,
                                      height: 25,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(lang.profile.ub),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: SpaceDims.sp22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check,
                              color: ColorSty.primary,
                              size: 18.0,
                            ),
                            const SizedBox(width: SpaceDims.sp2),
                            Text(
                              lang.profile.caption,
                              style: const TextStyle(color: ColorSty.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: SpaceDims.sp22),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: SpaceDims.sp32),
                          child: Text(
                            lang.profile.subtitle,
                            style: TypoSty.titlePrimary,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                            horizontal: SpaceDims.sp24,
                            vertical: SpaceDims.sp12,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: SpaceDims.sp22,
                          ),
                          decoration: BoxDecoration(
                            color: ColorSty.grey60,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Column(
                            children: [
                              TileListProfile(
                                top: false,
                                title: lang.profile.nam,
                                suffix: 'Fajar',
                              ),
                              TileListProfile(
                                title: lang.profile.tgl,
                                suffix: '01/03/1993',
                              ),
                              TileListProfile(
                                title: lang.profile.tlp,
                                suffix: '0822-4111-400',
                              ),
                              const TileListProfile(
                                title: 'Email',
                                suffix: 'lorem.ipsum@gmail.com',
                              ),
                              TileListProfile(
                                title: '${lang.profile.ub} PIN',
                                suffix: '*********',
                                onPreseed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => VPinDialog(
                                      title: lang.profile.lm,
                                      onComplete: (_) {
                                        showDialog(
                                          context: context,
                                          builder: (_) => VPinDialog(
                                            title: lang.profile.br,
                                            onComplete: (_) {},
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              AnimatedBuilder(
                                animation: LangProviders(),
                                builder: (context, snapshot) {
                                  bool _isIndo =
                                      Provider.of<LangProviders>(context)
                                          .isIndo;
                                  return TileListProfile(
                                    title: lang.profile.bhs,
                                    suffix: _isIndo ? 'Indonesia' : 'English',
                                    onPreseed: () => showModalBottomSheet(
                                      barrierColor:
                                          ColorSty.grey.withOpacity(0.2),
                                      elevation: 5,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30.0),
                                              topRight: Radius.circular(30.0))),
                                      context: context,
                                      builder: (BuildContext context) =>
                                          const ChangeLagSheet(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: SpaceDims.sp22),
                      ],
                    ),
                    // Container(
                    //   alignment: Alignment.center,
                    //   margin: const EdgeInsets.symmetric(
                    //     horizontal: SpaceDims.sp24,
                    //     vertical: SpaceDims.sp12,
                    //   ),
                    //   padding: const EdgeInsets.symmetric(
                    //     vertical: SpaceDims.sp22,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     color: ColorSty.grey60,
                    //     borderRadius: BorderRadius.circular(30.0),
                    //   ),
                    //   child: Column(
                    //     children: const [
                    //       TileListProfile(
                    //         top: false,
                    //         title: 'Penilaian',
                    //         button: true,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: SpaceDims.sp22),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: SpaceDims.sp32),
                    //       child: Text(lang.profile.subtitle2,
                    //           style: TypoSty.titlePrimary),
                    //     ),
                    //     Container(
                    //       alignment: Alignment.center,
                    //       margin: const EdgeInsets.symmetric(
                    //         horizontal: SpaceDims.sp24,
                    //         vertical: SpaceDims.sp12,
                    //       ),
                    //       padding: const EdgeInsets.symmetric(
                    //         vertical: SpaceDims.sp22,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: ColorSty.grey60,
                    //         borderRadius: BorderRadius.circular(30.0),
                    //       ),
                    //       child: Column(
                    //         children: const [
                    //           TileListProfile(
                    //             top: false,
                    //             title: 'Device Info',
                    //             suffix: 'Iphone 13',
                    //           ),
                    //           TileListProfile(
                    //             title: 'Version',
                    //             suffix: '1.3',
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     const SizedBox(height: SpaceDims.sp22),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _logout();
                          },
                          child: SizedBox(
                            width: 204,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Log Out", style: TypoSty.button),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class InfoSheet extends StatelessWidget {
  const InfoSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TileListProfile extends StatefulWidget {
  final bool? top, bottom;
  final String? suffix;
  final String title;
  final bool? button;
  final Function()? onPreseed;

  const TileListProfile(
      {Key? key,
      this.top = true,
      this.bottom = false,
      required this.title,
      this.suffix,
      this.onPreseed,
      this.button})
      : super(key: key);

  @override
  State<TileListProfile> createState() => _TileListProfileState();
}

class _TileListProfileState extends State<TileListProfile> {
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.top!
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: SpaceDims.sp18),
                width: double.infinity,
                color: ColorSty.grey,
                height: 2,
              )
            : const SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SpaceDims.sp18,
          ),
          child: TextButton(
            onPressed: widget.onPreseed ??
                () => showModalBottomSheet(
                      isScrollControlled: true,
                      barrierColor: ColorSty.grey.withOpacity(0.2),
                      elevation: 5,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0))),
                      context: context,
                      builder: (BuildContext context) => BottomSheetDetailMenu(
                        title: widget.title,
                        content: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                maxLength: 100,
                                controller: _editingController,
                                decoration: InputDecoration(
                                  hintText: widget.suffix,
                                  contentPadding: const EdgeInsets.all(0),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                                minimumSize: const Size(25.0, 25.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                              ),
                              child: const Icon(Icons.check, size: 26.0),
                            ),
                          ],
                        ),
                      ),
                    ),
            style: TextButton.styleFrom(
              primary: ColorSty.black,
              padding: const EdgeInsets.all(SpaceDims.sp8),
              minimumSize: const Size(0, 0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: TypoSty.captionSemiBold),
                Row(
                  children: [
                    if (widget.button != null)
                      ElevatedButton(
                          onPressed: () {},
                          child: const Text('Nilai sekarang'),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: ColorSty.primary))))),
                    if (widget.suffix != null)
                      Text(
                        widget.suffix.toString(),
                        style: TypoSty.caption.copyWith(fontSize: 14.0),
                      ),
                    // const Icon(
                    //   Icons.arrow_forward_ios,
                    //   color: ColorSty.grey,
                    //   size: 16.0,
                    // )
                  ],
                ),
              ],
            ),
          ),
        ),
        widget.bottom!
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: SpaceDims.sp18),
                width: double.infinity,
                color: ColorSty.grey,
                height: 2,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class ChangeLagSheet extends StatefulWidget {
  const ChangeLagSheet({Key? key}) : super(key: key);

  @override
  _ChangeLagSheetState createState() => _ChangeLagSheetState();
}

class _ChangeLagSheetState extends State<ChangeLagSheet> {
  @override
  Widget build(BuildContext context) {
    return BottomSheetDetailMenu(
      title: "Ganti Bahasa",
      heightGp: SpaceDims.sp12,
      content: AnimatedBuilder(
          animation: LangProviders(),
          builder: (context, snapshot) {
            bool _isIndo = Provider.of<LangProviders>(context).isIndo;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      Provider.of<LangProviders>(context, listen: false)
                          .changeLang(true),
                  style: ElevatedButton.styleFrom(
                    primary: _isIndo ? ColorSty.primary : ColorSty.white,
                    onPrimary: _isIndo ? ColorSty.white : ColorSty.black,
                    padding: const EdgeInsets.all(SpaceDims.sp8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Image.asset("assert/image/ind-flag.png"),
                        const SizedBox(width: SpaceDims.sp12),
                        Text("Indonesia", style: TypoSty.button)
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: SpaceDims.sp14),
                ElevatedButton(
                  onPressed: () =>
                      Provider.of<LangProviders>(context, listen: false)
                          .changeLang(false),
                  style: ElevatedButton.styleFrom(
                    primary: !_isIndo ? ColorSty.primary : ColorSty.white,
                    onPrimary: !_isIndo ? ColorSty.white : ColorSty.black,
                    padding: const EdgeInsets.all(SpaceDims.sp8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Image.asset("assert/image/eng-flag.png", height: 40),
                        const SizedBox(width: SpaceDims.sp12),
                        Text("English", style: TypoSty.button)
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
