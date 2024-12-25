import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/LoginPage.dart';
import 'package:furnitureapp/api/api.service.dart'; // Import APIService

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // TextEditingControllers for managing the input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = false;

  // Function to validate the form inputs
  bool validateSave() {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String phone = _phoneController.text.trim();
    String address = _addressController.text.trim();

    // Kiểm tra ràng buộc tên người dùng
    if (name.isEmpty || name.length < 3 || name.length > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username must be between 3 and 50 characters long!',
          style: TextStyle(color: Colors.red),
          ),
        ),
      );
      return false;
    }

    // Kiểm tra định dạng email
    if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
          'Please enter a valid email address!',
          style: TextStyle(color: Colors.red),
          ),
        ),
      );
      return false;
    }

    // Kiểm tra mật khẩu
    if (password.isEmpty || password.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 4 characters long!',
          style: TextStyle(color: Colors.red),
        ),
        ),
      );
      return false;
    }

    // Kiểm tra xác nhận mật khẩu
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match!',
          style: TextStyle(color: Colors.red),
        ),
        ),
      );
      return false;
    }

    // Kiểm tra số điện thoại (nếu cần ràng buộc đặc biệt)
    if (phone.isEmpty || !RegExp(r'^\d+$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number!',
          style: TextStyle(color: Colors.red),
        ),
        ),
      );
      return false;
    }

    // Kiểm tra địa chỉ (có thể tuỳ biến thêm theo yêu cầu)
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address cannot be empty!',
          style: TextStyle(color: Colors.red),
        ),
        ),
      );
      return false;
    }

    return true;
  }

  // Function to call the register API
  Future<void> registerUser() async {
    if (validateSave()) {
      setState(() {
        _isLoading = true;
      });

      bool isSuccess = await APIService.register(
        _nameController.text,
        _passwordController.text,
        _emailController.text,
        _phoneController.text,
        _addressController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center( // Căn giữa nội dung
            child: Text(
              'Registration successful.',
              style: const TextStyle(color: Colors.green), // Màu chữ cho thông báo thành công
              ), // Màu nền của SnackBar
            ),
             backgroundColor: Colors.grey,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        // Hiển thị thông báo lỗi nếu đăng ký thất bại (do vi phạm ràng buộc server)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Registration failed or user already exists. Please try again!',
              style: const TextStyle(color: Colors.red), // Màu chữ cho thông báo thất bại
            ),
            backgroundColor: Colors.white, // Màu nền của SnackBar
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/sign_up.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 35, // Đã chỉnh kích thước phông chữ ở đây
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B2321),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Please fill the input below here',
                      style: TextStyle(
                        fontSize: 14, // Đã chỉnh kích thước phông chữ ở đây
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B2321),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 13),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF).withOpacity(1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 5),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Your name...',
                        labelStyle: const TextStyle(color: Color(0xFFBDBEBF)),
                        filled: true,
                        fillColor: const Color(0xFFF2F2F7).withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email...',
                        labelStyle: const TextStyle(color: Color(0xFFBDBEBF)),
                        filled: true,
                        fillColor: const Color(0xFFF2F2F7).withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        labelStyle: const TextStyle(color: Color(0xFFBDBEBF)),
                        fillColor: const Color(0xFFF2F2F7).withOpacity(0.9),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        labelStyle: const TextStyle(color: Color(0xFFBDBEBF)),
                        filled: true,
                        fillColor: const Color(0xFFF2F2F7).withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        labelStyle: const TextStyle(color: Color(0xFFBDBEBF)),
                        filled: true,
                        fillColor: const Color(0xFFF2F2F7).withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Address',
                        labelStyle: const TextStyle(color: Color(0xFFBDBEBF)),
                        filled: true,
                        fillColor: const Color(0xFFF2F2F7).withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: registerUser,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(400, 55),
                              backgroundColor: const Color(0xFF2B2321),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have Account? ',
                              style: const TextStyle(color: Colors.grey), // Màu nâu
                            ),
                            TextSpan(
                              text: 'Log in',
                              style: const TextStyle(
                                color: Color(0xFF2B2321),
                                fontWeight: FontWeight.bold,
                              ), 
                              // Màu đen
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
