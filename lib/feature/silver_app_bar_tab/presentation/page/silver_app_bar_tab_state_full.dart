import 'package:flutter/material.dart';

class SilverAppBarTabStateFull extends StatefulWidget {
  const SilverAppBarTabStateFull({super.key});

  @override
  State<SilverAppBarTabStateFull> createState() => _SilverAppBarTabState();
}

class _SilverAppBarTabState extends State<SilverAppBarTabStateFull>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      color: Colors.greenAccent,
                      height: 400,
                    ),
                    Container(
                      height: 60,
                      width: double.infinity,
                      color: Colors.pink,
                      child: Center(
                        child: Text(
                          "BLACK PINK",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: _StickyTabBarDelegate(
                  child: Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.pink,
                      tabs: const [
                        Tab(text: "Music"),
                        Tab(text: "Videos"),
                        Tab(text: "Photos"),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // Tab 1
              ListView.builder(
                itemCount: 50,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Tab 1 - Item $index'),
                    leading: Icon(Icons.music_note),
                  );
                },
              ),
              // Tab 2
              ListView.builder(
                itemCount: 50,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Tab 2 - Item $index'),
                    leading: Icon(Icons.video_library),
                  );
                },
              ),
              // Tab 3
              ListView.builder(
                itemCount: 50,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Tab 3 - Item $index'),
                    leading: Icon(Icons.photo_library),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabBarDelegate({required this.child});

  @override
  double get minExtent => 48.0;

  @override
  double get maxExtent => 48.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}