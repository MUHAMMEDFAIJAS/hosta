import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('1. Introduction'),
              _sectionText(
                'Welcome to Hosta. We are committed to protecting your privacy. '
                'This Privacy Policy explains how we collect, use, and safeguard '
                'your information when you use our mobile application.',
              ),
              _sectionTitle('2. Information We Collect'),
              _sectionSubtitle('a. Personal Information'),
              _sectionText(
                'We do not require users to create an account or provide personal identification. '
                'Optional data like name or contact information may be collected in future updates.',
              ),
              _sectionSubtitle('b. Location Data'),
              _sectionText(
                'We request access to your location to show nearby hospitals, doctors, ambulance, and blood bank services. '
                'Location access is optional and only used when granted.',
              ),
              _sectionSubtitle('c. Search & Usage Data'),
              _sectionText(
                'We collect search queries (e.g., hospital names) to improve your experience and help you find relevant results.',
              ),
              _sectionSubtitle('d. Device Information'),
              _sectionText(
                'We may collect non-personal device information like OS version, device model, and crash reports for analytics.',
              ),
              _sectionSubtitle('e. Third-party Services'),
              _sectionText(
                'We use Google AdMob to display ads, which may collect anonymous usage data. '
                'Refer to Google’s Privacy Policy at https://policies.google.com/privacy.',
              ),
              _sectionTitle('3. How We Use Your Information'),
              _sectionText(
                'Collected data is used to:\n'
                '- Improve app performance\n'
                '- Show location-relevant results\n'
                '- Display relevant ads via AdMob',
              ),
              _sectionTitle('4. Data Sharing'),
              _sectionText(
                'We do not share your data with third parties unless:\n'
                '- Required by law\n'
                '- Handled by third-party services like AdMob for analytics or ads',
              ),
              _sectionTitle('5. Data Retention'),
              _sectionText(
                'We do not store your personal data. All location and search data is processed in real-time and not retained.',
              ),
              _sectionTitle('6. Children’s Privacy'),
              _sectionText(
                'This app is not intended for children under 13. We do not knowingly collect personal data from children.',
              ),
              _sectionTitle('7. Changes to this Policy'),
              _sectionText(
                'We may update this Privacy Policy occasionally. We recommend reviewing this page periodically for any changes.',
              ),
              _sectionTitle('8. Contact Us'),
              _sectionText(
                'If you have any questions or concerns about this Privacy Policy, '
                'please contact us at [Your Support Email].',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _sectionSubtitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _sectionText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
        height: 1.5,
      ),
    );
  }
}
