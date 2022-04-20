import 'package:flutter/material.dart';
import 'package:kitchen/models/lang.dart';
import 'package:kitchen/providers/lang_providers.dart';
import 'package:kitchen/providers/order_providers.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/icons_cs_icons.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/view/orders/history_page.dart';
import 'package:kitchen/view/orders/orders_page.dart';
import 'package:kitchen/view/profile/profile_page.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _bottomNavBarSelectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: ColorSty.white,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: AnimatedBuilder(
          animation: LangProviders(),
          builder: (context, snapshot) {
            Lang _lang = Provider.of<LangProviders>(context).lang;
            return BottomNavigationBar(
              elevation: 10,
              backgroundColor: ColorSty.black60,
              unselectedItemColor: ColorSty.white.withOpacity(0.8),
              selectedItemColor: ColorSty.white,
              selectedLabelStyle: TypoSty.button2,
              unselectedLabelStyle: TypoSty.button2.copyWith(fontWeight: FontWeight.normal),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(IconsCs.clock, size: 28.0),
                  label: _lang.bottomNav.nav1,
                ),
                BottomNavigationBarItem(
                  icon: Stack(children: [
                    const Padding(
                      padding: EdgeInsets.only(right: SpaceDims.sp4),
                      child: Icon(IconsCs.pesanan, size: 32.0),
                    ),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: AnimatedBuilder(
                        animation: OrderProviders(),
                        builder: (BuildContext context, Widget? child) {
                          int _orderOngoing = Provider.of<OrderProviders>(context).orderProgress.length;
                          // print(Provider.of<OrderProvider>(context).orderProgress.first);
                          if (_orderOngoing > 0) {
                            return Container(
                              height: 20,
                              width: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: ColorSty.primary,
                                borderRadius: BorderRadius.circular(100.0),
                                border: Border.all(color: ColorSty.white),
                              ),
                              child: Text(
                                "$_orderOngoing",
                                style: TypoSty.button.copyWith(
                                  color: ColorSty.white,
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    )
                  ]),
                  label: _lang.bottomNav.nav2,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(IconsCs.profil, size: 28.0),
                  label: _lang.bottomNav.nav3,
                ),
              ],
              currentIndex: _bottomNavBarSelectedIndex,
              onTap: _onItemTapped,
            );
          }
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: const [
          HistoryPage(),
          OrdersPage(),
          ProfilePage(),
        ],
      ),
      // floatingActionButton: AnimatedBuilder(
      //   animation: OrderProviders(),
      //   builder: (BuildContext context, Widget? child) {
      //     final _order = Provider.of<OrderProviders>(context).checkOrder.length;
      //     if (_order > 0) {
      //       return FloatingActionButton(
      //         backgroundColor: ColorSty.primary,
      //         onPressed: () {
      //           Navigate.toChekOut(context);
      //         },
      //         child: const Padding(
      //           padding: EdgeInsets.only(right: 3.0),
      //           child: Icon(IconsCs.shopingbag),
      //         ),
      //       );
      //     } else {
      //       return const SizedBox.shrink();
      //     }
      //   },
      // ),
    );
  }

  _onItemTapped(index) {
    if (index != _bottomNavBarSelectedIndex) {
      if (index != 3) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
        setState(() {
          _bottomNavBarSelectedIndex = index;
        });
      }
    }
  }
}
