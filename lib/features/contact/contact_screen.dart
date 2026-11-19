import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  static const Color terracotta = Color(0xFF995037);
  static const Color cream = Color(0xFFFBF8F1);
  static const Color darkGreen = Color(0xFF353E3B);
  static const Color deepBrown = Color(0xFF341F15);
  static const Color muted = Color(0xFF81766D);
  static const Color line = Color(0xFFE8DED2);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  String _topic = 'Order help';
  String _subject = 'Order, party, or feedback';
  int? _expandedFaq;

  final List<String> _topics = const [
    'Order help',
    'Party / bulk order',
    'Feedback',
    'Retail partnership',
    'Something else',
  ];

  final List<Map<String, String>> _faqs = const [
    {
      'q': 'How do I place an order?',
      'a': 'Browse the menu, add your favourite biryani to the cart, and continue to checkout. You can review your order details before placing it.',
    },
    {
      'q': 'Where can I buy DUMYANI?',
      'a': 'Please use the store-location option on this page to find the nearest DUMYANI counter. Store details can be connected to the live website or backend.',
    },
    {
      'q': 'Do I need an account to order?',
      'a': 'You can explore the menu as a guest. Sign in when prompted during checkout to continue with your order.',
    },
    {
      'q': 'Do you deliver late at night or early morning?',
      'a': 'The website lists delivery hours as 12 PM – 3 AM. Delivery availability may depend on your location.',
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Message ready'),
        content: const Text(
          'Your details have been validated. Message submission will be enabled when the contact form is connected to the Dum Yani backend.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Done', style: TextStyle(color: terracotta)),
          ),
        ],
      ),
    );
  }

  void _showNotConnected(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature will be connected when the app backend is integrated.',
        ),
        backgroundColor: darkGreen,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: muted, fontSize: 13),
      prefixIcon: prefix,
      filled: true,
      fillColor: cream,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: terracotta, width: 1.3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  Widget _sectionTitle(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            color: deepBrown,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: muted, height: 1.45),
          ),
        ],
      ],
    );
  }

  Widget _topInfoCard({
    required IconData icon,
    required String title,
    required String detail,
    required String caption,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: line),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: deepBrown.withValues(alpha: .04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: terracotta.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: terracotta, size: 19),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: deepBrown,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  detail,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  caption,
                  style: const TextStyle(color: muted, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text, {String? optional}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: deepBrown,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(text: text),
            if (optional != null)
              TextSpan(
                text: ' ($optional)',
                style: const TextStyle(
                  color: muted,
                  fontWeight: FontWeight.normal,
                ),
              ),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: terracotta),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    String? optional,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label, optional: optional),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 13, color: deepBrown),
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }

  Widget _contactForm() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: line),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: deepBrown.withValues(alpha: .045),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'S A Y   H E L L O',
              style: TextStyle(
                color: terracotta,
                fontSize: 9,
                letterSpacing: 1.8,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            _sectionTitle(
              'Send us a message',
              subtitle: 'We usually reply within a few hours. Find the method that works best for you.',
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 7,
              children: _topics.map((topic) {
                final selected = _topic == topic;
                return ChoiceChip(
                  label: Text(
                    topic,
                    style: TextStyle(
                      fontSize: 10,
                      color: selected ? Colors.white : deepBrown,
                    ),
                  ),
                  selected: selected,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _topic = topic),
                  backgroundColor: cream,
                  selectedColor: terracotta,
                  side: BorderSide(color: selected ? terracotta : line),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 0,
                  ),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            _formField(
              label: 'Your name',
              hint: 'Enter your name',
              controller: _nameController,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Please enter your name'
                  : null,
            ),
            const SizedBox(height: 13),
            _formField(
              label: 'Email address',
              hint: 'you@example.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  v == null ||
                      !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())
                  ? 'Enter a valid email address'
                  : null,
            ),
            const SizedBox(height: 13),
            _formField(
              label: 'Mobile number',
              optional: 'optional',
              hint: '10-digit mobile number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                return RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())
                    ? null
                    : 'Enter a valid 10-digit mobile number';
              },
            ),
            const SizedBox(height: 13),
            _fieldLabel('Subject'),
            DropdownButtonFormField<String>(
              initialValue: _subject,
              isExpanded: true,
              decoration: _inputDecoration('Choose a subject'),
              style: const TextStyle(fontSize: 12, color: deepBrown),
              items: const [
                DropdownMenuItem(
                  value: 'Order, party, or feedback',
                  child: Text('Order, party, or feedback'),
                ),
                DropdownMenuItem(
                  value: 'Delivery query',
                  child: Text('Delivery query'),
                ),
                DropdownMenuItem(
                  value: 'Food quality',
                  child: Text('Food quality'),
                ),
                DropdownMenuItem(
                  value: 'Payment query',
                  child: Text('Payment query'),
                ),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (value) =>
                  setState(() => _subject = value ?? _subject),
            ),
            const SizedBox(height: 13),
            _formField(
              label: 'Message',
              hint: 'Tell us how we can help...',
              controller: _messageController,
              maxLines: 5,
              validator: (v) => v == null || v.trim().length < 10
                  ? 'Please enter at least 10 characters'
                  : null,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 45,
              child: ElevatedButton.icon(
                onPressed: _submitMessage,
                icon: const Icon(Icons.send_rounded, size: 15),
                label: const Text('Send Message'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: terracotta,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sideLink(IconData icon, String title, String subtitle) {
    return InkWell(
      onTap: () => _showNotConnected(title),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: line),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: darkGreen,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(icon, color: const Color(0xFFD9B77A), size: 17),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: deepBrown,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: muted,
                      fontSize: 9,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: muted, size: 17),
          ],
        ),
      ),
    );
  }

  Widget _quickAnswers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _sectionTitle('Quick answers')),
            TextButton(
              onPressed: () =>
                  setState(() => _expandedFaq = _expandedFaq == -1 ? null : -1),
              child: const Text(
                'All FAQs  →',
                style: TextStyle(color: terracotta, fontSize: 10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...List.generate(_faqs.length, (index) {
          final faq = _faqs[index];
          final expanded = _expandedFaq == index || _expandedFaq == -1;
          return Container(
            margin: const EdgeInsets.only(bottom: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: line),
              borderRadius: BorderRadius.circular(7),
            ),
            child: ExpansionTile(
              key: PageStorageKey('faq_$index'),
              initiallyExpanded: expanded,
              onExpansionChanged: (value) {
                setState(() => _expandedFaq = value ? index : null);
              },
              tilePadding: const EdgeInsets.symmetric(horizontal: 12),
              childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 13),
              minTileHeight: 42,
              iconColor: terracotta,
              collapsedIconColor: terracotta,
              title: Text(
                faq['q']!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: deepBrown,
                ),
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    faq['a']!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: muted,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back, color: deepBrown),
        ),
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: deepBrown,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 7, 15, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topInfoCard(
                icon: Icons.location_city_outlined,
                title: 'Visit Us',
                detail: 'Shop No. 29–30, Sunrise Plaza, Jaipuria, Indirapuram, Ghaziabad',
                caption: 'Registered office',
              ),
              const SizedBox(height: 10),
              _topInfoCard(
                icon: Icons.access_time,
                title: 'Opening Hours',
                detail: 'Delivery: 12 PM – 3 AM',
                caption: 'Counters: 12–4 PM and 7–11 PM',
              ),
              const SizedBox(height: 20),
              _contactForm(),
              const SizedBox(height: 14),
              const SizedBox(height: 9),
              _sideLink(
                Icons.qr_code_scanner,
                'About An Order',
                'Scan the QR code on your box, or register a complaint here.',
              ),
              const SizedBox(height: 8),
              _sideLink(
                Icons.event_available,
                'Party or bulk order',
                'Book ahead and we will cook it fresh for your time.',
              ),
              const SizedBox(height: 8),
              _sideLink(
                Icons.storefront,
                'Find DUMYANI near you',
                'Shops and counters that sell our biryani.',
              ),
              const SizedBox(height: 24),
              _quickAnswers(),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'DUM-YANI  •  SLOW-COOKED GOODNESS',
                  style: TextStyle(
                    color: muted,
                    fontSize: 9,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()
      ..color = Colors.white.withValues(alpha: .9)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final thinRoad = Paint()
      ..color = const Color(0xFFCAD5CF)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paths = <Path>[
      Path()
        ..moveTo(-10, size.height * .25)
        ..lineTo(size.width * .35, size.height * .45)
        ..lineTo(size.width * .7, size.height * .2)
        ..lineTo(size.width + 10, size.height * .38),
      Path()
        ..moveTo(size.width * .15, -10)
        ..lineTo(size.width * .4, size.height * .45)
        ..lineTo(size.width * .3, size.height + 10),
      Path()
        ..moveTo(size.width * .75, -10)
        ..lineTo(size.width * .62, size.height * .55)
        ..lineTo(size.width * .85, size.height + 10),
      Path()
        ..moveTo(-10, size.height * .8)
        ..lineTo(size.width * .4, size.height * .65)
        ..lineTo(size.width + 10, size.height * .85),
    ];
    for (final path in paths) {
      canvas.drawPath(path, road);
      canvas.drawPath(path, thinRoad);
    }

    final park = Paint()..color = const Color(0xFFC8D9C5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .04,
          size.height * .55,
          size.width * .2,
          size.height * .22,
        ),
        const Radius.circular(8),
      ),
      park,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .72,
          size.height * .58,
          size.width * .22,
          size.height * .2,
        ),
        const Radius.circular(8),
      ),
      park,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
