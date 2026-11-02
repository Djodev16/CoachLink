import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home.dart';
import '../screens/coach_home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int userType = 0;
  String selectedLanguage = 'EN';
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();

  final Map<String, Map<String, String>> _localizedText = {
    'EN': {
      'title': 'CREATE ACCOUNT',
      'name': 'Full Name',
      'email': 'Email Address',
      'pass': 'Password',
      'conf_pass': 'Confirm Password',
      'pass_mismatch': 'Passwords do not match',
      'spec': 'Specialization',
      'btn': 'CREATE ACCOUNT',
      'login_link': 'Already have an account? Login',
      'trainee': 'Trainee',
      'coach': 'Coach',
      'empty_error': 'Please fill in all fields',
      'success': 'Registration Successful!'
    },
    'AR': {
      'title': 'إنشاء حساب',
      'name': 'الاسم الكامل',
      'email': 'البريد الإلكتروني',
      'pass': 'كلمة المرور',
      'conf_pass': 'تأكيد كلمة المرور',
      'pass_mismatch': 'كلمات المرور غير متطابقة',
      'spec': 'التخصص',
      'btn': 'إنشاء الحساب',
      'login_link': 'لديك حساب؟ سجل دخولك',
      'trainee': 'متدرب',
      'coach': 'مدرب',
      'empty_error': 'يرجى ملء جميع الخانات',
      'success': 'تم التسجيل بنجاح!'
    },
    'FR': {
      'title': 'CRÉER UN COMPTE',
      'name': 'Nom complet',
      'email': 'Adresse e-mail',
      'pass': 'Mot de passe',
      'conf_pass': 'Confirmer le mot de passe',
      'pass_mismatch': 'Les mots de passe ne correspondent pas',
      'spec': 'Spécialisation',
      'btn': 'CRÉER LE COMPTE',
      'login_link': 'Déjà un compte? Connexion',
      'trainee': 'Stagiaire',
      'coach': 'Coach',
      'empty_error': 'Veuillez remplir tous les champs',
      'success': 'Inscription réussie!'
    }
  };

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _specializationController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPass = _confirmPasswordController.text.trim();

    
    if (email.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        confirmPass.isEmpty) {
      _showSnackBar(_localizedText[selectedLanguage]!['empty_error']!);
      return;
    }

    if (password != confirmPass) {
      _showSnackBar(_localizedText[selectedLanguage]!['pass_mismatch']!);
      return;
    }

    setState(() => _isLoading = true);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      DatabaseReference ref = FirebaseDatabase.instanceFor(
              app: FirebaseAuth.instance.app,
              databaseURL:
                  "https://coachlink-6ba3f-default-rtdb.firebaseio.com/")
          .ref("users/${userCredential.user!.uid}");

      await ref.set({
        "uid": userCredential.user!.uid,
        "fullName": name,
        "email": email,
        "userType": userType == 0 ? "Trainee" : "Coach",
        "specialization":
            userType == 1 ? _specializationController.text.trim() : "N/A",
        "createdAt": ServerValue.timestamp,
      });

      if (mounted) {
        _showSnackBar(_localizedText[selectedLanguage]!['success']!);
        if (userType == 1) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const CoachHomeMain()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false);
        }
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message ?? "Firebase Error");
    } catch (e) {
      _showSnackBar(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.black87),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color darkNavy = Color(0xFF1B3A5E);
    const Color favoriteBlue = Color(0xFF5E86B3);
    var lang = _localizedText[selectedLanguage]!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          
          Positioned(
            top: 50,
            right: 20,
            child: DropdownButton<String>(
              value: selectedLanguage,
              underline: const SizedBox(),
              icon: const Icon(Icons.language, color: favoriteBlue),
              onChanged: (val) => setState(() => selectedLanguage = val!),
              items: ['EN', 'FR', 'AR']
                  .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                  .toList(),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: favoriteBlue),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("CoachLink",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 45,
                        color: favoriteBlue,
                        fontWeight: FontWeight.bold)),
                Text(lang['title']!,
                    style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 3,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          Positioned(
            top: MediaQuery.of(context).size.height * 0.28,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              decoration: const BoxDecoration(
                color: favoriteBlue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          _buildToggleBtn(lang['trainee']!, 0, darkNavy),
                          _buildToggleBtn(lang['coach']!, 1, darkNavy),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildWhiteField(
                        lang['name']!, Icons.person_outline, _nameController),
                    const SizedBox(height: 15),
                    _buildWhiteField(
                        lang['email']!, Icons.email_outlined, _emailController),
                    const SizedBox(height: 15),
                    if (userType == 1) ...[
                      _buildWhiteField(
                          lang['spec']!,
                          Icons.workspace_premium_outlined,
                          _specializationController),
                      const SizedBox(height: 15),
                    ],
                    _buildWhiteField(
                        lang['pass']!, Icons.lock_outline, _passwordController,
                        isPass: true),
                    const SizedBox(height: 15),
                    
                    _buildWhiteField(lang['conf_pass']!,
                        Icons.lock_reset_outlined, _confirmPasswordController,
                        isPass: true),
                    const SizedBox(height: 30),
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: darkNavy,
                                minimumSize: const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: _handleSignUp,
                            child: Text(lang['btn']!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(lang['login_link']!,
                          style: const TextStyle(color: Colors.white70)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildToggleBtn(String label, int index, Color activeColor) {
    bool isSelected = userType == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => userType = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: isSelected ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(12)),
          child: Center(
              child: Text(label,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }

  Widget _buildWhiteField(
      String hint, IconData icon, TextEditingController controller,
      {bool isPass = false}) {
    bool isArabic = selectedLanguage == 'AR';
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: controller,
        obscureText: isPass,
        textAlign: isArabic ? TextAlign.right : TextAlign.left,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: isArabic ? null : Icon(icon, color: Colors.grey),
          suffixIcon: isArabic ? Icon(icon, color: Colors.grey) : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }
}
