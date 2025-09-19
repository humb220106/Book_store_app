import '../models/book.dart';

class CartService {
  static final List<Book> _cart = [];

  static void addToCart(Book book) {
    _cart.add(book);
  }

  static void removeFromCart(Book book) {
    _cart.remove(book);
  }

  static List<Book> getCartItems() {
    return List.unmodifiable(_cart);
  }

  static void clearCart() {
    _cart.clear();
  }
}