// split_panel.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/split_panel_cubit.dart';
import '../cubit/split_panel_state.dart';

class SplitPanel extends StatelessWidget {
  final Widget? leftContent;
  final Widget? rightContent;
  final bool? initialLeftPanelOpen;
  final bool? initialRightPanelOpen;
  final double? leftPanelWidth;
  final double? rightPanelWidth;
  final bool showLeftToggleButton;
  final bool showRightToggleButton;
  final Color? cardColor;
  final Color? backgroundColor;
  final Color? buttonColor;
  final Color? buttonIconColor;
  final double? panelHeight;

  const SplitPanel({
    super.key,
    this.leftContent,
    this.rightContent,
    this.initialLeftPanelOpen = true,
    this.initialRightPanelOpen = true,
    this.leftPanelWidth,
    this.rightPanelWidth,
    this.showLeftToggleButton = true,
    this.showRightToggleButton = true,
    this.cardColor,
    this.backgroundColor,
    this.buttonColor,
    this.buttonIconColor,
    this.panelHeight,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplitPanelCubit(
        initialLeftPanelOpen: initialLeftPanelOpen ?? true,
        initialRightPanelOpen: initialRightPanelOpen ?? true,
        leftPanelWidth: leftPanelWidth ?? 0.0,
        rightPanelWidth: rightPanelWidth ?? 0.0,
      ),
      child: _SplitPanelView(
        leftContent: leftContent,
        rightContent: rightContent,
        showLeftToggleButton: showLeftToggleButton,
        showRightToggleButton: showRightToggleButton,
        cardColor: cardColor,
        backgroundColor: backgroundColor,
        buttonColor: buttonColor,
        buttonIconColor: buttonIconColor,
        panelHeight: panelHeight,
      ),
    );
  }
}

class _SplitPanelView extends StatelessWidget {
  final Widget? leftContent;
  final Widget? rightContent;
  final bool showLeftToggleButton;
  final bool showRightToggleButton;
  final Color? cardColor;
  final Color? backgroundColor;
  final Color? buttonColor;
  final Color? buttonIconColor;
  final double? panelHeight;

  const _SplitPanelView({
    this.leftContent,
    this.rightContent,
    required this.showLeftToggleButton,
    required this.showRightToggleButton,
    this.cardColor,
    this.backgroundColor,
    this.buttonColor,
    this.buttonIconColor,
    this.panelHeight,
  });

  // Optimized: Extract constants
  static const Duration _animationDuration = Duration(milliseconds: 500);
  static const Curve _animationCurve = Curves.easeInOut;
  static const EdgeInsets _leftPadding = EdgeInsets.only(left: 8.0, right: 0.0, top: 4.0, bottom: 4.0);
  static const EdgeInsets _rightPadding = EdgeInsets.only(left: 0.0, right: 8.0, top: 4.0, bottom: 4.0);
  static const EdgeInsets _fullPadding = EdgeInsets.all(8.0);

  // Optimized: Create reusable panel builder
  Widget _buildPanel({
    required Widget? content,
    required EdgeInsets padding,
    double? width,
    bool isExpanded = false,
  }) {
    final panel = Container(
      width: width,
      height: panelHeight ?? double.infinity,
      padding: padding,
      child: Card(
        clipBehavior: Clip.hardEdge,
        color: cardColor ?? Colors.white,
        child: content,
      ),
    );

    return isExpanded ? Expanded(child: panel) : panel;
  }

  // Optimized: Simplified panel layout logic
  List<Widget> _buildPanelLayout(SplitPanelState state) {
    final bothClosed = !state.isLeftPanelOpen && !state.isRightPanelOpen;
    final bothOpen = state.isLeftPanelOpen && state.isRightPanelOpen;
    final leftOnlyOpen = state.isLeftPanelOpen && !state.isRightPanelOpen;
    final rightOnlyOpen = !state.isLeftPanelOpen && state.isRightPanelOpen;

    // Case 1: Both panels closed
    if (bothClosed) {
      return [
        _buildPanel(
          content: const SizedBox.shrink(),
          padding: _fullPadding,
          isExpanded: true,
        ),
      ];
    }

    // Case 2: Both panels open
    if (bothOpen) {
      return [
        _buildPanel(
          content: leftContent,
          padding: _leftPadding,
          width: state.leftPanelWidth > 0 ? state.leftPanelWidth : null,
          isExpanded: state.leftPanelWidth <= 0,
        ),
        _buildPanel(
          content: rightContent,
          padding: _rightPadding,
          width: state.rightPanelWidth > 0 ? state.rightPanelWidth : null,
          isExpanded: state.rightPanelWidth <= 0,
        ),
      ];
    }

    // Case 3: Left panel only
    if (leftOnlyOpen) {
      return [
        _buildPanel(
          content: leftContent,
          padding: _fullPadding,
          isExpanded: true,
        ),
      ];
    }

    // Case 4: Right panel only
    if (rightOnlyOpen) {
      return [
        _buildPanel(
          content: rightContent,
          padding: _fullPadding,
          isExpanded: true,
        ),
      ];
    }

    return [];
  }

  // Optimized: Extract toggle button builder
  Widget _buildToggleButton({
    required String heroTag,
    required VoidCallback onPressed,
    required IconData icon,
    required double left,
    required double right,
    required BuildContext context,
  }) {
    return Positioned(
      left: left == 0 ? null : left,
      right: right == 0 ? null : right,
      top: 22.0,
      child: SizedBox(
        width: 35.0,
        height: 40.0,
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),
          child: FloatingActionButton(
            heroTag: heroTag,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              side: BorderSide(color: Colors.grey, width: 1),
            ),
            onPressed: onPressed,
            backgroundColor: buttonColor ?? Colors.white,
            child: Icon(
              icon,
              color: buttonIconColor ?? Colors.black,
              size: 20.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplitPanelCubit, SplitPanelState>(
      builder: (context, state) {
        return Container(
          color: backgroundColor,
          child: Stack(
            children: [
              // Main panel layout with animation
              // AnimatedSwitcher(
              //   duration: _animationDuration,
                // transitionBuilder: (Widget child, Animation<double> animation) {
                //   return SlideTransition(
                //     position: Tween<Offset>(
                //       begin: const Offset(0.1, 0.0),
                //       end: Offset.zero,
                //     ).animate(CurvedAnimation(
                //       parent: animation,
                //       curve: _animationCurve,
                //     )),
                //     child: FadeTransition(
                //       opacity: animation,
                //       child: child,
                //     ),
                //   );
                // },
                // child:
                Row(
                  key: ValueKey('${state.isLeftPanelOpen}-${state.isRightPanelOpen}'),
                  children: _buildPanelLayout(state),
                ),
              // ),

              // Toggle buttons
              if (showLeftToggleButton)
                _buildToggleButton(
                  context: context,
                  heroTag: "leftPanelToggle",
                  onPressed: () => context.read<SplitPanelCubit>().toggleLeftPanel(),
                  icon: state.isLeftPanelOpen
                      ? Icons.arrow_back_ios_sharp
                      : Icons.arrow_forward_ios_sharp,
                  left: 15.0,
                  right: 0,
                ),

              if (showRightToggleButton)
                _buildToggleButton(
                  context: context,
                  heroTag: "rightPanelToggle",
                  onPressed: () => context.read<SplitPanelCubit>().toggleRightPanel(),
                  icon: state.isRightPanelOpen
                      ? Icons.arrow_forward_ios_sharp
                      : Icons.arrow_back_ios_sharp,
                  left: 0,
                  right: 15.0,
                ),
            ],
          ),
        );
      },
    );
  }
}