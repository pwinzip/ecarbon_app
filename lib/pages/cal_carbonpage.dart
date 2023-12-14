import 'package:ecarbon/pages/tabbamboo.dart';
import 'package:ecarbon/pages/tabforest.dart';
import 'package:ecarbon/pages/tabrubber.dart';
import 'package:ecarbon/utils.dart';
import 'package:flutter/material.dart';

class CalCarbonPage extends StatefulWidget {
  const CalCarbonPage({super.key});

  @override
  State<CalCarbonPage> createState() => _CalCarbonPageState();
}

class _CalCarbonPageState extends State<CalCarbonPage>
    with
        AutomaticKeepAliveClientMixin<CalCarbonPage>,
        TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: createAppbar(context, isBack: true, leftPad: 4),
      body: SafeArea(
        child: Column(
          children: [
            DefaultTabController(
              length: 3,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "ไม้ยางพารา"),
                  Tab(text: "ไม้ป่าดิบชื้น"),
                  Tab(text: "ไม้ไผ่"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  RubberTab(),
                  ForestTab(),
                  BambooTab(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
