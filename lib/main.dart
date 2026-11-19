import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';
import 'providers/wishlist_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WishlistProvider.instance.loadWishlist();

  runApp(const DumYaniApp());
}

class DumYaniApp extends StatelessWidget {
  const DumYaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dum Yani',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
