import 'package:flutter/material.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  static const Color primary = Color(0xFF995037);
  static const Color cream = Color(0xFFFBF8F1);
  static const Color brown = Color(0xFF341F15);
  static const Color muted = Color(0xFF81766D);

  final List<Map<String, String>> faqs = [
    {
      'question': 'How can I place an order?',
      'answer': 'Open the Menu page, choose your favourite biryani, add it to your cart, and proceed to checkout. Enter your delivery details and confirm your order.',
    },
    {
      'question': 'How can I track my order?',
      'answer': 'Go to the My Orders section from your profile. Select an order to view its current status and tracking details.',
    },
    {
      'question': 'Can I cancel my order?',
      'answer': 'Order cancellation is not currently available in the app. Please contact customer support when our support service becomes available.',
    },
    {
      'question': 'What payment methods are available?',
      'answer': 'Cash on Delivery (COD) is currently available. Online payment options will be introduced in a future update.',
    },
    {
      'question': 'How can I update my delivery address?',
      'answer': 'Open Profile, select Saved Addresses, and add or edit your delivery address. You can also choose a default address.',
    },
    {
      'question': 'What should I do if my order is delayed?',
      'answer': 'Open My Orders and check your order status. If your order is delayed, please contact our support team once contact details are available.',
    },
    {
      'question': 'What if I receive the wrong item?',
      'answer': 'Please keep your order details handy. Contact our support team when the support contact details are available so the issue can be reviewed.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: brown,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: brown),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 28),

          const Text(
            'How can we help you?',
            style: TextStyle(
              color: brown,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          _buildContactCard(
            icon: Icons.chat_bubble_outline,
            title: 'WhatsApp Support',
            subtitle: 'Coming soon',
          ),
          const SizedBox(height: 12),

          _buildContactCard(
            icon: Icons.email_outlined,
            title: 'Email Support',
            subtitle: 'Coming soon',
          ),
          const SizedBox(height: 28),

          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              color: brown,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          ...faqs.map((faq) => _buildFaqTile(faq['question']!, faq['answer']!)),

          const SizedBox(height: 25),

          Center(
            child: Column(
              children: const [
                Text(
                  'DUM-YANI',
                  style: TextStyle(
                    color: primary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'SLOW-COOKED GOODNESS',
                  style: TextStyle(
                    color: muted,
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'We are here to make your experience delicious!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We are here to help!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 9),
                Text(
                  'Find answers to your questions about Dum Yani.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.support_agent, color: Colors.white, size: 55),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE8DED2)),
      ),
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFF5EAE2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primary, size: 23),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: brown,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.lock_outline, color: muted, size: 19),
        ],
      ),
    );
  }

  Widget _buildFaqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8DED2)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        iconColor: primary,
        collapsedIconColor: muted,
        title: Text(
          question,
          style: const TextStyle(
            color: brown,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: const TextStyle(color: muted, fontSize: 13, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
