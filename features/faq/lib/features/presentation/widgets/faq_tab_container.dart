import 'package:flutter/material.dart';
// ignore_for_file: must_be_immutable
class FAQTabContainerPage extends StatefulWidget {
  List<String?> tabTitleList;
  TabController tabviewController;

  FAQTabContainerPage(this.tabTitleList, this.tabviewController, {super.key});

  @override
  FAQTabContainerPageState createState() => FAQTabContainerPageState();
}

class FAQTabContainerPageState extends State<FAQTabContainerPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TabBar(
        controller: widget.tabviewController,
        labelPadding: EdgeInsets.zero,
        labelColor: Theme.of(context).highlightColor,
        labelStyle: Theme.of(context).textTheme.titleSmall,
        unselectedLabelColor: Theme.of(context).primaryColor,
        unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
        indicatorColor: Theme.of(context).highlightColor,
        tabs: widget.tabTitleList.map((e) => Tab(text: e)).toList(),
      ),
    );
  }
}
