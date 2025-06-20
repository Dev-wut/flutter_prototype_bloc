import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/route_config.dart';
import '../../shared/widgets/custom_padding.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final featureList = <String, String>{
      AppRoutes.threeSplitPanel.name : "ThreeSplitPanel Original",
      AppRoutes.threeSplitPanelExample.name : "ThreeSplitPanel Example",
      AppRoutes.splitPanel.name : "SplitPanel Original",
      AppRoutes.splitPanelExample.name : "SplitPanel Example",
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Prototype'),
      ),
      body: Column(
        children: [
          Text(
            'Welcome, Flutter Prototype With Bloc!',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: CustomPadding(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: featureList.length,
                  itemBuilder: (context, index) {
                    final entry = featureList.entries.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          context.pushNamed(entry.key);
                        },
                        child: Text(entry.value),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}