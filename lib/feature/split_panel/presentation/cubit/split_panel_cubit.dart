// split_panel_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'split_panel_state.dart';

class SplitPanelCubit extends Cubit<SplitPanelState> {
  SplitPanelCubit({
    bool initialLeftPanelOpen = true,
    bool initialRightPanelOpen = true,
    required double leftPanelWidth,
    required double rightPanelWidth,
  }) : super(SplitPanelState(
    isLeftPanelOpen: initialLeftPanelOpen,
    isRightPanelOpen: initialRightPanelOpen,
    leftPanelWidth: leftPanelWidth,
    rightPanelWidth: rightPanelWidth,
  ));

  // Left Panel Controls
  void toggleLeftPanel() {
    emit(state.copyWith(isLeftPanelOpen: !state.isLeftPanelOpen));
  }

  void openLeftPanel() {
    emit(state.copyWith(isLeftPanelOpen: true));
  }

  void closeLeftPanel() {
    emit(state.copyWith(isLeftPanelOpen: false));
  }

  // Right Panel Controls
  void toggleRightPanel() {
    emit(state.copyWith(isRightPanelOpen: !state.isRightPanelOpen));
  }

  void openRightPanel() {
    emit(state.copyWith(isRightPanelOpen: true));
  }

  void closeRightPanel() {
    emit(state.copyWith(isRightPanelOpen: false));
  }

  // Both Panels Controls
  void toggleBothPanels() {
    emit(state.copyWith(
      isLeftPanelOpen: !state.isLeftPanelOpen,
      isRightPanelOpen: !state.isRightPanelOpen,
    ));
  }

  void openBothPanels() {
    emit(state.copyWith(
      isLeftPanelOpen: true,
      isRightPanelOpen: true,
    ));
  }

  void closeBothPanels() {
    emit(state.copyWith(
      isLeftPanelOpen: false,
      isRightPanelOpen: false,
    ));
  }
}