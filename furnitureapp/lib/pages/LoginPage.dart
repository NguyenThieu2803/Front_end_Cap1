import 'sign_up.dart';
import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/sign_up.dart';
import 'package:furnitureapp/pages/Homepage.dart';
import 'package:furnitureapp/api/api.service.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  bool validateSave() {
  String name = _nameController.text.trim();
  String password = _passwordController.text;

  // Kiểm tra ràng buộc tên người dùng
  if (name.isEmpty || name.length < 3 || name.length > 50) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Username must be between 3 and 50 characters long'))
    );
    return false;
  }

  // Kiểm tra mật khẩu
  if (password.isEmpty || password.length < 4) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password must be at least 4 characters long'))
    );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!'))
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Hiển thị thông báo lỗi nếu đăng ký thất bại (do vi phạm ràng buộc server)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('login failed username or password not correctlty !. Please try again.'))
      );
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
                image: AssetImage(
                  'assets/sign_up.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Text
          Positioned(
            top: screenHeight * 0.35, // Giảm tỷ lệ để có nhiều không gian hơn
            left: (screenWidth / 2) - (130 / 2),
            child: const Text(
              'Log In',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B2321),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.4,
            left: screenWidth * 0.2,
            right: screenWidth * 0.15,
            child: const Text(
              'Please fill the input below here',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B2321),
              ),
            ),
          ),
          // White Box without scroll
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.5,
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        borderRadius: BorderRadius.all(Radius.circular(10)), // Bo góc
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
                        backgroundColor:Color(0xFF2B2321),
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
                      fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Colors.grey)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'log in with',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.facebook),
                        iconSize: 50, // Giảm kích thước icon
                        color: Colors.blue,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.g_mobiledata),
                        iconSize: 50, // Giảm kích thước icon
                        color: Colors.red,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.apple),
                        iconSize: 50, // Giảm kích thước icon
                        color: Colors.black,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 25), // Giảm khoảng cách để thêm không gian
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Create Account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          // Nếu muốn chuyển sang màn hình đăng ký
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()),
                          );
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(color:Color(0xFF2B2321),
                                fontWeight: FontWeight.bold,

                        ),
                      ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
