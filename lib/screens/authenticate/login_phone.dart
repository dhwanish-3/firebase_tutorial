import 'package:firebase_tutorial/constants/imports.dart';

class LoginwithPhone extends StatefulWidget {
  const LoginwithPhone({super.key});

  @override
  State<LoginwithPhone> createState() => _LoginwithPhoneState();
}

class _LoginwithPhoneState extends State<LoginwithPhone> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 80,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: phoneNumberController,
            decoration: const InputDecoration(
              hintText: '+1 233 4567 890',
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          RoundButton(
              title: 'Login',
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                auth.verifyPhoneNumber(
                  phoneNumber: phoneNumberController.text,
                  verificationCompleted: (_) {
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (e) {
                    Utils().toastMessage(e.toString());
                    setState(() {
                      loading = false;
                    });
                  },
                  codeSent: (String verificationId, int? token) {
                    setState(() {
                      loading = false;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerifyCodeScreen(
                                  VerificationId: verificationId,
                                )));
                  },
                  codeAutoRetrievalTimeout: (e) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(e.toString());
                  },
                );
              })
        ]),
      ),
    );
  }
}
