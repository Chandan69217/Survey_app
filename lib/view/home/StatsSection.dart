import 'package:flutter/material.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF123763),
      child: Padding(
        padding: const EdgeInsets.only(top: 5,bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            StatCard(
              icon: Icons.groups,
              count: 232,
              label: "No. Of Parties",
              gradient: [Color(0xFFFFC107), Color(0xFFFFD54F)],
            ),
            StatCard(
              icon: Icons.apartment,
              count: 521,
              label: "Total State",
              gradient: [Color(0xFFAB47BC), Color(0xFFEF5350)],
            ),
            StatCard(
              icon: Icons.headset_mic,
              count: 1463,
              label: "Total Review",
              gradient: [Color(0xFF26C6DA), Color(0xFF0288D1)],
            ),
            StatCard(
              icon: Icons.person,
              count: 15,
              label: "Total Politician",
              gradient: [Color(0xFFFFC107), Color(0xFFFFD54F)],
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final List<Color> gradient;

  const StatCard({
    super.key,
    required this.icon,
    required this.count,
    required this.label,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 6),
        TweenAnimationBuilder(
          tween: IntTween(begin: 0, end: count),
          duration: const Duration(seconds: 2),
          builder: (context, value, child) => Text(
            "$value",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFffffff),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
