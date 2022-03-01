import 'package:flutter/material.dart';
import 'package:kitchen/singletons/check_connectivity.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';

class OfflinePage extends StatelessWidget {
  final String title;
  const OfflinePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 100,
            child: Image.asset("assert/image/javacode_logo.png"),
          ),
          Image.asset("assert/image/bg_login.png"),
          Positioned(
            bottom: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.signal_wifi_off,
                  color: Colors.grey,
                  size: 52.0,
                ),
                const SizedBox(height: SpaceDims.sp24),
                Text(
                  title,
                  style: TypoSty.title.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 200.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    ConnectionStatus.getInstance().checkConnection();
                  },
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      "Kembali",
                      style: TypoSty.button,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
