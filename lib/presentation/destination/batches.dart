// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_dhobi_dashboard/presentation/screen/batch_detail_screen.dart';
import 'package:smart_dhobi_dashboard/presentation/widgets/loader_dialog.dart';
import 'package:smart_dhobi_dashboard/providers.dart';

import '../widgets/timestamp.dart';

class Batches extends ConsumerWidget {
  const Batches({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Batches",
            style: Theme.of(context).textTheme.headline4,
          ),
          FutureBuilder(
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        ref.refresh(batchDatabaseProvider);
                        showLoaderDialog(context);
                        ref.read(statusProvider.state).state =
                            await snapshot.data.elementAt(index).data["index"];
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BatchDetailScreen(
                              batchId:
                                  snapshot.data.elementAt(index).data["\$id"],
                              batchmates: snapshot.data
                                      .elementAt(index)
                                      .data["users"] ??
                                  [],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            title: Text(
                              "Id: ${snapshot.data.elementAt(index).data["\$id"]}",
                            ),
                            subtitle: Text(
                              "Date Created: ${readTimestamp(snapshot.data.elementAt(index).data["\$createdAt"])}",
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const CupertinoActivityIndicator();
              }
            },
            future: ref.watch(batchDatabaseProvider).getBatchList(),
          )
        ],
      ),
    );
  }
}
