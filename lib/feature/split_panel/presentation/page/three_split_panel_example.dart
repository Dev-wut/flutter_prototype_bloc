// three_split_panel_example.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/split_panel_cubit.dart';
import '../cubit/split_panel_state.dart';
import 'three_split_panel.dart';

class ThreeSplitPanelExample extends StatelessWidget {
  const ThreeSplitPanelExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplitPanel Example'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: ThreeSplitPanel(
        leftContent: Container(
          color: Colors.blue.shade50,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu, size: 48, color: Colors.blue),
                SizedBox(height: 16),
                Text(
                  'Left Panel',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
        centerContent: Container(
          color: Colors.grey.shade50,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.dashboard, size: 72, color: Colors.grey),
                SizedBox(height: 24),
                Text(
                  'Main Content Area',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Use the toggle buttons to show/hide panels',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        rightContent: Container(
          color: Colors.green.shade50,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings, size: 48, color: Colors.green),
                SizedBox(height: 16),
                Text(
                  'Right Panel',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
        initialLeftPanelOpen: true,
        initialRightPanelOpen: true,
        leftPanelWidth: 300,
        rightPanelWidth: 350,
        showLeftToggleButton: true,
        showRightToggleButton: true,
        cardColor: Colors.white,
        backgroundColor: Colors.grey.shade100,
        buttonColor: Colors.white,
        buttonIconColor: Colors.black87,
      ),
    );
  }
}

// ตัวอย่างการใช้งานแบบ External BlocProvider
class SplitPanelWithExternalCubit extends StatelessWidget {
  const SplitPanelWithExternalCubit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplitPanelCubit(
        initialLeftPanelOpen: false,
        initialRightPanelOpen: true,
        leftPanelWidth: 400,
        rightPanelWidth: 300,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SplitPanel with External Cubit'),
          backgroundColor: Colors.purple.shade100,
          actions: [
            BlocBuilder<SplitPanelCubit, SplitPanelState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    context.read<SplitPanelCubit>().toggleLeftPanel();
                  },
                  icon: Icon(
                    state.isLeftPanelOpen
                        ? Icons.close_fullscreen
                        : Icons.open_in_full,
                  ),
                  tooltip: 'Toggle Left Panel',
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Control Panel
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Colors.purple.shade50,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12.0,
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<SplitPanelCubit>().openLeftPanel();
                      },
                      child: const Text('Open Left'),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<SplitPanelCubit>().closeLeftPanel();
                      },
                      child: const Text('Close Left'),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<SplitPanelCubit>().toggleLeftPanel();
                      },
                      child: const Text('Toggle Left'),
                    ),
                  ),
                ],
              ),
            ),

            // SplitPanel
            Expanded(
              child: ThreeSplitPanel(
                leftContent: Container(
                  color: Colors.orange.shade50,
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Text('${index + 1}'),
                        ),
                        title: Text('Left Item ${index + 1}'),
                        subtitle: Text('Subtitle for item ${index + 1}'),
                      );
                    },
                  ),
                ),
                rightContent: Container(
                  color: Colors.white,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.dashboard_customize, size: 96, color: Colors.purple),
                        SizedBox(height: 24),
                        Text(
                          'Main Content Area',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        Text(
                          'Control left panel from AppBar or buttons above',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                showLeftToggleButton: false, // ปิดปุ่มใน widget เพราะใช้ AppBar
                showRightToggleButton: false,
                cardColor: Colors.white,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}