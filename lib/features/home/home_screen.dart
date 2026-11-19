import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../cart/cart_screen.dart';
import '../booking/advance_booking_screen.dart';
import '../menu/menu_screen.dart';
import 'widgets/coming_soon_popup.dart';
import '../orders/order_history_screen.dart';
import '../profile/profile_screen.dart';
import '../contact/contact_screen.dart';
import '../wishlist/wishlist_screen.dart';
import '../../widgets/premium_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final VideoPlayerController _heroVideoController;
  bool _heroVideoReady = false;

  @override
  void initState() {
    super.initState();
    _heroVideoController = VideoPlayerController.asset(
      'assets/videos/biryani_hero.mp4',
    );
    _initializeHeroVideo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (_) => const ComingSoonPopup(),
      );
    });
  }

  Future<void> _initializeHeroVideo() async {
    try {
      await _heroVideoController.initialize();
      await _heroVideoController.setLooping(true);
      await _heroVideoController.setVolume(0);
      if (!mounted) return;
      setState(() => _heroVideoReady = true);
      await _heroVideoController.play();
    } catch (error) {
      debugPrint('Could not load hero video: $error');
    }
  }

  @override
  void dispose() {
    _heroVideoController.dispose();
    super.dispose();
  }

  void openMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MenuScreen()),
    );
  }

  void openAdvanceBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdvanceBookingScreen()),
    );
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  void openWishlist() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WishlistScreen()),
    );
  }

  Widget eyebrow(String text, {Color color = AppColors.primary}) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: color,
        fontSize: 9,
        letterSpacing: 1.8,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget sectionHeading(
    String eyebrowText,
    String heading, {
    String? trailing,
    VoidCallback? onTrailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              eyebrow(eyebrowText),
              const SizedBox(height: 7),
              Text(
                heading,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 25,
                  height: 1.08,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null)
          TextButton(
            onPressed: onTrailing,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
            child: Text(
              trailing,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }

  Widget heroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 350,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_heroVideoReady)
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _heroVideoController.value.size.width,
                    height: _heroVideoController.value.size.height,
                    child: VideoPlayer(_heroVideoController),
                  ),
                ),
              )
            else
              Image.asset(
                'assets/images/biryani/chicken_biryani.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.secondary,
                  child: const Icon(
                    Icons.restaurant,
                    color: AppColors.gold,
                    size: 65,
                  ),
                ),
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.82),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: AppColors.primary,
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    eyebrow('Dum cooked fresh'),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  eyebrow('Slow-cooked goodness', color: AppColors.gold),
                  const SizedBox(height: 9),
                  const Text(
                    'A little dum.\nA lot of love.',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 37,
                      height: 1.02,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    'Biryani made to bring everyone to the table.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: openMenu,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 19),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Order now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(width: 9),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categorySection() {
    final categories = <({String title, IconData icon, String subtitle})>[
      (
        title: 'Chicken',
        icon: Icons.lunch_dining_outlined,
        subtitle: 'Bone-in & boneless',
      ),
      (
        title: 'Mutton',
        icon: Icons.restaurant_outlined,
        subtitle: 'Limited batches',
      ),
      (title: 'Paneer', icon: Icons.eco_outlined, subtitle: 'Vegetarian'),
      (title: 'Soya', icon: Icons.grass_outlined, subtitle: 'Vegetarian'),
      (
        title: 'Egg',
        icon: Icons.egg_alt_outlined,
        subtitle: 'Classic favourite',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeading(
          'Find your favourite',
          'What are you craving?',
          trailing: 'View all',
          onTrailing: openMenu,
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 112,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final category = categories[index];

              return InkWell(
                onTap: openMenu,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: 112,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 39,
                        height: 39,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.09),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          category.icon,
                          color: AppColors.primary,
                          size: 21,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        category.title,
                        style: const TextStyle(
                          color: AppColors.darkBrown,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        category.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget storyCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDE4D7),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                eyebrow('Our story'),
                const SizedBox(height: 8),
                const Text(
                  'More than a meal.',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 23,
                    height: 1.08,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A love for good food, patient cooking and moments shared around one table.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 9),
                GestureDetector(
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'DUM YANI',
                      applicationVersion: 'Our story',
                      children: const [
                        Text(
                          'DUM YANI celebrates slow-cooked biryani, thoughtful ingredients and the joy of sharing good food.',
                        ),
                      ],
                    );
                  },
                  child: const Text(
                    'Discover our story  ↗',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: AspectRatio(
                aspectRatio: 0.88,
                child: Image.asset(
                  'assets/images/biryani/mutton_biryani.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: AppColors.border,
                    child: const Icon(Icons.restaurant, size: 38),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget boxCard({
    required String name,
    required String weight,
    required String size,
    required String detail,
    required bool featured,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: featured ? AppColors.primary : AppColors.secondary,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: featured ? AppColors.primary : AppColors.secondary,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              size.toUpperCase(),
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 8,
                letterSpacing: 1.3,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'serif',
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              detail,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 13),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  weight,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 4),
                  child: Text(
                    'GRAMS',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 7,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget processTile(IconData icon, String title, String description) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.darkBrown,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(
                fontSize: 9,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuPromoCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          SizedBox(
            height: 205,
            width: double.infinity,
            child: Image.asset(
              'assets/images/biryani/veg_biryani.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppColors.secondary,
                child: const Icon(
                  Icons.restaurant,
                  color: AppColors.gold,
                  size: 50,
                ),
              ),
            ),
          ),
          Container(
            height: 205,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.secondary.withValues(alpha: 0.96),
                  AppColors.secondary.withValues(alpha: 0.18),
                ],
              ),
            ),
          ),
          Positioned(
            left: 18,
            top: 20,
            bottom: 20,
            width: MediaQuery.of(context).size.width * 0.58,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                eyebrow('From our kitchen', color: AppColors.gold),
                const SizedBox(height: 9),
                const Text(
                  'Every grain\nhas a story.',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 27,
                    height: 1.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Find the biryani that feels like yours.',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: openMenu,
                  child: const Row(
                    children: [
                      Text(
                        'See the menu',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: AppColors.gold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget advanceBookingCard() {
    return InkWell(
      onTap: openAdvanceBooking,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE4D7),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: AppColors.primary,
                size: 27,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PLAN AHEAD',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 9,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Book your biryani in advance',
                    style: TextStyle(
                      color: AppColors.darkBrown,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Choose a preferred date and time.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.primary,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }

  Widget kitchenPromiseCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE4D7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.soup_kitchen_outlined,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MADE WITH LOVE, SERVED WITH PRIDE',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 8,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'A little dum. A lot of flavour.',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 19,
                        height: 1.1,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBrown,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Every DUM YANI biryani is prepared with care, layered with flavour and made for moments worth sharing.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 15),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 13),
          const Row(
            children: [
              Expanded(
                child: _PromisePoint(
                  icon: Icons.eco_outlined,
                  label: 'Quality ingredients',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _PromisePoint(
                  icon: Icons.access_time_rounded,
                  label: 'Slow dum cooking',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _PromisePoint(
                  icon: Icons.favorite_border_rounded,
                  label: 'Made with care',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget biryaniMomentsSection() {
    Widget momentCard({
      required IconData icon,
      required String label,
      required String title,
      required String description,
      required Color background,
    }) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 39,
                width: 39,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.gold, size: 21),
              ),
              const SizedBox(height: 14),
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 8,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'serif',
                  fontSize: 17,
                  height: 1.08,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 9,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeading(
          'A little something for every mood',
          'Make it a biryani moment.',
        ),
        const SizedBox(height: 13),
        SizedBox(
          height: 205,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              momentCard(
                icon: Icons.lunch_dining_rounded,
                label: 'Just for you',
                title: 'Craving\nsomething special?',
                description: 'Pick your favourite and enjoy a comforting meal.',
                background: AppColors.secondary,
              ),
              const SizedBox(width: 10),
              momentCard(
                icon: Icons.groups_rounded,
                label: 'Made to share',
                title: 'Bring everyone\nto the table.',
                description: 'Good food makes together-time even better.',
                background: AppColors.primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: OutlinedButton(
            onPressed: openMenu,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Explore our menu',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget footer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 23, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        children: [
          const Icon(Icons.restaurant, color: AppColors.gold, size: 27),
          const SizedBox(height: 7),
          const Text(
            'DUM YANI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'SLOW-COOKED GOODNESS',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 8,
              letterSpacing: 1.7,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Good food, great taste and piping hot biryani, made to be shared.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.45),
          ),
          const SizedBox(height: 15),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 18,
            children: [
              TextButton(onPressed: openMenu, child: const Text('Menu')),
              TextButton(onPressed: openCart, child: const Text('Cart')),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ContactScreen()),
                  );
                },
                child: const Text('Contact'),
              ),
            ],
          ),
          const Divider(color: Colors.white24),
          const SizedBox(height: 8),
          const Text(
            '© 2026 DUM YANI. All rights reserved.',
            style: TextStyle(color: Colors.white54, fontSize: 9),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo/dum_yani_logo.png',
                      width: 52,
                      height: 52,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          width: 52,
                          height: 52,
                          child: Icon(
                            Icons.restaurant,
                            color: AppColors.primary,
                            size: 30,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'DUM-YANI',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.1,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'SLOW-COOKED GOODNESS',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.darkBrown,
                              fontSize: 8,
                              letterSpacing: 1.25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'My Wishlist',
                      onPressed: openWishlist,
                      icon: AnimatedBuilder(
                        animation: WishlistProvider.instance,
                        builder: (context, _) {
                          final count = WishlistProvider.instance.itemCount;
                          return Badge(
                            label: Text('$count'),
                            isLabelVisible: count > 0,
                            child: const Icon(
                              Icons.favorite_border_rounded,
                              color: AppColors.darkBrown,
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: openCart,
                      icon: AnimatedBuilder(
                        animation: CartProvider.instance,
                        builder: (context, _) {
                          return Badge(
                            label: Text('${CartProvider.instance.itemCount}'),
                            isLabelVisible: CartProvider.instance.itemCount > 0,
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: AppColors.darkBrown,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(child: heroCard()),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 25, 18, 0),
                child: categorySection(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                child: advanceBookingCard(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
                child: storyCard(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 30, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionHeading('The DUM YANI family', 'Pick your box.'),
                    const SizedBox(height: 8),
                    const Text(
                      'Choose the portion that suits your appetite.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        boxCard(
                          name: 'Taster',
                          weight: '350',
                          size: '500 ml box',
                          detail: 'A light meal for the in-between moments.',
                          featured: false,
                        ),
                        const SizedBox(width: 10),
                        boxCard(
                          name: 'Supertaster',
                          weight: '500',
                          size: '700 ml box',
                          detail: 'A proper, satisfying meal.',
                          featured: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 11),
                    const Text(
                      'Made with desi ghee, long-grain basmati and our own spice blend.',
                      style: TextStyle(
                        fontSize: 9,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 31, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionHeading(
                      'Old recipe. New precision.',
                      'The magic is in the wait.',
                    ),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        processTile(
                          Icons.auto_awesome_outlined,
                          'Made with intention',
                          'Carefully measured ingredients in every batch.',
                        ),
                        const SizedBox(width: 8),
                        processTile(
                          Icons.access_time,
                          'Sealed for the dum',
                          'Flavours and aromas stay right where they belong.',
                        ),
                        const SizedBox(width: 8),
                        processTile(
                          Icons.soup_kitchen_outlined,
                          'Opened for you',
                          'Served hot and ready to savour.',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                child: menuPromoCard(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 25),
                child: biryaniMomentsSection(),
              ),
            ),
            SliverToBoxAdapter(child: footer()),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: CartProvider.instance,
        builder: (context, _) => PremiumBottomNavBar(
          selectedIndex: 0,
          cartCount: CartProvider.instance.itemCount,
          onDestinationSelected: (index) {
            if (index == 1) {
              openMenu();
            } else if (index == 2) {
              openCart();
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
              );
            } else if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            }
          },
        ),
      ),
    );
  }
}

class _PromisePoint extends StatelessWidget {
  const _PromisePoint({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 17),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.darkBrown,
              fontSize: 9,
              height: 1.25,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
