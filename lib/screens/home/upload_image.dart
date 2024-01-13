import 'package:firebase_tutorial/constants/imports.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Posts');

  bool loading = false;
  File? _image;
  final picker = ImagePicker();

  Future getImageGallery() async {
    final PickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        Utils().toastMessage("No image picked");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    getImageGallery();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.red,
                      )),
                      height: 200,
                      width: 200,
                      child: _image != null
                          ? Image.file(_image!.absolute)
                          : const Center(child: Icon(Icons.image))),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                  title: 'Upload',
                  loading: loading,
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    firebase_storage.Reference ref = firebase_storage
                        .FirebaseStorage.instance
                        .ref('/dhwany/$id');
                    firebase_storage.UploadTask uploadTask =
                        ref.putFile(_image!.absolute);

                    Future.value(uploadTask).then((value) async {
                      var newUrl = await ref.getDownloadURL();

                      databaseRef.child(id).set(
                          {'id': id, 'body': newUrl.toString()}).then((value) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMessage("Post Uploaded");
                      }).onError((error, stackTrace) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMessage(error.toString());
                      });
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(error.toString());
                    });
                  })
            ]),
      ),
    );
  }
}
