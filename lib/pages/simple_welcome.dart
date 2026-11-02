import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/LanguageProvider.dart'; // تأكدي من صحة المسار هنا

class SimpleWelcome extends StatelessWidget {
  const SimpleWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب الـ Provider مع تفعيل خاصية listen لضمان تحديث الواجهة فوراً
    final langProvider = Provider.of<LanguageProvider>(context);
    final String lang = langProvider.selectedLanguage;

    // خريطة النصوص المترجمة
    final Map<String, Map<String, String>> localizedTexts = {
      'EN': {
        'login': 'LOGIN',
        'signup': 'SIGN UP',
      },
      'AR': {
        'login': 'تسجيل الدخول',
        'signup': 'إنشاء حساب',
      },
      'FR': {
        'login': 'SE CONNECTER',
        'signup': "S'INSCRIRE",
      },
    };

    final texts = localizedTexts[lang] ?? localizedTexts['EN']!;
    final bool isAr = lang == 'AR';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isAr ? Icons.arrow_back_ios_rounded : Icons.arrow_back_ios_new_rounded,
            color: const Color(0xFF08214E),
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // زر تبديل اللغة باستخدام دالة toggleLanguage الموجودة في ملفك
          IconButton(
            icon: const Icon(Icons.language, color: Color(0xFF08214E)),
            onPressed: () {
              langProvider.toggleLanguage(); 
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- تصميم المصباح ---
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF407FD2).withOpacity(0.18),
                            const Color(0xFFF5F5F5),
                          ],
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 80,
                      color: Color(0xFF08214E),
                    ),
                  ],
                ),
                
                const SizedBox(height: 25),

                const Text(
                  "CoachLink",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF08214E),
                    letterSpacing: 1.5,
                  ),
                ),
                
                const SizedBox(height: 55),

                // زر الدخول (LOGIN)
                _buildButton(
                  context, 
                  texts['login']!, 
                  const Color(0xFF407FD2), 
                  Colors.white, 
                  "/login"
                ),

                const SizedBox(height: 18),

                // زر التسجيل (SIGNUP)
                _buildButton(
                  context, 
                  texts['signup']!, 
                  const Color(0xFF83C6D9), 
                  const Color(0xFF08214E), 
                  "/signup"
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Color bgColor, Color textColor, String route) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () => Navigator.pushNamed(context, route),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.bold, 
            letterSpacing: 1
          ),
        ),
      ),
    );
  }
}