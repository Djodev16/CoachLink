import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../screens/coach_home_screen.dart'; 
import 'package:provider/provider.dart'; 
import '../providers/LanguageProvider.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final Map<String, Map<String, String>> localizedValues = {
    'EN': {
      'login_title': 'LOGIN',
      'email': 'Email',
      'password': 'Password',
      'btn': 'LOGIN',
      'no_acc': "Don't have an account? Sign Up",
      'forgot': 'Forgot Password?',
      'fill': 'Please fill all fields',
      'error_user': 'User not found',
      'error_invalid': 'Invalid email or password',
      'reset_sent': 'Password reset link sent to your email',
      'enter_email': 'Enter your email first',
    },
    'AR': {
      'login_title': 'تسجيل الدخول',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'btn': 'دخول',
      'no_acc': 'ليس لديك حساب؟ سجل الآن',
      'forgot': 'نسيت كلمة المرور؟',
      'fill': 'يرجى ملء جميع الخانات',
      'error_user': 'المستخدم غير موجود',
      'error_invalid': 'خطأ في البريد أو كلمة المرور',
      'reset_sent': 'تم إرسال رابط استعادة كلمة المرور لبريدك',
      'enter_email': 'أدخل بريدك الإلكتروني أولاً',
    },
    'FR': {
      'login_title': 'CONNEXION',
      'email': 'E-mail',
      'password': 'Mot de passe',
      'btn': 'SE CONNECTER',
      'no_acc': "Pas de compte ? S'inscrire",
      'forgot': 'Mot de passe oublié ?',
      'fill': 'Veuillez remplir tous les champs',
      'error_user': 'Utilisateur non trouvé',
      'error_invalid': 'E-mail ou mot de passe invalide',
      'reset_sent': 'Lien de réinitialisation envoyé par e-mail',
      'enter_email': 'Entrez d\'abord votre e-mail',
    },
  };

  String _getText(String key, String lang) {
    return localizedValues[lang]?[key] ?? "";
  }

  Future<void> _login(String lang) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError(_getText('fill', lang));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;
      final ref = FirebaseDatabase.instance.ref("users/$uid/userType");
      final snapshot = await ref.get();

      if (!snapshot.exists) {
        _showError("User role not found");
        return;
      }

      final role = snapshot.value as String;
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              
              builder: (_) => role == "Coach" ? const CoachHomeMain() : const HomeScreen()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg = e.code == 'user-not-found'
          ? _getText('error_user', lang)
          : _getText('error_invalid', lang);
      _showError(errorMsg);
    } catch (e) {
      _showError("Error: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword(String lang) async {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      _showError(_getText('enter_email', lang));
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSuccess(_getText('reset_sent', lang));
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    String selectedLanguage = langProvider.selectedLanguage; 
    
    const Color darkNavy = Color(0xFF1B3A5E);
    const Color favoriteBlue = Color(0xFF5E86B3);
    bool isAr = selectedLanguage == 'AR';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: isAr ? null : 20,
                right: isAr ? 20 : null,
                child: IconButton(
                  icon: Icon(
                    isAr ? Icons.arrow_back_ios_rounded : Icons.arrow_back_ios_new_rounded, 
                    color: favoriteBlue
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              
              Positioned(
                top: 50,
                left: isAr ? 20 : null,
                right: isAr ? null : 20,
                child: DropdownButton<String>(
                  value: selectedLanguage,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.language, color: favoriteBlue),
                  onChanged: (val) {
                    if (val != null) {
                      langProvider.updateLanguage(val);
                    }
                  },
                  items: ['EN', 'AR', 'FR']
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e,
                              style: const TextStyle(
                                  color: favoriteBlue,
                                  fontWeight: FontWeight.bold))))
                      .toList(),
                ),
              ),

              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    const Text("CoachLink",
                        style: TextStyle(
                            fontSize: 45,
                            color: favoriteBlue,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic)),
                    const SizedBox(height: 10),
                    Text(_getText('login_title', selectedLanguage),
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2)),
                  ],
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.65,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  decoration: const BoxDecoration(
                    color: favoriteBlue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
                  child: Column(
                    children: [
                      _buildField(_getText('email', selectedLanguage), Icons.email_outlined,
                          _emailController, selectedLanguage),
                      const SizedBox(height: 15),
                      _buildField(_getText('password', selectedLanguage), Icons.lock_outline,
                          _passwordController, selectedLanguage, isPass: true),
                      
                      Align(
                        alignment: isAr ? Alignment.centerLeft : Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _resetPassword(selectedLanguage),
                          child: Text(_getText('forgot', selectedLanguage),
                              style: const TextStyle(color: Colors.white, fontSize: 13)),
                        ),
                      ),
                      
                      const SizedBox(height: 10),
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkNavy,
                                minimumSize: const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              onPressed: () => _login(selectedLanguage),
                              child: Text(_getText('btn', selectedLanguage),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                      
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/signup'),
                        child: Text(_getText('no_acc', selectedLanguage),
                            style: const TextStyle(color: Colors.white70)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String hint, IconData icon, TextEditingController controller, String lang,
      {bool isPass = false}) {
    bool isAr = lang == 'AR';
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: controller,
        obscureText: isPass,
        textAlign: isAr ? TextAlign.right : TextAlign.left,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: isAr ? null : Icon(icon, color: Colors.grey),
          suffixIcon: isAr ? Icon(icon, color: Colors.grey) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(18),
        ),
      ),
    );
  }
}