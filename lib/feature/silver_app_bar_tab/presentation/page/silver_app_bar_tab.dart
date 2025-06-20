// silver_app_bar_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/tab_cubit.dart';
import '../widgets/pdf_tab.dart';
import '../widgets/regular_tab.dart';
import '../widgets/sticky_tab_bar_delegate.dart';

class SilverAppBarTab extends StatelessWidget {
  const SilverAppBarTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider(
          create: (context) => TabCubit(),
          child: const _SilverAppBarTabView(),
        ),
      ),
    );
  }
}

class _SilverAppBarTabView extends StatefulWidget {
  const _SilverAppBarTabView();

  @override
  State<_SilverAppBarTabView> createState() => _SilverAppBarTabViewState();
}

class _SilverAppBarTabViewState extends State<_SilverAppBarTabView>
    with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    // Initialize TabCubit with TickerProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TabCubit>().initialize(this);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabCubit, TabState>(
      builder: (context, state) {
        if (state is! TabLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final cubit = context.read<TabCubit>();

        return Scaffold(
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
                        child: const Center(
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
                  delegate: StickyTabBarDelegate(
                    child: Container(
                      color: Colors.white,
                      child: TabBar(
                        controller: cubit.tabController,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.pink,
                        tabAlignment: TabAlignment.fill,
                        tabs: const [
                          Tab(text: "Music"),
                          Tab(text: "Videos"),
                          Tab(text: "Photos"),
                          Tab(text: "PDF Docs"),
                          Tab(text: "Reports"),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: cubit.tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Tab 1 - Music
                RegularTab(
                  key: const PageStorageKey("music"),
                  title: "Music",
                  icon: Icons.music_note,
                  isLoaded: state.loadedTabs[0] ?? false,
                ),
                // Tab 2 - Videos
                RegularTab(
                  key: const PageStorageKey("videos"),
                  title: "Videos",
                  icon: Icons.video_library,
                  isLoaded: state.loadedTabs[1] ?? false,
                ),
                // Tab 3 - Photos
                RegularTab(
                  key: const PageStorageKey("photos"),
                  title: "Photos",
                  icon: Icons.photo_library,
                  isLoaded: state.loadedTabs[2] ?? false,
                ),
                // Tab 4 - PDF Docs (5 PDFs with checkboxes)
                PdfTab(
                  key: const PageStorageKey("pdf_docs"),
                  tabIndex: 3,
                  title: "PDF Documents",
                  isLoaded: state.loadedTabs[3] ?? false,
                ),
                // Tab 5 - Reports (5 PDFs with checkboxes)
                PdfTab(
                  key: const PageStorageKey("reports"),
                  tabIndex: 4,
                  title: "PDF Reports",
                  isLoaded: state.loadedTabs[4] ?? false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}