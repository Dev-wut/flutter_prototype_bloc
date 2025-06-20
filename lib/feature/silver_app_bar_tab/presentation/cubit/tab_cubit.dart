import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tab_state.dart';

class TabCubit extends Cubit<TabState> {
  late TabController _tabController;
  late TickerProvider _tickerProvider;

  TabCubit() : super(TabInitial());

  void initialize(TickerProvider tickerProvider) {
    _tickerProvider = tickerProvider;
    _tabController = TabController(length: 5, vsync: _tickerProvider);
    _tabController.addListener(_onTabChanged);
    emit(TabLoaded(
      currentIndex: 0,
      loadedTabs: {0: true}, // Load first tab by default
    ));
  }

  TabController get tabController => _tabController;

  void _onTabChanged() {
    if (state is TabLoaded) {
      final currentState = state as TabLoaded;
      final newIndex = _tabController.index;

      // Load current tab if not loaded
      final updatedLoadedTabs = Map<int, bool>.from(currentState.loadedTabs);
      updatedLoadedTabs[newIndex] = true;

      emit(currentState.copyWith(
        currentIndex: newIndex,
        loadedTabs: updatedLoadedTabs,
      ));
    }
  }

  void changeTab(int index) {
    _tabController.animateTo(index);
  }

  void disposePdfTab(int tabIndex) {
    if (state is TabLoaded) {
      final currentState = state as TabLoaded;
      final updatedLoadedTabs = Map<int, bool>.from(currentState.loadedTabs);
      updatedLoadedTabs[tabIndex] = false;

      emit(currentState.copyWith(loadedTabs: updatedLoadedTabs));
    }
  }

  @override
  Future<void> close() {
    _tabController.dispose();
    return super.close();
  }
}