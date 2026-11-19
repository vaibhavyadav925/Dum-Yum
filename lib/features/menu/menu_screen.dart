import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../cart/cart_screen.dart';
import '../food_details/food_details_screen.dart';
import '../orders/order_history_screen.dart';
import '../profile/profile_screen.dart';
import '../wishlist/wishlist_screen.dart';
import '../../widgets/premium_bottom_nav_bar.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedCategory = 0;
  String searchQuery = '';
  String selectedSort = 'Recommended';
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> biryanis = [
    {
      'name': 'Chicken Biryani, Bone-in · Supertaster (500 g)',
      'categoryName': 'CHICKEN BIRYANI (WITH BONE)',
      'description':
          '2 leg pieces + 1 egg, long-grain basmati, sealed and cooked on dum.',
      'price': 549,
      'rating': '4.9',
      'isVeg': false,
      'category': 'Chicken',
      'image': 'assets/images/biryani/chicken_biryani.jpg',
    },
    {
      'name': 'Chicken Biryani, Boneless · Taster (350 g)',
      'categoryName': 'CHICKEN BIRYANI (BONELESS)',
      'description': '80 g thigh meat + 1 egg, long-grain basmati, sealed and cooked on dum.',
      'price': 200,
      'rating': '4.8',
      'isVeg': false,
      'category': 'Chicken',
      'image': 'assets/images/biryani/chicken_biryani.jpg',
    },
    {
      'name': 'Paneer Biryani · Taster (350 g)',
      'categoryName': 'PANEER BIRYANI',
      'description': '100 g full-cream paneer, long-grain basmati, sealed and cooked on dum.',
      'price': 200,
      'rating': '4.8',
      'isVeg': true,
      'category': 'Veg',
      'image': 'assets/images/biryani/veg_biryani.jpg',
    },
    {
      'name': 'Chicken Biryani, Bone-in · Taster (350 g)',
      'categoryName': 'CHICKEN BIRYANI (WITH BONE)',
      'description':
          '1 leg piece + 1 egg, long-grain basmati, sealed and cooked on dum.',
      'price': 180,
      'rating': '4.8',
      'isVeg': false,
      'category': 'Chicken',
      'image': 'assets/images/biryani/chicken_biryani.jpg',
    },
    {
      'name': 'Chicken Biryani, Boneless · Supertaster (500 g)',
      'categoryName': 'CHICKEN BIRYANI (BONELESS)',
      'description': '120 g thigh meat + 1 egg, long-grain basmati, sealed and cooked on dum.',
      'price': 280,
      'rating': '4.9',
      'isVeg': false,
      'category': 'Chicken',
      'image': 'assets/images/biryani/chicken_biryani.jpg',
    },
    {
      'name': 'Mutton Biryani - Bulk Order (5 kg)',
      'categoryName': 'MUTTON BIRYANI',
      'description': 'A 5 kg handi of mutton dum biryani for parties and family gatherings.',
      'price': 5000,
      'rating': '4.9',
      'isVeg': false,
      'category': 'Mutton',
      'image': 'assets/images/biryani/mutton_biryani.jpg',
    },
    {
      'name': 'Soya Biryani · Taster (350 g)',
      'categoryName': 'SOYA BIRYANI',
      'description': '100 g high-protein soya chunks, long-grain basmati, sealed and cooked on dum.',
      'price': 150,
      'rating': '4.7',
      'isVeg': true,
      'category': 'Veg',
      'image': 'assets/images/biryani/veg_biryani.jpg',
    },
    {
      'name': 'Egg Biryani · Taster (350 g)',
      'categoryName': 'EGG BIRYANI',
      'description': '2 high-protein desi eggs, long-grain basmati, sealed and cooked on dum.',
      'price': 120,
      'rating': '4.7',
      'isVeg': false,
      'category': 'Egg',
      'image': 'assets/images/biryani/egg_biryani.jpg',
    },
  ];

  List<Map<String, dynamic>> get filteredBiryanis {
    const categories = ['All', 'Chicken', 'Mutton', 'Veg', 'Egg'];

    final results = biryanis.where((item) {
      final categoryMatches =
          selectedCategory == 0 ||
          item['category'] == categories[selectedCategory];
      final query = searchQuery.trim().toLowerCase();
      final searchMatches =
          query.isEmpty ||
          item['name'].toString().toLowerCase().contains(query) ||
          item['description'].toString().toLowerCase().contains(query);
      return categoryMatches && searchMatches;
    }).toList();

    switch (selectedSort) {
      case 'Price: Low to high':
        results.sort(
          (a, b) => (a['price'] as num).compareTo(b['price'] as num),
        );
        break;
      case 'Price: High to low':
        results.sort(
          (a, b) => (b['price'] as num).compareTo(a['price'] as num),
        );
        break;
      case 'Top rated':
        results.sort(
          (a, b) => (double.tryParse(b['rating'].toString()) ?? 0).compareTo(
            double.tryParse(a['rating'].toString()) ?? 0,
          ),
        );
        break;
    }
    return results;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _availableSizes(Map<String, dynamic> item) {
    final categoryName = item['categoryName']?.toString();
    if (categoryName == null) return [item];

    // Show only sizes that actually exist in the menu data for this biryani.
    final variants = biryanis.where((product) {
      return product['categoryName'] == categoryName &&
          (product['name'].toString().contains('Taster') ||
              product['name'].toString().contains('Supertaster'));
    }).toList();

    variants.sort((a, b) {
      final aIsTaster = a['name'].toString().contains('Taster (');
      final bIsTaster = b['name'].toString().contains('Taster (');
      if (aIsTaster == bIsTaster) return 0;
      return aIsTaster ? -1 : 1;
    });

    return variants.isEmpty ? [item] : variants;
  }

  void _putItemInCart(Map<String, dynamic> item, int quantity) {
    CartProvider.instance.addItem(
      name: item['name'],
      description: item['description'],
      image: item['image'],
      price: item['price'],
      rating: item['rating'],
      isVeg: item['isVeg'],
      quantity: quantity,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} added to cart'),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> addToCart(Map<String, dynamic> item) async {
    // Bulk orders already have a fixed pack size, so add them directly.
    if (item['category'] == 'Mutton') {
      _putItemInCart(item, 1);
      return;
    }

    final sizes = _availableSizes(item);
    Map<String, dynamic> selectedItem = sizes.firstWhere(
      (product) => product['name'] == item['name'],
      orElse: () => sizes.first,
    );
    int quantity = 1;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final total = (selectedItem['price'] as num) * quantity;

            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 520,
                  maxHeight: 680,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 16, 10, 12),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Customize your biryani',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: AppColors.darkBrown,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: Image.asset(
                                selectedItem['image'],
                                height: 155,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 155,
                                  color: AppColors.border,
                                  child: const Icon(Icons.restaurant, size: 48),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              selectedItem['categoryName'] ??
                                  'DUM YANI SPECIAL',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 10,
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              selectedItem['name']
                                  .toString()
                                  .split(' · ')
                                  .first,
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBrown,
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Select your box',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.darkBrown,
                              ),
                            ),
                            const SizedBox(height: 9),
                            ...sizes.map((size) {
                              final isSelected =
                                  size['name'] == selectedItem['name'];
                              final isTaster = size['name'].toString().contains(
                                'Taster (',
                              );
                              final sizeLabel = isTaster
                                  ? 'Taster'
                                  : 'Supertaster';
                              final weight = isTaster
                                  ? '350 g · 500 ml box'
                                  : '500 g · 700 ml box';

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 9),
                                child: InkWell(
                                  onTap: () =>
                                      setDialogState(() => selectedItem = size),
                                  borderRadius: BorderRadius.circular(13),
                                  child: Container(
                                    padding: const EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.border,
                                        width: isSelected ? 2 : 1,
                                      ),
                                      color: isSelected
                                          ? AppColors.primary.withValues(
                                              alpha: 0.06,
                                            )
                                          : Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isSelected
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_off,
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                sizeLabel,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.darkBrown,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                weight,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                              Text(
                                                size['description'],
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '₹${size['price']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.darkBrown,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Quantity',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: quantity > 1
                                      ? () => setDialogState(() => quantity--)
                                      : null,
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      setDialogState(() => quantity++),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                      child: SizedBox(
                        width: double.infinity,
                        height: 49,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            _putItemInCart(selectedItem, quantity);
                          },
                          child: Text(
                            '₹$total  |  ADD ITEM',
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void openFoodDetails(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodDetailsScreen(
          name: item['name'],
          description: item['description'],
          image: item['image'],
          price: item['price'],
          rating: item['rating'],
          isVeg: item['isVeg'],
          category: item['categoryName'] ?? item['category'], // ADD THIS LINE
          onAddToCart: (quantity) {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void openCart() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const CartScreen()),
  );

  void openWishlist() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const WishlistScreen()),
  );

  @override
  Widget build(BuildContext context) {
    const categories = ['All', 'Chicken', 'Mutton', 'Veg', 'Egg'];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Our Menu',
          style: TextStyle(
            fontFamily: 'serif',
            fontWeight: FontWeight.bold,
            color: AppColors.darkBrown,
          ),
        ),
        actions: [
          AnimatedBuilder(
            animation: WishlistProvider.instance,
            builder: (context, _) => IconButton(
              tooltip: 'My Wishlist',
              onPressed: openWishlist,
              icon: Badge(
                label: Text('${WishlistProvider.instance.itemCount}'),
                isLabelVisible: WishlistProvider.instance.itemCount > 0,
                child: const Icon(
                  Icons.favorite_border,
                  color: AppColors.darkBrown,
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: CartProvider.instance,
            builder: (context, _) => IconButton(
              onPressed: openCart,
              icon: Badge(
                label: Text('${CartProvider.instance.itemCount}'),
                isLabelVisible: CartProvider.instance.itemCount > 0,
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.darkBrown,
                ),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Slow-cooked goodness.',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Find your favourite Dum Yani handi.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: searchController,
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search biryani...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                searchController.clear();
                                setState(() => searchQuery = '');
                              },
                              icon: const Icon(Icons.close),
                            ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 42,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(categories.length, (index) {
                        final selected = selectedCategory == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(categories[index]),
                            selected: selected,
                            onSelected: (_) =>
                                setState(() => selectedCategory = index),
                            selectedColor: AppColors.primary,
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            side: BorderSide(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                            showCheckmark: false,
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Our Biryani Selection',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${filteredBiryanis.length} items',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        'Sort by',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedSort,
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Recommended',
                              child: Text('Recommended'),
                            ),
                            DropdownMenuItem(
                              value: 'Price: Low to high',
                              child: Text('Price: Low to high'),
                            ),
                            DropdownMenuItem(
                              value: 'Price: High to low',
                              child: Text('Price: High to low'),
                            ),
                            DropdownMenuItem(
                              value: 'Top rated',
                              child: Text('Top rated'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => selectedSort = value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = filteredBiryanis[index];
                return AnimatedBuilder(
                  animation: WishlistProvider.instance,
                  builder: (context, _) {
                    final isFavourite = WishlistProvider.instance.isWishlisted(
                      item['name'].toString(),
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 17),
                      child: _PremiumMenuCard(
                        item: item,
                        isFavourite: isFavourite,
                        onFavourite: () {
                          WishlistProvider.instance.toggleItem(item);
                        },
                        onAdd: () => addToCart(item),
                        onDetails: () => openFoodDetails(item),
                      ),
                    );
                  },
                );
              }, childCount: filteredBiryanis.length),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: CartProvider.instance,
        builder: (context, _) => PremiumBottomNavBar(
          selectedIndex: 1,
          cartCount: CartProvider.instance.itemCount,
          onDestinationSelected: (index) {
            if (index == 2) {
              openCart();
            } else if (index == 0) {
              Navigator.pop(context);
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
              );
            } else if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            }
          },
        ),
      ),
    );
  }
}

class _PremiumMenuCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isFavourite;
  final VoidCallback onFavourite;
  final VoidCallback onAdd;
  final VoidCallback onDetails;

  const _PremiumMenuCard({
    required this.item,
    required this.isFavourite,
    required this.onFavourite,
    required this.onAdd,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.055),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 218,
                width: double.infinity,
                child: Image.asset(
                  item['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.border,
                    child: const Icon(
                      Icons.restaurant,
                      size: 55,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 13,
                right: 13,
                child: Material(
                  color: Colors.white.withValues(alpha: 0.96),
                  shape: const CircleBorder(),
                  child: IconButton(
                    onPressed: onFavourite,
                    icon: Icon(
                      isFavourite ? Icons.favorite : Icons.favorite_border,
                      color: isFavourite ? Colors.red : AppColors.primary,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 13,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.58),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['isVeg'] ? Icons.eco : Icons.local_fire_department,
                        color: Colors.white,
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        item['isVeg'] ? 'VEG' : 'NON-VEG',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 15, 17, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['categoryName'],
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 21,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['description'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 13),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '₹${item['price']}',
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: onAdd,
                      icon: const Icon(Icons.add, size: 17),
                      label: const Text('ADD'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 17,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                InkWell(
                  onTap: onDetails,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View details',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 7),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: AppColors.textSecondary,
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
}
