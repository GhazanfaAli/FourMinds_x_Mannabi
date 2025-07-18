import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mini_shopping_app/routes/app_routes.dart';
import 'package:mini_shopping_app/widgets/gradient_button.dart';
import 'package:mini_shopping_app/widgets/utils.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double _buttonScale = 1.0;
  bool loading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final  FirebaseAuth auth = FirebaseAuth.instance;


  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
void login() {
  setState(() {
    loading = true;
  });

  auth.signInWithEmailAndPassword(
    email: emailController.text.toString(),
    password: passwordController.text.toString()
  ).then((value) {
    Utils.toastMessage(value.user!.email.toString());
     Navigator.pushNamed(context, AppRoutes.mainPage);
    
    setState(() {
      loading = false;
    });
  }).onError((error, stackTrace) {
    debugPrint(error.toString());
    Utils.toastMessage(error.toString());

    setState(() {
      loading = false; //=> ensure loading is reset to false in case of error
    });
  });
}

@override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: screenHeight,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
  width: MediaQuery.sizeOf(context).width,
  height: MediaQuery.sizeOf(context).height * 0.5,
  decoration: const BoxDecoration(
  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
  gradient: LinearGradient(
    colors: [Color(0xFF6DD5FA), Color.fromARGB(255, 15, 68, 104)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
),

  child: Center(
    child: SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.6, 
      height: MediaQuery.sizeOf(context).height * 0.6, 
      child: Lottie.asset('assets/lotties/Animation - 1743764351883.json'),
    ),
  ),
),
 Positioned(
                      top: 325,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: 
                   Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),


        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    _buildTextField(
                      controller: emailController,
                      hintText: 'Email',
                      icon: Icons.email_outlined,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      icon: Icons.lock_clock_outlined,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              GradientButton(
                title: 'Login',
                loading: loading,
                ontap: () {
                  if (_formKey.currentState!.validate()) {
                    login();
                  }
                  
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                  },
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.forgotPassword);
                    },
                    child: const Text('Forgot password', style: TextStyle(color: Color.fromARGB(255, 85, 59, 59)))),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.002,),
              Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            const Expanded(
                child: Divider(
        thickness: 1.5,
        color: Colors.grey,
                ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
        'Or',
        style: TextStyle(
          color: Colors.grey[800],
          fontWeight: FontWeight.bold,
        ),
                ),
            ),
            const Expanded(
                child: Divider(
        thickness: 1.5,
        color: Colors.grey,
                ),
            ),
          ],
        ),
                ),
                
              const SizedBox(height: 10),
             Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account? ",
            style: TextStyle(
                color: Color.fromARGB(255, 124, 93, 93),
                fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero, 
                minimumSize: Size(0, 0),   
                tapTargetSize: MaterialTapTargetSize.shrinkWrap, 
            ),
            onPressed: () {
            //  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                Navigator.pushNamed(context, AppRoutes.signup);
            },
            child: const Text(
                'Sign up',
                style: TextStyle(color: Color.fromARGB(255, 72, 5, 255),fontWeight: FontWeight.bold,fontSize: 15),
            ),
          ),
        ],
                ),
        
            ],
          ),
        ),
      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: hintText == 'Password' ? _obscurePassword : obscureText,
     decoration: InputDecoration(
  prefixIcon: Icon(icon),
  hintText: hintText,
  filled: true,
  fillColor: Colors.white,
  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12), 
   suffixIcon: hintText == 'Password'
          ? IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            )
          : null,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    borderSide: const BorderSide(color: Colors.blue),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: Colors.grey),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: Colors.blue), // Error border styling
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: Colors.blue),
  ),
),
 validator: validator,
    );
  }

  void _animateButtonDown() {
    setState(() {
      _buttonScale = 0.9;  // Shrink the button
    });
  }

  // Button animation up (on release)
  void _animateButtonUp(BuildContext context) async {
    setState(() {
      _buttonScale = 1.0;  // Return to normal size
    });
  }
}

