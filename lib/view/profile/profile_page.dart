import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kitchen/helps/image.dart';
import 'package:kitchen/models/lang.dart';
import 'package:kitchen/providers/auth_providers.dart';
import 'package:kitchen/providers/lang_providers.dart';
import 'package:kitchen/providers/order_providers.dart';
import 'package:kitchen/route/route.dart';
import 'package:kitchen/singletons/google_tools.dart';
import 'package:kitchen/singletons/shared_preferences.dart';
import 'package:kitchen/singletons/user_instance.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/widget/appbar.dart';
import 'package:kitchen/widget/detailmenu_sheet.dart';
import 'package:kitchen/widget/dialog/vp_pin_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  static AndroidDeviceInfo? _androidInfo;
  static PackageInfo? _packageInfo;
  static final ImagePicker _picker = ImagePicker();
  static File? _fileImage;
  static final DateFormat _dateFormat = DateFormat('dd/MM/yy');
  static bool _imageProfile = true;
  get provider => Provider.of<AuthProviders>(context, listen: false);
  static final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  getInfoDevice() async {
    _androidInfo = await deviceInfo.androidInfo;
    _packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  _camera() async {
    final _image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );

    Navigator.pop(context);
    if (_imageProfile) _saveImageProfile(_image);
    if (!_imageProfile) _sendKTP(_image);
  }

  _galley() async {
    final _image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    Navigator.pop(context);
    if (_imageProfile) _saveImageProfile(_image);
    if (!_imageProfile) _sendKTP(_image);
  }

  _pickImage(bool isImageProfile) {
    setState(() => _imageProfile = isImageProfile);
    final user = UserInstance.getInstance().user?.data;
    if (!_imageProfile && user?.status != 0) return;
    showModalBottomSheet(
      barrierColor: Colors.grey.withOpacity(0.2),
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 65.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  side: const BorderSide(color: ColorSty.primary),
                  borderRadius: BorderRadius.circular(30.0),
                )),
                onPressed: _galley,
                child: SizedBox(
                  width: 120,
                  height: 40.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Gallery", style: TypoSty.button),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                )),
                onPressed: _camera,
                child: SizedBox(
                  width: 120,
                  height: 40.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Camera", style: TypoSty.button),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _saveImageProfile(_image) async {
    if (_image != null) {
      _fileImage = await ImageCropper().cropImage(
          sourcePath: _image.path,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: ColorSty.white,
            toolbarWidgetColor: ColorSty.primary,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          iosUiSettings: const IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (_fileImage != null) {
        File compressedFile = await FlutterNativeImage.compressImage(
          _fileImage!.path,
          quality: 25,
        );
        _fileImage = compressedFile;

        String base64Image = base64Encode(compressedFile.readAsBytesSync());

        Provider.of<AuthProviders>(context, listen: false)
            .uploadProfileImage(base64Image);
        Provider.of<AuthProviders>(context, listen: false).getUser();
      }
      setState(() {});
    }
  }

  _updateTgl() async {
    final value = await showDialog(
      barrierColor: ColorSty.grey.withOpacity(0.2),
      context: context,
      builder: (_) => const DatePickerDialog(),
    );

    if (value != null) {
      provider.update(
          key: "tgl_lahir", value: _dateFormat.format((value as DateTime)));
      if (mounted) setState(() {});
    }
  }

  _updateTelepon(String value) {
    if (value.isEmpty) return;
    provider.update(key: "telepon", value: value);
    if (mounted) setState(() {});
  }

  _updateNama(String value) {
    if (value.isEmpty) return;
    provider.update(key: "nama", value: value);
    if (mounted) setState(() {});
  }

  _changePin(Lang lang) {
    showDialog(
      context: context,
      builder: (_) => VPinDialog(
        title: lang.profile.lm,
        onComplete: (value) {
          if (value.runtimeType != bool) return;
          if ((value as bool)) {
            showDialog(
              context: context,
              builder: (_) => VPinDialog(
                title: lang.profile.br,
                giveString: true,
                onComplete: (value) {
                  if (value.runtimeType != String) return;

                  provider.update(key: "pin", value: "$value");
                },
              ),
            );
          }
        },
      ),
    );
  }

  _sendKTP(_image) async {
    if (_image != null) {
      _fileImage = await ImageCropper().cropImage(
          sourcePath: _image.path,
          cropStyle: CropStyle.rectangle,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: ColorSty.white,
            toolbarWidgetColor: ColorSty.primary,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          iosUiSettings: const IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (_fileImage != null) {
        File compressedFile = await FlutterNativeImage.compressImage(
          _fileImage!.path,
          quality: 50,
        );
        _fileImage = compressedFile;

        String base64Image = base64Encode(compressedFile.readAsBytesSync());

        Provider.of<AuthProviders>(context, listen: false)
            .uploadKtp(base64Image);
      }
      setState(() {});
    }
  }

  _logout() {
    Navigator.pushReplacementNamed(context, "/");
    Preferences.getInstance().clear();
    GoogleLogin.getInstance().logout();
    UserInstance.getInstance().clear();
    Provider.of<OrderProviders>(context, listen: false).clear();
  }

  @override
  void initState() {
    getInfoDevice();
    super.initState();
  }

  void _onRefresh() async {
    var _duration = const Duration(seconds: 1);
    if (mounted) {
      await Provider.of<AuthProviders>(context, listen: false).getUser();

      Timer(_duration, () {});
    }
    _refreshController.refreshCompleted();
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
            profileTitle: lang.profile.title,
          ),
          body: AnimatedBuilder(
              animation: AuthProviders(),
              builder: (_, __) {
                final _user = Provider.of<AuthProviders>(context).user();
                return SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: Stack(
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
                                        if (_user?.foto == null)
                                          if (_fileImage != null)
                                            Image.file(_fileImage!)
                                          else
                                            SvgPicture.asset(
                                              "assert/image/icons/user-icon.svg",
                                            )
                                        else
                                          Image.network(
                                            "${_user?.foto}",
                                            errorBuilder: imageError,
                                            loadingBuilder: imageOnLoad,
                                          ),
                                        Positioned(
                                          bottom: -10,
                                          child: TextButton(
                                            onPressed: () => _pickImage(true),
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
                                const SizedBox(
                                    height: SpaceDims.sp8,
                                    width: double.infinity),
                                SizedBox(
                                  width: 280,
                                  child: TextButton(
                                    onPressed: () {
                                      if (_user?.status == 0) _pickImage(false);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (_user?.status == 2) ...[
                                          const Icon(
                                            Icons.check,
                                            color: ColorSty.primary,
                                            size: 18.0,
                                          ),
                                          const SizedBox(width: SpaceDims.sp4),
                                          Text(
                                            lang.profile.caption.status3,
                                            style: const TextStyle(
                                                color: ColorSty.primary),
                                          ),
                                        ],
                                        if (_user?.status == 1) ...[
                                          const Icon(
                                            Icons.schedule_send,
                                            color: ColorSty.primary,
                                            size: 18.0,
                                          ),
                                          const SizedBox(width: SpaceDims.sp4),
                                          Text(
                                            lang.profile.caption.status2,
                                            style: const TextStyle(
                                                color: ColorSty.primary),
                                          ),
                                        ],
                                        if (_user?.status == 0) ...[
                                          SvgPicture.asset(
                                              "assert/image/icons/id-icon.svg"),
                                          const SizedBox(width: SpaceDims.sp4),
                                          Text(
                                            lang.profile.caption.status1,
                                            style: const TextStyle(
                                                color: ColorSty.primary),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: SpaceDims.sp16),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: SpaceDims.sp32),
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
                                        suffix: _user?.nama ?? " ",
                                        onSubmit: _updateNama,
                                      ),
                                      TileListProfile(
                                        title: lang.profile.tgl,
                                        suffix: _user?.tglLahir ?? ' ',
                                        onPressed: _updateTgl,
                                      ),
                                      TileListProfile(
                                        title: lang.profile.tlp,
                                        suffix: _user?.telepon ?? ' ',
                                        onSubmit: _updateTelepon,
                                      ),
                                      TileListProfile(
                                        title: 'Email',
                                        suffix: _user?.email ?? ' ',
                                      ),
                                      TileListProfile(
                                        title: '${lang.profile.ub} PIN',
                                        suffix: '*********',
                                        onPressed: () => _changePin(lang),
                                      ),
                                      AnimatedBuilder(
                                        animation: LangProviders(),
                                        builder: (context, snapshot) {
                                          bool _isIndo =
                                              Provider.of<LangProviders>(
                                                      context)
                                                  .isIndo;
                                          return TileListProfile(
                                            title: lang.profile.bhs,
                                            suffix: _isIndo
                                                ? 'Indonesia'
                                                : 'English',
                                            onPressed: () =>
                                                showModalBottomSheet(
                                              barrierColor: ColorSty.grey
                                                  .withOpacity(0.2),
                                              elevation: 5,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(30.0),
                                                  topRight:
                                                      Radius.circular(30.0),
                                                ),
                                              ),
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
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(
                                horizontal: SpaceDims.sp24,
                                vertical: SpaceDims.sp12,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: SpaceDims.sp8,
                              ),
                              decoration: BoxDecoration(
                                color: ColorSty.grey60,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Column(
                                children: [
                                  TileListProfile(
                                    top: false,
                                    enable: false,
                                    btn: true,
                                    title: lang.profile.penilaian.toString(),
                                    suffix: lang.profile.nilai_sekarang,
                                    onPressed: () {
                                      // print('navigate daftar penilaian');
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: SpaceDims.sp22),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: SpaceDims.sp32),
                                  child: Text(
                                    lang.profile.subtitle2,
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
                                        enable: false,
                                        title:
                                            Provider.of<LangProviders>(context)
                                                .lang
                                                .profile
                                                .namaPerangkat,
                                        suffix: _androidInfo?.model ?? "",
                                      ),
                                      TileListProfile(
                                        enable: false,
                                        title:
                                            Provider.of<LangProviders>(context)
                                                .lang
                                                .profile
                                                .versiAplikasi,
                                        suffix: '1.0',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: SpaceDims.sp22),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: _logout,
                                  child: SizedBox(
                                    width: 204,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text("Log Out",
                                          style: TypoSty.button),
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
                            const SizedBox(height: 150),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        );
      },
    );
  }
}

class TileListProfile extends StatefulWidget {
  final bool? top, bottom, enable;
  final String title, suffix;
  final Function()? onPressed;
  final Function(String value)? onSubmit;
  final bool? btn;

  const TileListProfile(
      {Key? key,
      this.top = true,
      this.bottom = false,
      required this.title,
      required this.suffix,
      this.onPressed,
      this.enable = true,
      this.onSubmit,
      this.btn})
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
            onPressed: widget.onPressed ??
                () => showModalBottomSheet(
                      isScrollControlled: true,
                      barrierColor: ColorSty.grey.withOpacity(0.2),
                      elevation: 5,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      context: context,
                      builder: (BuildContext context) => BottomSheetDetailMenu(
                        title: widget.title,
                        content: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                maxLength: 100,
                                enabled: widget.enable,
                                controller: _editingController,
                                decoration: InputDecoration(
                                  hintText: widget.suffix,
                                  contentPadding: const EdgeInsets.all(0),
                                ),
                              ),
                            ),
                            if (widget.enable!)
                              ElevatedButton(
                                onPressed: () {
                                  if (widget.onSubmit != null) {
                                    Navigator.pop(context);
                                    widget.onSubmit!(_editingController.text);
                                  }
                                },
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
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.btn == true)
                        ElevatedButton(
                            onPressed: () {
                              Navigate.toDaftarPenilaian(context);
                            },
                            child: Text('${widget.suffix}')),
                      if (widget.btn == null)
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              widget.suffix,
                              overflow: TextOverflow.ellipsis,
                              style: TypoSty.caption.copyWith(fontSize: 14.0),
                            ),
                          ),
                        ),
                      if (widget.btn == null)
                        const Icon(
                          Icons.edit,
                          color: ColorSty.grey,
                          size: 16.0,
                        )
                    ],
                  ),
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

class DatePickerDialog extends StatelessWidget {
  const DatePickerDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: () {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(SpaceDims.sp12),
          child: SizedBox(
            height: 0.5.sh,
            width: double.infinity,
            child: SfDateRangePicker(
              onSubmit: (value) {
                if (value != null) {
                  Navigator.pop(context, (value as DateTime));
                }
              },
              onCancel: () => Navigator.pop(context),
              showActionButtons: true,
              selectionMode: DateRangePickerSelectionMode.single,
              extendableRangeSelectionDirection:
                  ExtendableRangeSelectionDirection.both,
              view: DateRangePickerView.month,
            ),
          ),
        ),
      );
    });
  }
}
