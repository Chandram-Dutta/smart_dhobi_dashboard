// ignore_for_file: use_build_context_synchronously

import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_dhobi_dashboard/presentation/widgets/loader_dialog.dart';
import 'package:smart_dhobi_dashboard/providers.dart';

class BatchDetailScreen extends ConsumerWidget {
  BatchDetailScreen({
    Key? key,
    required this.batchId,
    required this.batchmates,
    required this.notification,
  }) : super(key: key);

  final String batchId;
  final List<dynamic> batchmates;
  final List<dynamic> notification;
  final TextEditingController batchmadeIdController = TextEditingController();
  final TextEditingController notificationController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add Batchmate"),
                content: TextField(
                  controller: batchmadeIdController,
                  decoration: const InputDecoration(
                    hintText: "Enter Batchmate's id",
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      List newBatchmates = batchmates;
                      newBatchmates.add(
                        batchmadeIdController.text,
                      );
                      showLoaderDialog(context);
                      await ref.watch(batchDatabaseProvider).addPerson(
                            batchmadeIdController.text,
                            batchId,
                            newBatchmates,
                          );
                      ref.refresh(batchDatabaseProvider);
                      batchmadeIdController.clear();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        label: const Text(
          "Add Batchmate",
        ),
        icon: const Icon(
          Icons.person_add,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Batch Details",
        ),
        actions: [
          IconButton(
              onPressed: () {
                ref.refresh(batchDatabaseProvider);
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Timeline",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 0,
                            groupValue: ref.watch(statusProvider),
                            onChanged: (value) async {
                              ref.read(statusProvider.state).state =
                                  value as int;
                              showLoaderDialog(context);
                              await ref
                                  .watch(batchDatabaseProvider)
                                  .updateBatchIndex(
                                    value,
                                    batchId,
                                  );
                              Navigator.pop(context);
                            },
                          ),
                          const Text("Received"),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: ref.watch(statusProvider),
                            onChanged: (value) async {
                              ref.read(statusProvider.state).state =
                                  value as int;
                              showLoaderDialog(context);
                              await ref
                                  .watch(batchDatabaseProvider)
                                  .updateBatchIndex(
                                    value,
                                    batchId,
                                  );
                              Navigator.pop(context);
                            },
                          ),
                          const Text("Washing"),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 2,
                            groupValue: ref.watch(statusProvider),
                            onChanged: (value) async {
                              ref.read(statusProvider.state).state =
                                  value as int;
                              showLoaderDialog(context);
                              await ref
                                  .watch(batchDatabaseProvider)
                                  .updateBatchIndex(
                                    value,
                                    batchId,
                                  );
                              Navigator.pop(context);
                            },
                          ),
                          const Text("Folding"),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 3,
                            groupValue: ref.watch(statusProvider),
                            onChanged: (value) async {
                              ref.read(statusProvider.state).state =
                                  value as int;
                              showLoaderDialog(context);
                              await ref
                                  .watch(batchDatabaseProvider)
                                  .updateBatchIndex(
                                    value,
                                    batchId,
                                  );
                              Navigator.pop(context);
                            },
                          ),
                          const Text("Ready"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "Batch Mates",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    FutureBuilder(
                      builder: (context, AsyncSnapshot<Document> snapshot) {
                        if (!snapshot.hasData) {
                          return const CupertinoActivityIndicator();
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.data["users"].length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  snapshot.data!.data["users"][index],
                                ),
                              );
                            },
                          );
                        }
                      },
                      future:
                          ref.watch(batchDatabaseProvider).getBatch(batchId),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "Notifications",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Column(
                      children: [
                        FutureBuilder(
                          builder: (context, AsyncSnapshot<Document> snapshot) {
                            if (!snapshot.hasData) {
                              return const CupertinoActivityIndicator();
                            } else {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    snapshot.data!.data["notifications"].length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      snapshot.data!.data["notifications"]
                                          [index],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          future: ref
                              .watch(batchDatabaseProvider)
                              .getBatch(batchId),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Add Notification Message"),
                                  content: TextField(
                                    controller: notificationController,
                                    decoration: const InputDecoration(
                                      hintText: "Enter Notification Message",
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        List newNotification = notification;
                                        newNotification.add(
                                          notificationController.text,
                                        );
                                        showLoaderDialog(context);
                                        await ref
                                            .watch(batchDatabaseProvider)
                                            .addNotifications(
                                              notificationController.text,
                                              batchId,
                                              newNotification,
                                            );
                                        ref.refresh(batchDatabaseProvider);
                                        notificationController.clear();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Add"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text("Add Notification"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
