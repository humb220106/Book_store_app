import 'package:flutter/material.dart';
import '../models/book_filter.dart';
import '../services/book_service.dart';

class FilterBottomSheet extends StatefulWidget {
  final BookFilter currentFilter;
  final Function(BookFilter) onApply;

  const FilterBottomSheet({
    Key? key,
    required this.currentFilter,
    required this.onApply,
  }) : super(key: key);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late bool bestsellersOnly;
  late bool newArrivalsOnly;
  double? minPrice;
  double? maxPrice;
  double? minRating;
  List<String> selectedGenres = [];
  List<String> selectedAuthors = [];

  List<String> allGenres = [];
  List<String> allAuthors = [];
  double minAvailablePrice = 0;
  double maxAvailablePrice = 100;

  @override
  void initState() {
    super.initState();
    bestsellersOnly = widget.currentFilter.bestsellersOnly;
    newArrivalsOnly = widget.currentFilter.newArrivalsOnly;
    minPrice = widget.currentFilter.minPrice;
    maxPrice = widget.currentFilter.maxPrice;
    minRating = widget.currentFilter.minRating;
    selectedGenres = widget.currentFilter.genres ?? [];
    selectedAuthors = widget.currentFilter.authors ?? [];

    _loadFilterData();
  }

  Future<void> _loadFilterData() async {
    final genres = await BookService.getAllGenres();
    final authors = await BookService.getAllAuthors();
    final priceRange = await BookService.getPriceRange();

    setState(() {
      allGenres = genres;
      allAuthors = authors;
      minAvailablePrice = priceRange['min'] ?? 0;
      maxAvailablePrice = priceRange['max'] ?? 100;
      minPrice ??= minAvailablePrice;
      maxPrice ??= maxAvailablePrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Filters",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Bestseller & New Arrival toggles
            SwitchListTile(
              title: const Text("Bestsellers only"),
              value: bestsellersOnly,
              onChanged: (val) => setState(() => bestsellersOnly = val),
            ),
            SwitchListTile(
              title: const Text("New arrivals only"),
              value: newArrivalsOnly,
              onChanged: (val) => setState(() => newArrivalsOnly = val),
            ),

            const SizedBox(height: 12),

            // Price Range
            Text(
                "Price Range: \$${minPrice?.toStringAsFixed(0)} - \$${maxPrice?.toStringAsFixed(0)}"),
            RangeSlider(
              values: RangeValues(minPrice ?? minAvailablePrice,
                  maxPrice ?? maxAvailablePrice),
              min: minAvailablePrice,
              max: maxAvailablePrice,
              divisions: 10,
              onChanged: (values) {
                setState(() {
                  minPrice = values.start;
                  maxPrice = values.end;
                });
              },
            ),

            const SizedBox(height: 12),

            // Rating filter
            Text("Minimum Rating: ${minRating?.toStringAsFixed(1) ?? "0.0"}"),
            Slider(
              value: minRating ?? 0,
              min: 0,
              max: 5,
              divisions: 5,
              label: (minRating ?? 0).toString(),
              onChanged: (val) {
                setState(() => minRating = val);
              },
            ),

            const SizedBox(height: 12),

            // Genre Selection
            const Text("Genres", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: allGenres.map((genre) {
                final selected = selectedGenres.contains(genre);
                return FilterChip(
                  label: Text(genre),
                  selected: selected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        selectedGenres.add(genre);
                      } else {
                        selectedGenres.remove(genre);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // Author Selection
            const Text("Authors", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: allAuthors.map((author) {
                final selected = selectedAuthors.contains(author);
                return FilterChip(
                  label: Text(author),
                  selected: selected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        selectedAuthors.add(author);
                      } else {
                        selectedAuthors.remove(author);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text("Reset"),
                  onPressed: () {
                    setState(() {
                      bestsellersOnly = false;
                      newArrivalsOnly = false;
                      minPrice = minAvailablePrice;
                      maxPrice = maxAvailablePrice;
                      minRating = 0;
                      selectedGenres.clear();
                      selectedAuthors.clear();
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text("Apply"),
                  onPressed: () {
                    final filter = BookFilter(
                      bestsellersOnly: bestsellersOnly,
                      newArrivalsOnly: newArrivalsOnly,
                      minPrice: minPrice,
                      maxPrice: maxPrice,
                      minRating: minRating,
                      genres: selectedGenres,
                      authors: selectedAuthors,
                    );
                    widget.onApply(filter);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
