// lib/screens/admin/book_edit_screen.dart
import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/admin_service.dart';

class BookEditScreen extends StatefulWidget {
  final Book? book; // null => add new

  const BookEditScreen({super.key, this.book});

  @override
  State<BookEditScreen> createState() => _BookEditScreenState();
}

class _BookEditScreenState extends State<BookEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleC;
  late final TextEditingController _authorC;
  late final TextEditingController _descC;
  late final TextEditingController _coverC;
  late final TextEditingController _genreC;
  late final TextEditingController _priceC;
  bool _bestseller = false;
  bool _newArrival = false;
  bool _featured = false;

  @override
  void initState() {
    super.initState();
    final b = widget.book;
    _titleC = TextEditingController(text: b?.title ?? '');
    _authorC = TextEditingController(text: b?.author ?? '');
    _descC = TextEditingController(text: b?.description ?? '');
    _coverC = TextEditingController(text: b?.coverImageUrl ?? '');
    _genreC = TextEditingController(text: b?.genre ?? '');
    _priceC = TextEditingController(text: b != null ? b.price.toString() : '');
    _bestseller = b?.isBestseller ?? false;
    _newArrival = b?.isNewArrival ?? false;
    _featured = b?.isFeatured ?? false;
  }

  @override
  void dispose() {
    _titleC.dispose();
    _authorC.dispose();
    _descC.dispose();
    _coverC.dispose();
    _genreC.dispose();
    _priceC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final book = Book(
      id: widget.book?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleC.text.trim(),
      author: _authorC.text.trim(),
      description: _descC.text.trim(),
      coverImageUrl: _coverC.text.trim(),
      genre: _genreC.text.trim(),
      price: double.tryParse(_priceC.text.trim()) ?? 0.0,
      rating: widget.book?.rating ?? 0.0,
      reviewCount: widget.book?.reviewCount ?? 0,
      isBestseller: _bestseller,
      isNewArrival: _newArrival,
      isFeatured: _featured,
      createdAt: widget.book?.createdAt ?? DateTime.now(),
    );
    

    try {
      if (widget.book == null) {
        await AdminService.addBook(book);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Book added')));
      } else {
        await AdminService.updateBook(book);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Book updated')));
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.book != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Book' : 'Add Book')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _titleC, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
              TextFormField(controller: _authorC, decoration: const InputDecoration(labelText: 'Author'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
              TextFormField(controller: _genreC, decoration: const InputDecoration(labelText: 'Genre')),
              TextFormField(controller: _priceC, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number, validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                return double.tryParse(v.trim()) == null ? 'Invalid price' : null;
              }),
             TextFormField(
  controller: _coverC,
  decoration: const InputDecoration(labelText: 'Cover Image URL'),
  onChanged: (_) => setState(() {}), // refresh preview when typing
),

const SizedBox(height: 12),

if (_coverC.text.trim().isNotEmpty)
  Center(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        _coverC.text.trim(),
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 80, color: Colors.grey),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    ),
  ),

              TextFormField(controller: _descC, decoration: const InputDecoration(labelText: 'Description'), maxLines: 4),
              SwitchListTile(
  title: const Text('Featured'),
  value: _featured,
  onChanged: (v) => setState(() => _featured = v),
),
              SwitchListTile(title: const Text('Bestseller'), value: _bestseller, onChanged: (v) => setState(() => _bestseller = v)),
              SwitchListTile(title: const Text('New Arrival'), value: _newArrival, onChanged: (v) => setState(() => _newArrival = v)),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _save, child: Text(isEdit ? 'Save changes' : 'Add book')),
            ],
          ),
        ),
      ),
    );
  }
}
