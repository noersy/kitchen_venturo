import 'package:flutter/material.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/view/orders/history_page.dart';
import 'package:kitchen/view/orders/orders_page.dart';

class PesananPage extends StatefulWidget {
  const PesananPage({Key? key}) : super(key: key);

  @override
  _PesananPageState createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0)),
        ),
        backgroundColor: ColorSty.white,
        title: TabBar(
          controller: _tabController,
          indicatorPadding: const EdgeInsets.symmetric(
            horizontal: 50.0,
            vertical: 8.0,
          ),
          labelPadding: const EdgeInsets.all(0),
          labelStyle: TypoSty.title.copyWith(fontSize: 16),
          indicatorColor: ColorSty.primary,
          unselectedLabelColor: ColorSty.black,
          labelColor: ColorSty.primary,
          tabs: const [
            Tab(child: Text("Sedang Berjalan")),
            Tab(child: Text("Riwayat")),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [OrdersPage(), HistoryPage()],
      ),
    );
  }
}
