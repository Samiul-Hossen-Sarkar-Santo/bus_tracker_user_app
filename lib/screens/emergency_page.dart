import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emergency Contacts',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[900],
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          _buildEmergencyContactCard(
            context,
            'Call BUP Security Cell',
            '+8801748271902',
            Colors.green[500]!,
          ),
          const SizedBox(height: 20),
          _buildEmergencyContactCard(
            context,
            'Call 999',
            '999',
            Colors.green[500]!,
          ),
          const SizedBox(height: 20),
          _buildEmergencyContactCard(
            context,
            'Call Fire Service',
            '102',
            Colors.green[500]!,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactCard(
      BuildContext context, String title, String phoneNumber, Color color) {
    return GestureDetector(
      onTap: () => _confirmCall(context, phoneNumber, title),
      child: Center(
        child: Container(
          alignment: Alignment.center,
          width: 300,
          height: 100,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.green[500],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmCall(
      BuildContext context, String phoneNumber, String title) async {
    final shouldCall = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        elevation: 18,
        shadowColor: Colors.green[500],
        title: const Text(
          "Make a Call?",
          style: TextStyle(color: Colors.white),
        ),
        contentPadding: const EdgeInsets.all(20),
        content: Text(
          "Are You Sure You Want To $title?",
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, false); // Close dialog with "false"
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, true); // Close dialog with "true"
            },
            child: const Text(
              "Call",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );

    if (shouldCall == true) {
      _makePhoneCall(phoneNumber);
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
}
