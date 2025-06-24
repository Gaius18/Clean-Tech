import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app2/connexionParticulier.dart';
import 'package:app2/video.dart';
import 'package:app2/classement.dart';
import 'package:animate_do/animate_do.dart';
import 'package:app2/impact.dart';
import 'package:app2/VoirMission.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  bool _isDarkMode = false;
  String? _nom;
  String? _prenom;
  int _points = 0;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  late List<Map<String, dynamic>> _buttons;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    _buttons = [
      {
        'label': '🎥 Regarder Vidéo',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VideoListPage()),
          );
        },
      },
      {
        'label': '📜 Voir Missions',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VoirMissionPage()),
          );
        },
      },
      {'label': '📘 Information Éducative', 'onTap': () => debugPrint('Infos')},
      {
        'label': '📊 Suivi & Impact',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ImpactPage()),
          );
        },
      },
      {'label': '📚 Bibliothèque', 'onTap': () => debugPrint('Bibliothèque')},
      {
        'label': '🏆 Classement Communautaire',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ClassementPage()),
          );
        },
      },
    ];

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          setState(() {
            _nom = data['nom'];
            _prenom = data['prenom'];
            _points = data['points'] ?? 0; // Récupération des points
          });
        }
      } catch (e) {
        debugPrint("Erreur : $e");
      }
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Connexionparticulier()),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    final user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(primary: Colors.teal),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 37, 228, 91),
          title: const Text("Dashboard"),
          leading: Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
          ),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.teal),
                accountName: Text(
                  _prenom != null && _nom != null
                      ? '$_prenom $_nom'
                      : user?.displayName ?? 'Nom',
                  style: const TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  user?.email ?? 'Email',
                  style: const TextStyle(color: Colors.white),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.teal),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Paramètres'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Déconnexion'),
                onTap: () => _logout(),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  _isDarkMode
                      ? [Colors.black87, Colors.grey[900]!]
                      : [
                        const Color.fromARGB(255, 37, 228, 91),
                        Colors.tealAccent,
                      ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              if (_prenom != null && _nom != null)
                SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Bienvenue, $_prenom $_nom',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode ? Colors.white : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  color: Colors.amber[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.star, color: Colors.orange),
                    title: const Text("Mes points"),
                    subtitle: Text(
                      "$_points points accumulés",
                    ), // Affichage des points
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children:
                        _buttons.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return ZoomIn(
                            delay: Duration(milliseconds: 100 * index),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.9),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 6,
                              ),
                              onPressed: item['onTap'],
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  item['label'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
