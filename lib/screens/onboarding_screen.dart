// lib/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to Pokédex",
          body: "Catch them all! Explore every Pokémon.",
          image: const Center(
            child: Icon(Icons.catching_pokemon, size: 100, color: Colors.red),
          ),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        PageViewModel(
          title: "Favorites",
          body: "❤️ Tap the heart to save your favorite Pokémon.",
          image: const Center(
            child: Icon(Icons.favorite, size: 100, color: Colors.red),
          ),
        ),
      ],
      onDone: () async {
        // Save a flag so Onboarding never shows again
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('seen_onboarding', true);

        // Go to Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text(
        "Get Started",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      dotsDecorator: const DotsDecorator(
        activeColor: Colors.red,
        size: Size(10, 10),
        activeSize: Size(22, 10),
      ),
    );
  }
}
