part of 'tab_cubit.dart';

// tab_state.dart
abstract class TabState {}

class TabInitial extends TabState {}

class TabLoaded extends TabState {
  final int currentIndex;
  final Map<int, bool> loadedTabs;

  TabLoaded({
    required this.currentIndex,
    required this.loadedTabs,
  });

  TabLoaded copyWith({
    int? currentIndex,
    Map<int, bool>? loadedTabs,
  }) {
    return TabLoaded(
      currentIndex: currentIndex ?? this.currentIndex,
      loadedTabs: loadedTabs ?? this.loadedTabs,
    );
  }
}