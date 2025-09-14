import 'package:book_store_app/screens/Auth/Login_screen.dart';
import 'package:book_store_app/screens/Auth/reset_password_screen.dart';
import 'package:book_store_app/screens/Auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'utils/app_colors.dart';
import 'utils/app_styles.dart';

// Import screens
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/orders/order_history_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

void main() {
  runApp(const BookstoreApp());
}

class BookstoreApp extends StatelessWidget {
  const BookstoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookstore App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.brown1,
        scaffoldBackgroundColor: AppColors.cream,
        textTheme: const TextTheme(
          bodyLarge: AppStyles.bodyText,
          bodyMedium: AppStyles.caption,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.brown2,
          foregroundColor: AppColors.white,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/reset': (context) => const ResetPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/wishlist': (context) => const WishlistScreen(),
        '/cart': (context) => const CartScreen(),
        '/orders': (context) => const OrderHistoryScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
      },
    );
  }
}
