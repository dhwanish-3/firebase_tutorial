import 'package:firebase_tutorial/constants/imports.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final nameController = TextEditingController();
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  PatientUser _userFromFirebaseUser(User user) {
    return (user != null
        ? PatientUser(
            uid: user.uid,
            age: 20,
            birthDate: '10-10-2000',
            emailid: user.email as String,
            gender: 2,
            height: 150,
            weight: 50,
            imageUrl: 'ImageUrl',
            isAlcoholic: false,
            isPhysicalActive: false,
            isPhysicallyChallenged: false,
            isSmoker: false,
            name: 'dhwansih',
            nickName: 'dhwany')
        : null) as PatientUser;
  }

//changed to final from FirebaseAuth
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    nameController.dispose();
  }

  Future registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      setState(() {
        loading = true;
      });
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user as User;
      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(user.uid, name,
          'nick', 'imageUrl', 'dob', 150, 50, false, false, false, false, 0);

      return _userFromFirebaseUser(user);
    } catch (error) {
      setState(() {
        loading = false;
      });
      debugPrint(error.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          centerTitle: true,
          title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            hintText: 'Name',
                            prefixIcon: Icon(Icons.auto_fix_normal_rounded),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.alternate_email),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              hintText: 'Password',
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_open),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            } else if (value.length < 6) {
                              return 'Please enter a password with atleast 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: confirmpasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              hintText: 'Confirm Password',
                              labelText: 'Confirm Password',
                              prefixIcon: Icon(Icons.lock_open),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return null;
                            }
                            if (confirmpasswordController.text !=
                                passwordController.text) {
                              return 'Your passwords didn`t match';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  RoundButton(
                    title: 'Sign up',
                    loading: loading,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        PatientUser result = await registerWithEmailAndPassword(
                            nameController.text,
                            emailController.text,
                            passwordController.text);
                        if (context.mounted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PostScreen()));
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text('Login'))
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
