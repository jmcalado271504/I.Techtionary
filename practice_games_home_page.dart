import 'package:flutter/material.dart';
import '../services/random_challenge_manager.dart';
import '../practice_games/pages/game_session_page.dart';

import '../practice_games/pages/html_games_page.dart';
import '../practice_games/pages/css_games_page.dart';
import '../practice_games/pages/java_games_page.dart';
import '../practice_games/pages/javascript_games_page.dart';
import '../practice_games/pages/mysql_games_page.dart';
// import '../practice_games/pages/python_games_page.dart';
// import '../practice_games/pages/sql_games_page.dart';
import '../practice_games/pages/php_games_page.dart';

class PracticeGamesHomePage extends StatelessWidget {
  const PracticeGamesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Practice Games"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Improve your coding skills by playing interactive coding games.",
            style: theme.textTheme.bodyLarge,
          ),

          const SizedBox(height: 25),

          _buildGameCard(
            context,
            icon: Icons.casino,
            title: "Random Challenge",
            subtitle: "Random language + random game",
            color: Colors.deepPurple,
            onTap: () {
              final games = RandomChallengeManager.getRandomGames();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GameSessionPage(
                    title: "Random Challenge",
                    games: games,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 25),

          Text(
            "Choose Programming Language",
            style: theme.textTheme.titleLarge,
          ),

          const SizedBox(height: 15),

          _buildGameCard(
            context,
            icon: Icons.language,
            title: "HTML",
            subtitle: "Practice HTML games",
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HtmlGamesPage(),
                ),
              );
            },
          ),

          _buildGameCard(
            context,
            icon: Icons.palette,
            title: "CSS",
            subtitle: "Practice CSS games",
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CssGamesPage(),
                ),
              );
            },
          ),

          _buildGameCard(
            context,
            icon: Icons.coffee,
            title: "Java",
            subtitle: "Practice Java games",
            color: Colors.brown,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const JavaGamesPage(),
                ),
              );
            },
          ),

          _buildGameCard(
            context,
            icon: Icons.javascript,
            title: "JavaScript",
            subtitle: "Practice JavaScript games",
            color: Colors.amber,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const JavaScriptGamesPage(),
                ),
              );
            },
          ),

          _buildGameCard(
            context,
            icon: Icons.storage,
            title: "MySQL",
            subtitle: "Practice MySQL games",
            color: Colors.teal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MySqlGamesPage(),
                ),
              );
            },
          ),

          // _buildGameCard(
          //   context,
          //   icon: Icons.code,
          //   title: "Python",
          //   subtitle: "Practice Python games",
          //   color: Colors.lightBlue,
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) => const PythonGamesPage(),
          //       ),
          //     );
          //   },
          // ),

          _buildGameCard(
            context,
            icon: Icons.code,
            title: "PHP",
            subtitle: "Practice PHP games",
            color: Colors.indigo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PhpGamesPage(),
                ),
              );
            },
          ),

          // _buildGameCard(
          //   context,
          //   icon: Icons.data_object,
          //   title: "SQL",
          //   subtitle: "Practice SQL games",
          //   color: Colors.green,
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) => const SqlGamesPage(),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildGameCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.15),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}