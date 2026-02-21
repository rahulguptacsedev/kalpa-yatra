import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String backgroundImageUrl;
  final ValueChanged<String>? onSearch;

  const HeroSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.backgroundImageUrl,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 420),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(backgroundImageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withAlpha(100),
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryColor.withAlpha(180), Colors.black.withAlpha(160)],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            // Om icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.self_improvement,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.2,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withAlpha(220),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Search bar
            Container(
              constraints: const BoxConstraints(maxWidth: 540),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(50),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: TextField(
                onSubmitted: onSearch,
                style: GoogleFonts.poppins(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Search experiences in Varanasi...',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey.shade500,
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: primaryColor,
                    size: 24,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
