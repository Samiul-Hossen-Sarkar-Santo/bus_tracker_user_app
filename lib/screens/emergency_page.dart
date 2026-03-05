import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
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
            '+8801769028787',
            theme.colorScheme.primary,
          ),
          const SizedBox(height: 20),
          _buildEmergencyContactCard(
            context,
            'Call 999',
            '999',
            theme.colorScheme.primary,
          ),
          const SizedBox(height: 20),
          _buildEmergencyContactCard(
            context,
            'Call Fire Service',
            '102',
            theme.colorScheme.primary,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactCard(
      BuildContext context, String title, String phoneNumber, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () async {
        final messenger = ScaffoldMessenger.of(context);
        final Uri url = Uri.parse('tel:$phoneNumber');
        try {
          if (!await canLaunchUrl(url)) {
            _showCallError(messenger);
            return;
          }
          final didLaunch = await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
          if (!didLaunch) {
            _showCallError(messenger);
          }
        } catch (e, stackTrace) {
          debugPrint('Error launching dialer: $e');
          debugPrintStack(stackTrace: stackTrace);
          _showCallError(messenger);
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? theme.colorScheme.surface
              : theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              phoneNumber,
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCallError(ScaffoldMessengerState messenger) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Could not open the phone dialer.')),
    );
  }
}
