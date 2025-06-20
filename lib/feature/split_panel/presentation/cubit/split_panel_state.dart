// split_panel_state.dart
class SplitPanelState {
  final bool isLeftPanelOpen;
  final bool isRightPanelOpen;
  final double leftPanelWidth;
  final double rightPanelWidth;

  const SplitPanelState({
    required this.isLeftPanelOpen,
    required this.isRightPanelOpen,
    required this.leftPanelWidth,
    required this.rightPanelWidth,
  });

  SplitPanelState copyWith({
    bool? isLeftPanelOpen,
    bool? isRightPanelOpen,
    double? leftPanelWidth,
    double? rightPanelWidth,
  }) {
    return SplitPanelState(
      isLeftPanelOpen: isLeftPanelOpen ?? this.isLeftPanelOpen,
      isRightPanelOpen: isRightPanelOpen ?? this.isRightPanelOpen,
      leftPanelWidth: leftPanelWidth ?? this.leftPanelWidth,
      rightPanelWidth: rightPanelWidth ?? this.rightPanelWidth,
    );
  }
}