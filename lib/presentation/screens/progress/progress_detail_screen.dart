import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProgressDetailScreen extends ConsumerWidget {
  const ProgressDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: const Text('Detailed Progress'),
      ),
      body: const Center(child: Text('Body measurements & detailed tracking (premium)')),
    );
  }
}
