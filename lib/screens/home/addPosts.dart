import 'package:firebase_tutorial/constants/imports.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loading = false;
  final postController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Posts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Posts'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            maxLines: 4,
            controller: postController,
            decoration: const InputDecoration(
                hintText: 'What is in your Brain',
                border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 20,
          ),
          RoundButton(
              title: 'Add',
              loading: loading,
              onTap: () {
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                setState(() {
                  loading = true;
                });
                databaseRef.child(id).set({
                  'id': id,
                  'body': postController.text.toString()
                }).then((value) {
                  Utils().toastMessage('Post Added');
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              })
        ]),
      ),
    );
  }
}
