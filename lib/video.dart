import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoListPage extends StatelessWidget {
  const VideoListPage({Key? key}) : super(key: key);

  static final List<Map<String, String>> videos = [
    {
      'title': 'Introduction Au développement Durable',
      'url': 'https://youtu.be/VAPfpaTwp_A',
      'description':
          '🌍✨ Bienvenue dans le monde du Développement Durable !\n\n'
          '🧠 Qu\'est-ce que c\'est ?\n'
          'Le développement durable, c\'est vivre en harmonie avec notre planète tout en assurant un avenir meilleur pour les générations futures. '
          'C\'est un équilibre entre l\'écologie, l\'économie et le social. 🌱💼🤝\n\n'
          '📦 Les 3 piliers principaux :\n'
          '- **Écologique** 🌱 : Protéger l\'environnement et préserver les ressources naturelles.\n'
          '- **Économique** 💼 : Favoriser une croissance responsable et durable.\n'
          '- **Social** 🤝 : Assurer l\'égalité et le bien-être pour tous.\n\n'
          '🎯 L\'objectif ?\n'
          'Créer un monde où progrès et respect de la planète coexistent. Ensemble, nous pouvons faire la différence ! 🌟\n\n'
          ,
    },
    {
      'title': 'Poubelle Innovante (Digital Smart)',
      'url': 'https://youtu.be/Kxl1b8_zgqM',
      'description':
          'Une innovation révolutionnaire pour la gestion des déchets.',
    },
    {
      'title': 'Pollution de l\'environnement',
      'url': 'https://youtu.be/UEyjpFfmWto?si=j9bSodARRzh5F0QL',
      'description':
          '💥 La pollution, c’est comme une allergie pour notre planète : plastique, CO₂, et déchets en tout genre. 😷🌍\n\n'
          '🛑 Les conséquences ?\n'
          '- 🌊 Les océans suffoquent et les animaux marins disparaissent.\n'
          '- 🐻‍❄️ Les ours polaires perdent leur habitat.\n'
          '- 🌪️ Le climat devient de plus en plus imprévisible.\n\n'
          '👉 Que pouvons-nous faire ?\n'
          '- 🛍️ Réduire l’utilisation du plastique.\n'
          '- 🚴‍♂️ Privilégier les moyens de transport écologiques.\n'
          '- ♻️ Recycler et trier nos déchets correctement.\n'
          '- 🌿 Planter des arbres et protéger la biodiversité.\n\n'
          '💚 Chaque geste compte pour sauver notre planète. Ensemble, nous pouvons faire la différence. 🌟\n\n'
          ,
    },
  ];

  String _getThumbnailUrl(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    return 'https://img.youtube.com/vi/$videoId/0.jpg'; // URL de la miniature
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des vidéos')),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          final thumbnailUrl = _getThumbnailUrl(video['url']!);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => VideoPlayerPage(
                        videoUrl: video['url']!,
                        videoTitle: video['title']!,
                        videoDescription: video['description']!,
                      ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Miniature
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      thumbnailUrl,
                      width: 150, // Largeur de la miniature
                      height: 100, // Hauteur de la miniature
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ), // Espacement entre la miniature et le texte
                  // Titre et description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video['title']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Informons-nous sur le développement durable et l\'innovation',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;
  final String videoDescription;

  const VideoPlayerPage({
    Key? key,
    required this.videoUrl,
    required this.videoTitle,
    required this.videoDescription,
  }) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId == null) {
      throw Exception("Vidéo invalide : ${widget.videoUrl}");
    }
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.videoTitle)),
      body: Column(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressColors: const ProgressBarColors(
              playedColor: Colors.deepPurple,
              handleColor: Colors.deepPurpleAccent,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.videoDescription,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.normal, // Suppression de l'italique
                color: Colors.black, // Couleur noire
                fontWeight: FontWeight.w500, // Poids du texte augmenté
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
