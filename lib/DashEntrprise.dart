import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app2/Capter.dart';
import 'package:app2/Modif.dart';
import 'package:app2/MettreMission.dart';
import 'package:app2/impactEntrprise.dart';
import 'package:app2/connexionParticulier.dart';
import 'package:app2/connexion_page.dart';

class DashboardEntreprise extends StatefulWidget {
  const DashboardEntreprise({super.key});

  @override
  State<DashboardEntreprise> createState() => _DashboardEntrepriseState();
}

class _DashboardEntrepriseState extends State<DashboardEntreprise> {
  String? _nomEntreprise;

  @override
  void initState() {
    super.initState();
    _loadNomEntreprise();
  }

  Future<void> _loadNomEntreprise() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final doc =
            await FirebaseFirestore.instance
                .collection('entreprises')
                .doc(user.uid)
                .get();

        if (doc.exists) {
          setState(() {
            _nomEntreprise = doc['nom'];
          });
        }
      } catch (e) {
        debugPrint(
          "Erreur lors de la récupération du nom de l'entreprise : $e",
        );
      }
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ConnexionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00E676), // Vert clair
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _nomEntreprise != null ? ' $_nomEntreprise' : 'Tableau de bord',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(
          0xFF00E676,
        ).withOpacity(0.9), // Opacité augmentée
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode, color: Colors.white),
            onPressed: () {
              // Ajouter thème sombre ici
            },
          ),
        ],
      ),
      drawer: const EntrepriseDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true, // Permet de centrer les cartes
            children: [
              DashboardCard(
                icon: Icons.assignment_turned_in,
                title: "Missions",
                subtitle: "Créer & Gérer",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MettreMissionPage(),
                    ),
                  );
                  // Ajouter navigation ou action ici
                },
              ),
              DashboardCard(
                icon: Icons.people,
                title: "Recompenses",
                subtitle: "Attribution de point",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPointsPage()),
                  );
                  // Ajouter navigation ou action ici
                },
              ),
              DashboardCard(
                icon: Icons.sensors,
                title: "Capteurs",
                subtitle: "Suivi en temps réel",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarteConteneursPage(),
                    ),
                  );
                },
              ),
              DashboardCard(
                icon: Icons.bar_chart,
                title: "Statistiques",
                subtitle: "Performance & Impact",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImpactEntreprisePage(),
                    ),
                  );
                },
              ),
              DashboardCard(
                icon: Icons.notifications_active,
                title: "Notifications",
                subtitle: "Envoyer une alerte",
                onTap: () {
                  // Ajouter navigation ou action ici
                },
              ),
              DashboardCard(
                icon: Icons.settings,
                title: "Paramètres",
                subtitle: "Personnaliser",
                onTap: () {
                  // Ajouter navigation ou action ici
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.green.shade700),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class EntrepriseDrawer extends StatelessWidget {
  const EntrepriseDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.business, color: Colors.white, size: 48),
                SizedBox(height: 10),
                Text(
                  "Entreprise",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Tableau de bord'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Missions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MettreMissionPage()),
              );
              // Ajouter navigation ou action ici
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Recompenses'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPointsPage()),
              );
              // Ajouter navigation ou action ici
            },
          ),
          ListTile(
            leading: const Icon(Icons.sensors),
            title: const Text('Capteurs'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CarteConteneursPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Déconnexion'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              (context.findAncestorStateOfType<_DashboardEntrepriseState>())
                  ?._logout();
            },
          ),
        ],
      ),
    );
  }
}
