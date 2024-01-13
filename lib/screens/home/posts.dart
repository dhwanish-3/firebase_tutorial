import 'package:firebase_tutorial/constants/imports.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Posts');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Posts'),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()))
                      .onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                });
              },
              icon: const Icon(Icons.logout)),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: TextFormField(
            controller: searchFilter,
            decoration: const InputDecoration(
              hintText: 'Search',
              border: OutlineInputBorder(),
            ),
            onChanged: (String value) {
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: FirebaseAnimatedList(
              query: ref,
              defaultChild: const Text("Loading"),
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child('body').value.toString();
                String id = snapshot.child('id').value.toString();
                if (searchFilter.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.child('body').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                ShowMyDialog(title, id);
                              },
                              leading: const Icon(Icons.edit),
                              title: const Text('Edit'),
                            )),
                        PopupMenuItem(
                            value: 1,
                            onTap: () {
                              // Navigator.pop(context);
                              ref.child(id).remove();
                            },
                            child: const ListTile(
                              leading: Icon(Icons.delete_outline),
                              title: Text('Delete'),
                            ))
                      ],
                    ),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(searchFilter.text.toLowerCase())) {
                  return ListTile(
                    title: Text(snapshot.child('body').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ]),
    );
  }

  Future<void> ShowMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              controller: editController,
              decoration: const InputDecoration(
                hintText: 'Edit',
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.child(id).update(
                        {'body': editController.text.toString()}).then((value) {
                      Utils().toastMessage('Post Updated');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text("Update"))
            ],
          );
        });
  }
}

// stream builder method which can be used where firabase animated list can not be used
// Expanded(
        //     child: StreamBuilder(
        //   stream: ref.onValue,
        //   builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        //     if (!snapshot.hasData) {
        //       return const CircularProgressIndicator();
        //     } else {
        //       Map<dynamic, dynamic> map =
        //           snapshot.data!.snapshot.value as dynamic;
        //       List<dynamic> list = [];
        //       list.clear();
        //       list = map.values.toList();
        //       return ListView.builder(
        //           itemCount: snapshot.data!.snapshot.children.length,
        //           itemBuilder: (context, index) {
        //             return ListTile(
        //               title: Text(list[index]['body']),
        //               subtitle: Text(list[index]['id']),
        //             );
        //           });
        //     }
        //   },
        // )),