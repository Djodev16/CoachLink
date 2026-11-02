import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import '../providers/LanguageProvider.dart';
import '../screens/browse_coaches_screen.dart';
import '../screens/search_results_screen.dart';
import '../screens/my_programs_screen.dart';
import '../screens/book_session_screen.dart';
import '../screens/notifications_screen.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "User";
  int _selectedIndex = 0;

  static const Color drSofiaNavy = Color(0xFF1B3A5E);
  static const Color drSofiaGold = Color(0xFFB89B5E);
  static const Color drSofiaBg = Color(0xFFF8FAFC);

  final Map<String, Map<String, String>> localizedTexts = {
    'EN': {
      'welcome': 'Welcome,',
      'search': 'Search for courses...',
      'quote': '"Empowering your journey from insight to impact"',
      'quick_actions': 'Quick Shortcuts',
      'courses': 'My Courses',
      'goals': 'My Goals',
      'chat': 'Chat',
      'browse': 'Find a Coach',
      'my_programs': 'My Programs',
      'store_nav': 'Store',
      'home_nav': 'Home',
      'schedule_nav': 'Schedule',
      'profile_nav': 'Profile',
      'notif_title': 'Notifications',
    },
    'AR': {
      'welcome': 'مرحباً،',
      'search': 'ابحث عن دورات...',
      'quote': '"تمكين رحلتك من الوعي إلى التأثير الحقيقي"',
      'quick_actions': 'اختصارات سريعة',
      'courses': 'دوراتي',
      'goals': 'أهدافي',
      'chat': 'المحادثة',
      'browse': 'ابحث عن مدرب',
      'my_programs': 'برامجي',
      'store_nav': 'المتجر',
      'home_nav': 'الرئيسية',
      'schedule_nav': 'المواعيد',
      'profile_nav': 'حسابي',
      'notif_title': 'التنبيهات',
    },
    'FR': {
      'welcome': 'Bienvenue,',
      'search': 'Rechercher des cours...',
      'quote': '"Propulser votre voyage de l\'intuition à l\'impact"',
      'quick_actions': 'Raccourcis rapides',
      'courses': 'Mes Cours',
      'goals': 'Mes Objectifs',
      'chat': 'Chat',
      'browse': 'Trouver un Coach',
      'my_programs': 'Mes Programmes',
      'store_nav': 'Boutique',
      'home_nav': 'Accueil',
      'schedule_nav': 'Calendrier',
      'profile_nav': 'Profil',
      'notif_title': 'Notifications',
    },
  };

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instanceFor(
              app: FirebaseAuth.instance.app,
              databaseURL:
                  "https://coachlink-6ba3f-default-rtdb.firebaseio.com/")
          .ref("users/${user.uid}/fullName");
      final snapshot = await ref.get();
      if (mounted && snapshot.exists) {
        setState(() => userName = snapshot.value.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    String lang = langProvider.selectedLanguage;
    bool isRtl = lang == 'AR';
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: drSofiaBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(localizedTexts[lang]?['welcome'] ?? "",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              Text(userName,
                  style: const TextStyle(
                      color: drSofiaNavy,
                      fontWeight: FontWeight.bold,
                      fontSize: 22)),
            ],
          ),
          actions: [
            StreamBuilder<int>(
              stream: userId.isNotEmpty
                  ? NotificationService.unreadCountStream(userId)
                  : const Stream.empty(),
              builder: (context, snap) {
                final count = snap.data ?? 0;
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_active_outlined,
                          color: drSofiaNavy),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const NotificationsScreen())),
                    ),
                    if (count > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                          child: Text('$count',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              _buildSearchBar(lang),
              const SizedBox(height: 20),
              _buildInspirationCard(
                  drSofiaNavy, localizedTexts[lang]?['quote'] ?? ""),
              const SizedBox(height: 25),
              Text(localizedTexts[lang]?['quick_actions'] ?? "",
                  style: const TextStyle(
                      color: drSofiaNavy,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              const SizedBox(height: 15),
              // الشبكة الآن تحتوي على 4 أيقونات فقط (2x2) بشكل متناسق
              _buildQuickGrid(context, lang),
              const SizedBox(height: 30),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
            if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const BookSessionScreen()));
            } else if (index == 2) {
              // فتح صفحة المتجر من الشريط السفلي
              Navigator.pushNamed(context, '/client_store');
            } else if (index == 3) {
              Navigator.pushNamed(context, '/profile');
            }
          },
          selectedItemColor: drSofiaNavy,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home_rounded),
                label: localizedTexts[lang]?['home_nav'] ?? ""),
            BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_today_rounded),
                label: localizedTexts[lang]?['schedule_nav'] ?? ""),
            BottomNavigationBarItem(
                icon: const Icon(Icons.shopping_bag_outlined), // المتجر مكانه هنا ثابت
                label: localizedTexts[lang]?['store_nav'] ?? ""),
            BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline_rounded),
                label: localizedTexts[lang]?['profile_nav'] ?? ""),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(String lang) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const SearchResultsScreen())),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)
            ]),
        child: AbsorbPointer(
          child: TextField(
            textAlign: lang == 'AR' ? TextAlign.right : TextAlign.left,
            decoration: InputDecoration(
                icon: lang == 'AR'
                    ? null
                    : const Icon(Icons.search, color: drSofiaGold),
                suffixIcon: lang == 'AR'
                    ? const Icon(Icons.search, color: drSofiaGold)
                    : null,
                hintText: localizedTexts[lang]?['search'],
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickGrid(BuildContext context, String lang) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildQuickCard(
            localizedTexts[lang]?['my_programs'] ?? "",
            Icons.lightbulb_outline,
            const Color(0xFFE3F2FD),
            Colors.blue,
            () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const MyProgramsScreen()))),
        _buildQuickCard(
            localizedTexts[lang]?['goals'] ?? "",
            Icons.ads_click,
            const Color(0xFFFDF7E7),
            drSofiaGold,
            () => Navigator.pushNamed(context, '/goals')),
        _buildQuickCard(
            localizedTexts[lang]?['chat'] ?? "",
            Icons.forum_outlined,
            const Color(0xFFE8F5E9),
            Colors.green,
            () => Navigator.pushNamed(context, '/chat')),
        _buildQuickCard(
            localizedTexts[lang]?['browse'] ?? "",
            Icons.search_outlined,
            const Color(0xFFF3E5F5),
            Colors.purple,
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const BrowseCoachesScreen()))),
      ],
    );
  }

  Widget _buildQuickCard(String title, IconData icon, Color bgColor,
      Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(22)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 30, color: iconColor),
          const SizedBox(height: 10),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: drSofiaNavy,
                  fontSize: 13))
        ]),
      ),
    );
  }

  Widget _buildInspirationCard(Color primary, String quote) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient:
                LinearGradient(colors: [primary, primary.withOpacity(0.8)])),
        child: Text(quote,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontStyle: FontStyle.italic)));
  }
}