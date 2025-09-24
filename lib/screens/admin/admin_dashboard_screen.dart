import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../models/user_model.dart';
import '../../services/admin_service.dart';
import 'book_edit_screen.dart' as book_edit;
import 'order_management_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final String email;

  const AdminDashboardScreen({super.key, required this.email});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _logout() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.email != "admin@bookapp.com") {
      return const Scaffold(
        body: Center(
          child: Text("❌ You are not authorized to view this page."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Books'),
            Tab(text: 'Users'),
            Tab(text: 'Orders'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(12),
            child: Text(
              'Welcome, ${widget.email}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _booksTab(),
                _usersTab(),
                const OrderManagementScreen(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const book_edit.BookEditScreen()),
          );
        },
        tooltip: 'Add Book',
        child: const Icon(Icons.add),
      ),
    );
  }

  // 📚 Books tab
  Widget _booksTab() {
    return StreamBuilder<List<Book>>(
      stream: AdminService.booksStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final books = snapshot.data ?? [];
        if (books.isEmpty) return const Center(child: Text('No books yet.'));
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: books.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, i) {
            final b = books[i];
            return ListTile(
              leading: b.coverImageUrl.isNotEmpty
                  ? Image.network(b.coverImageUrl, width: 48, fit: BoxFit.cover)
                  : const Icon(Icons.book),
              title: Text(b.title),
              subtitle: Text('${b.author} • ${b.genre}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => book_edit.BookEditScreen(book: b),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('Delete book?'),
                          content: Text(
                            'Delete "${b.title}"? This cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(c, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(c, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (ok == true) {
                        await AdminService.deleteBook(b.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Book deleted')),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 👤 Users tab
  Widget _usersTab() {
    return StreamBuilder<List<UserModel>>(
      stream: AdminService.usersStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final users = snapshot.data ?? [];
        if (users.isEmpty) {
          return const Center(child: Text('No user documents found.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: users.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, i) {
            final u = users[i];
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(u.displayName ?? u.email ?? u.uid),
              subtitle: Text(
                'uid: ${u.uid}\nWishlist: ${u.wishlist.length} • Cart: ${u.cart.length}',
              ),
              isThreeLine: true,
              trailing: PopupMenuButton<String>(
                onSelected: (v) async {
                  if (v == 'delete') {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text('Delete user document?'),
                        content: Text(
                          'Delete Firestore user doc for ${u.email ?? u.uid}?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(c, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(c, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (ok == true) {
                      await AdminService.deleteUserDoc(u.uid);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User document deleted')),
                      );
                    }
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete user doc'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
