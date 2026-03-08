import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/product_provider.dart';
import '../product/product_detail_screen.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  double? _minPrice;
  double? _maxPrice;
  String? _selectedSort;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildFilters(context),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          _performSearch();
        },
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              context,
              label: _selectedCategory ?? 'Category',
              icon: Icons.category,
              onTap: () => _showCategoryFilter(),
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context,
              label: 'Price',
              icon: Icons.attach_money,
              onTap: () => _showPriceFilter(),
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context,
              label: _selectedSort ?? 'Sort',
              icon: Icons.sort,
              onTap: () => _showSortFilter(),
            ),
            if (_selectedCategory != null || _minPrice != null || _maxPrice != null || _selectedSort != null) ...[
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedCategory = null;
                    _minPrice = null;
                    _maxPrice = null;
                    _selectedSort = null;
                  });
                  _performSearch();
                },
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, {required String label, required IconData icon, required VoidCallback onTap}) {
    return FilterChip(
      label: Text(label),
      icon: Icon(icon, size: 18),
      onSelected: (_) => onTap(),
      selected: false,
    );
  }

  Widget _buildSearchResults() {
    final searchQuery = _searchController.text.trim();

    if (searchQuery.isEmpty) {
      return _buildRecentSearches();
    }

    return Consumer(
      builder: (context, ref, child) {
        final productState = ref.watch(productProvider);

        if (productState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (productState.errorMessage != null) {
          return Center(child: Text(productState.errorMessage!));
        }

        final products = productState.products;

        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No products found',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Try different keywords or filters',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _buildProductCard(products[index]);
          },
        );
      },
    );
  }

  Widget _buildRecentSearches() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Find what you\'re looking for',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Search for products, categories, or brands',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productId: product.id),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: product.imageUrls.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        child: Image.network(
                          product.imageUrls.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image, size: 48);
                          },
                        ),
                      )
                    : const Icon(Icons.image, size: 48),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: AppTheme.primaryYellow),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppConstants.currencySymbol}${product.price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
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

  void _performSearch() {
    final searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      ref.read(productProvider.notifier).searchProducts(
            query: searchQuery,
            category: _selectedCategory,
            minPrice: _minPrice,
            maxPrice: _maxPrice,
          );
    }
  }

  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Category',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: AppConstants.productCategories.length,
                itemBuilder: (context, index) {
                  final category = AppConstants.productCategories[index];
                  return ListTile(
                    title: Text(category),
                    trailing: _selectedCategory == category ? const Icon(Icons.check) : null,
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                      Navigator.pop(context);
                      _performSearch();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPriceFilter() {
    double min = _minPrice ?? 0;
    double max = _maxPrice ?? 100000;

    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Price Range',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Min: ${AppConstants.currencySymbol}${min.toStringAsFixed(0)} - Max: ${AppConstants.currencySymbol}${max.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 12),
                ),
                child: RangeSlider(
                  values: RangeValues(min, max),
                  min: 0,
                  max: 100000,
                  divisions: 100,
                  labels: RangeLabels(
                    '${min.toStringAsFixed(0)}',
                    '${max.toStringAsFixed(0)}',
                  ),
                  onChanged: (values) {
                    setModalState(() {
                      min = values.start;
                      max = values.end;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setModalState(() {
                          min = 0;
                          max = 100000;
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _minPrice = min;
                          _maxPrice = max;
                        });
                        Navigator.pop(context);
                        _performSearch();
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort By',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildSortOption('Newest', 'newest'),
            _buildSortOption('Price: Low to High', 'price_asc'),
            _buildSortOption('Price: High to Low', 'price_desc'),
            _buildSortOption('Rating', 'rating'),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: _selectedSort == value ? const Icon(Icons.check) : null,
      onTap: () {
        setState(() {
          _selectedSort = value;
        });
        Navigator.pop(context);
        _performSearch();
      },
    );
  }
}