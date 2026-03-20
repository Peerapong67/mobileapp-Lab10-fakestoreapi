import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'login_screen.dart';
import 'user_edit_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<UserProvider>();
    Future.microtask(() => provider.fetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel (User Management)"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            ),
          )
        ],
      ),
      body: userProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userProvider.users.length,
              itemBuilder: (ctx, i) {
                final user = userProvider.users[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(child: Text("${user.id}")),
                    title: Text("${user.name.firstname} ${user.name.lastname}"),
                    subtitle: Text(
                      "Username: ${user.username}\nEmail: ${user.email}",
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          tooltip: 'แก้ไข',
                          onPressed: () => Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) => UserEditScreen(user: user),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'ลบ',
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: ctx,
                              builder: (_) => AlertDialog(
                                title: const Text('ยืนยันการลบ'),
                                content: Text('ต้องการลบ "${user.name.firstname} ${user.name.lastname}" ใช่หรือไม่?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('ยกเลิก')),
                                  TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('ลบ', style: TextStyle(color: Colors.red))),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              if (!ctx.mounted) return;
                              final success = await ctx.read<UserProvider>().deleteUser(user.id);
                              if (!ctx.mounted) return;
                              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                                content: Text(success ? 'ลบผู้ใช้สำเร็จ' : 'เกิดข้อผิดพลาด'),
                                backgroundColor: success ? Colors.green : Colors.red,
                              ));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
