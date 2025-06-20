// split_panel_example.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_prototype_bloc/feature/split_panel/presentation/page/split_Panel.dart';

import '../cubit/split_panel_cubit.dart';
import '../cubit/split_panel_state.dart';

class SplitPanelExample extends StatelessWidget {
  const SplitPanelExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplitPanel Example'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: SplitPanel(
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
                Text(
                  'Toggle right to expand this',
                  style: TextStyle(fontSize: 14, color: Colors.blue),
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
                Text(
                  'Toggle left to expand this',
                  style: TextStyle(fontSize: 14, color: Colors.green),
                ),
              ],
            ),
          ),
        ),
        showLeftToggleButton: false,
        backgroundColor: Colors.grey.shade100,
        cardColor: Colors.white,
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
              child: SplitPanel(
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
                  color: Colors.pink.shade50,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        color: Colors.pink.shade100,
                        child: const Text(
                          'Right Panel Settings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.color_lens),
                                title: const Text('Theme Settings'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {},
                              ),
                            ),
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.notifications),
                                title: const Text('Notifications'),
                                trailing: Switch(
                                  value: true,
                                  onChanged: (v) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                showLeftToggleButton: false,
                // ปิดปุ่มใน widget เพราะใช้ AppBar
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
