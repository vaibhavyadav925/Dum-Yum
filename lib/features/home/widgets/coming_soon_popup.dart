import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ComingSoonPopup extends StatefulWidget {
  const ComingSoonPopup({super.key});

  @override
  State<ComingSoonPopup> createState() => _ComingSoonPopupState();
}

class _ComingSoonPopupState extends State<ComingSoonPopup> {
  final TextEditingController emailController = TextEditingController();
  Timer? countdownTimer;

  // Launch date: 1 January 2027
  final DateTime launchDate = DateTime(2027, 1, 1);
  Duration remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    updateCountdown();
    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => updateCountdown(),
    );
  }

  void updateCountdown() {
    if (!mounted) return;
    setState(() {
      remaining = launchDate.difference(DateTime.now());
      if (remaining.isNegative) remaining = Duration.zero;
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    emailController.dispose();
    super.dispose();
  }

  String get days => remaining.inDays.toString().padLeft(2, '0');
  String get hours => (remaining.inHours % 24).toString().padLeft(2, '0');
  String get minutes => (remaining.inMinutes % 60).toString().padLeft(2, '0');
  String get seconds => (remaining.inSeconds % 60).toString().padLeft(2, '0');

  void notifyMe() {
    final email = emailController.text.trim();
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailPattern.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you! Email notifications will be available soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget countdownBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 8,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget featureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, size: 11, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 460,
          maxHeight: screenHeight * 0.88,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // COMPACT HERO FOOD IMAGE
            SizedBox(
              height: 112,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/biryani/popup_biryani.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.background,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.restaurant,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 7,
                    right: 7,
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.95),
                        foregroundColor: AppColors.darkBrown,
                      ),
                      icon: const Icon(Icons.close, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // ALL CONTENT FITS WITHOUT AN INNER SCROLL VIEW
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BRAND
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.gold, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.restaurant,
                          color: Colors.white,
                          size: 21,
                        ),
                      ),
                      const SizedBox(width: 9),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DUM YANI',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.8,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            'SLOW-COOKED GOODNESS',
                            style: TextStyle(
                              fontSize: 8,
                              letterSpacing: 1.1,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 9),

                  // INTRODUCTION
                  const Text(
                    'SOMETHING IS SIMMERING',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Coming very soon.',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 27,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Slow-cooked biryani, sealed with flavour and delivered hot to your door.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.35,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 9),

                  // COUNTDOWN
                  Row(
                    children: [
                      countdownBox(days, 'DAYS'),
                      const SizedBox(width: 5),
                      countdownBox(hours, 'HOURS'),
                      const SizedBox(width: 5),
                      countdownBox(minutes, 'MINS'),
                      const SizedBox(width: 5),
                      countdownBox(seconds, 'SECS'),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // FEATURES
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      featureChip('Order online'),
                      featureChip('Home delivery'),
                      featureChip('Fresh dum biryani'),
                    ],
                  ),

                  const SizedBox(height: 9),

                  // EMAIL FIELD
                  SizedBox(
                    height: 43,
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'Your email address',
                        hintStyle: const TextStyle(fontSize: 12),
                        prefixIcon: const Icon(
                          Icons.mail_outline,
                          size: 18,
                          color: AppColors.secondary,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.3,
                          ),
                        ),
                      ),
                      onSubmitted: (_) => notifyMe(),
                    ),
                  ),

                  const SizedBox(height: 7),

                  // NOTIFY BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: notifyMe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: const Text(
                        'Notify me',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // BOTTOM ACTIONS
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            visualDensity: VisualDensity.compact,
                          ),
                          child: const Text(
                            'Explore the menu  →',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text(
                          'Maybe later',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
