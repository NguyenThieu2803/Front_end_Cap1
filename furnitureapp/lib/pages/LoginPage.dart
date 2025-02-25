import 'sign_up.dart';
import 'package:flutter/material.dart';
import 'package:furnitureapp/config/config.dart';
import 'package:furnitureapp/pages/Homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:furnitureapp/api/api.service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: Config.firebaseConfig['apiKey']!,
      appId: Config.firebaseConfig['appId']!,
      messagingSenderId: Config.firebaseConfig['messagingSenderId']!,
      projectId: Config.firebaseConfig['projectId']!,
      ),
    );
  }

  bool validateSave() {
    String name = _nameController.text.trim();
    String password = _passwordController.text;

    // Kiểm tra ràng buộc tên người dùng
    if (name.isEmpty || name.length < 3 || name.length > 50) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Username must be between 3 and 50 characters long')));
      return false;
    }

    // Kiểm tra mật khẩu
    if (password.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password must be at least 6 characters long')));
      return false;
    }

    return true;
  }

  // Function to call the register API
  Future<void> loginUser() async {
    if (validateSave()) {
      setState(() {
        _isLoading = true;
      });

      bool isSuccess = await APIService.login(
        _nameController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (isSuccess) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Login successful!')));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Hiển thị thông báo lỗi nếu đăng ký thất bại (do vi phạm ràng buộc server)
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'login failed username or password not correctlty !. Please try again.')));
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      // Show loading indicator
      setState(() => _isLoading = true);
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      
      // If user cancels the sign-in flow
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Obtain auth details from request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final UserCredential userCredential = 
          await FirebaseAuth.instance.signInWithCredential(credential);
          
      // Call your backend
      if (userCredential.user != null) {
        await _socialLogin();
      }
      
    } catch (e) {
      print('Error during Google sign in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in with Google'))
      );
    } finally {
      // Hide loading indicator
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential = 
        FacebookAuthProvider.credential(result.accessToken!.tokenString); // Changed from token to tokenString
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      await _socialLogin();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _signInWithApple() async {
    try {
      final AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
      final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      final AuthCredential credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      await _socialLogin();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _socialLogin() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final idToken = await user.getIdToken();
      final isSuccess = await APIService.socialLogin(idToken!);
      if (isSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Social login failed!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/sign_up.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Title Text
          Positioned(
            top: screenHeight * 0.25,
            left: (screenWidth / 2) - (130 / 2),
            child: const Text(
              'Log In',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B2321),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.32,
            left: screenWidth * 0.2,
            right: screenWidth * 0.15,
            child: const Text(
              'Please fill in the input below',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2B2321),
              ),
            ),
          ),
          // White Box touching the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              // Added this line
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Changed to min
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'User Name',
                        labelStyle: TextStyle(color: Color(0xFFBDBEBF)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color(0xFFF2F2F7),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        labelStyle: TextStyle(color: Color(0xFFBDBEBF)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color(0xFFF2F2F7),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      ),
                    ),

                    // Login button
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2B2321),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          loginUser();
                        },
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(children: [
                      const Expanded(child: Divider(color: Colors.grey)),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Log in with',
                              style: TextStyle(color: Colors.grey))),
                      const Expanded(child: Divider(color: Colors.grey)),
                    ]),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _socialLoginButton(
                              icon: Icons.facebook,
                              color: Colors.blue,
                              onPressed: () async {
                                setState(() => _isLoading = true);
                                try {
                                  await _signInWithFacebook();
                                } finally {
                                  setState(() => _isLoading = false);
                                }
                              },
                          ),
                          _socialLoginButton(
                              icon: Icons.g_mobiledata,
                              color: Colors.red,
                              onPressed: () async {
                                setState(() => _isLoading = true);
                                try {
                                  await _signInWithGoogle();
                                } finally {
                                  setState(() => _isLoading = false);
                                }
                              },
                          ),
                          _socialLoginButton(
                              icon: Icons.apple,
                              color: Colors.black,
                              onPressed: () async {
                                setState(() => _isLoading = true);
                                try {
                                  await _signInWithApple();
                                } finally {
                                  setState(() => _isLoading = false);
                                }
                              },
                          ),
                        ]),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("Create Account?",
                          style: TextStyle(color: Colors.grey)),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()));
                          },
                          child: const Text("Sign up",
                              style: TextStyle(
                                  color: Color(0xFF2B2321),
                                  fontWeight: FontWeight.bold))),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialLoginButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: IconButton(
        icon: Icon(icon),
        iconSize: 30,
        color: color,
        onPressed: onPressed,
      ),
    );
  }
}
