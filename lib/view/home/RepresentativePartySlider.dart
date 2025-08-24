import 'package:flutter/material.dart';

class RepresentativePartySlider extends StatelessWidget {
  const RepresentativePartySlider({super.key});

  final List<Map<String, String>> parties = const [
    {
      'name': 'Bharatiya Janata Party (BJP)',
      'logo': 'assets/images/party/bjp-logo.png',
    },
    {
      'name': 'Indian National Congress (INC)',
      'logo': 'assets/images/party/inc-logo.png',
    },
    {
      'name': 'Aam Aadmi Party (AAP)',
      'logo': 'assets/images/party/aap-logo.png',
    },
    {
      'name': 'Communist Party of India (CPI)',
      'logo': 'assets/images/party/cpi-logo.png',
    },
    {
      'name': 'Samajwadi Party (SP)',
      'logo': 'assets/images/party/sp-logo.png',
    },
    {
      'name': 'Trinamool Congress (TMC)',
      'logo': 'assets/images/party/tmc-logo.png',
    },
    {
      'name': 'Nationalist Congress Party (NCP)',
      'logo': 'assets/images/party/ncp-logo.png',
    },
    {
      'name': 'Shiv Sena',
      'logo': 'assets/images/party/shiv-sena-logo.png',
    },
    {
      'name': 'AIADMK',
      'logo': 'assets/images/party/aiadmk-logo.png',
    },
    {
      'name': 'Bahujan Samaj Party (BSP)',
      'logo': 'assets/images/party/bsp-logo.png',
    },
    {
      'name': 'Janata Dal (United) - JD(U)',
      'logo': 'assets/images/party/jdu-logo.png',
    },
    {
      'name': 'Rashtriya Janata Dal (RJD)',
      'logo': 'assets/images/party/rjd-logo.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PARTY',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'REPRESENTATIVE PARTY',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001253),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: parties.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final party = parties[index];
                return _PartySliderCard(
                  name: party['name']!,
                  logoPath: party['logo']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PartySliderCard extends StatelessWidget {
  final String name;
  final String logoPath;

  const _PartySliderCard({
    required this.name,
    required this.logoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          // Navigate to party details
        },
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Image.asset(
                logoPath,
                width: 36,
                height: 36,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
