// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_dhobi_dashboard/auth/auth_service.dart';
import 'package:smart_dhobi_dashboard/presentation/screen/signin_screen.dart';
import 'package:smart_dhobi_dashboard/presentation/widgets/loader_dialog.dart';
import '../../providers.dart';
import '../destination/batches.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AuthService authService = ref.watch(authServiceProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          showLoaderDialog(context);
          ref.watch(batchDatabaseProvider).createBatch(
                await authService.account.then((value) => value!.$id),
              );
          ref.refresh(batchDatabaseProvider);
          Navigator.pop(context);
        },
        label: const Text("Create a Batch"),
        icon: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Smart Dhobi Dashboard"),
        actions: [
          IconButton(
              onPressed: () {
                ref.refresh(batchDatabaseProvider);
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
            onPressed: () async {
              showLoaderDialog(context);
              await ref.read(authServiceProvider).deleteSession();
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInScreen(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(child: Builder(builder: (context) {
            switch (ref.watch(destinationProvider)) {
              case 0:
                return const Batches();
              case 1:
                return const Batches();
              default:
                return const Text("Home");
            }
          }))
        ],
      ),
    );
  }
}
