// three_split_panel.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/split_panel_cubit.dart';
import '../cubit/split_panel_state.dart';

class ThreeSplitPanel extends StatelessWidget {
  final Widget? leftContent;
  final Widget? centerContent;
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

  const ThreeSplitPanel({
    super.key,
    this.leftContent,
    this.centerContent,
    this.rightContent,
    this.initialLeftPanelOpen,
    this.initialRightPanelOpen,
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
        leftPanelWidth: leftPanelWidth ?? 300.0,
        rightPanelWidth: rightPanelWidth ?? 300.0,
      ),
      child: _SplitPanelView(
        leftContent: leftContent,
        centerContent: centerContent,
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
  final Widget? centerContent;
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
    this.centerContent,
    this.rightContent,
    required this.showLeftToggleButton,
    required this.showRightToggleButton,
    this.cardColor,
    this.backgroundColor,
    this.buttonColor,
    this.buttonIconColor,
    this.panelHeight,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplitPanelCubit, SplitPanelState>(
      builder: (context, state) {
        return Container(
          color: backgroundColor,
          child: Stack(
            children: [
              Row(
                children: [
                  // ด้านซ้าย (Left Panel)
                  ClipRect(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      width: state.isLeftPanelOpen ? state.leftPanelWidth : 0,
                      height: panelHeight ?? double.infinity,
                      padding: EdgeInsets.only(
                        left: state.isLeftPanelOpen ? 8.0 : 0,
                        right: state.isLeftPanelOpen ? 2.0 : 0,
                        top: 4.0,
                        bottom: 4.0,
                      ),
                      child: state.isLeftPanelOpen
                          ? Card(
                        clipBehavior: Clip.hardEdge,
                        color: cardColor ?? Colors.white,
                        child: leftContent,
                      )
                          : const SizedBox.shrink(),
                    ),
                  ),

                  // ด้านกลาง (Center Content) - ขยายเต็มพื้นที่ที่เหลือ
                  Expanded(
                    child: Container(
                      height: panelHeight ?? double.infinity,
                      padding: EdgeInsets.only(
                        left: state.isLeftPanelOpen ? 2.0 : 8.0,
                        right: state.isRightPanelOpen ? 2.0 : 8.0,
                        top: 4.0,
                        bottom: 4.0,
                      ),
                      child: Card(
                        color: cardColor ?? Colors.white,
                        child: centerContent,
                      ),
                    ),
                  ),

                  // ด้านขวา (Right Panel)
                  ClipRect(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      width: state.isRightPanelOpen ? state.rightPanelWidth : 0,
                      height: panelHeight ?? double.infinity,
                      padding: EdgeInsets.only(
                        left: state.isRightPanelOpen ? 2.0 : 0,
                        right: state.isRightPanelOpen ? 8.0 : 0,
                        top: 4.0,
                        bottom: 4.0,
                      ),
                      child: state.isRightPanelOpen
                          ? Card(
                        clipBehavior: Clip.hardEdge,
                        color: cardColor ?? Colors.white,
                        child: rightContent,
                      )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),

              // ปุ่มเปิด-ปิด Left Panel
              if (showLeftToggleButton)
                Positioned(
                  left: 15.0,
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
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          side: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        onPressed: () {
                          context.read<SplitPanelCubit>().toggleLeftPanel();
                        },
                        backgroundColor: buttonColor ?? Colors.white,
                        child: Icon(
                          state.isLeftPanelOpen
                              ? Icons.arrow_back_ios_sharp
                              : Icons.arrow_forward_ios_sharp,
                          color: buttonIconColor ?? Colors.black,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),

              // ปุ่มเปิด-ปิด Right Panel
              if (showRightToggleButton)
                Positioned(
                  right: 15.0,
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
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          side: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        onPressed: () {
                          context.read<SplitPanelCubit>().toggleRightPanel();
                        },
                        backgroundColor: buttonColor ?? Colors.white,
                        child: Icon(
                          state.isRightPanelOpen
                              ? Icons.arrow_forward_ios_sharp
                              : Icons.arrow_back_ios_sharp,
                          color: buttonIconColor ?? Colors.black,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}