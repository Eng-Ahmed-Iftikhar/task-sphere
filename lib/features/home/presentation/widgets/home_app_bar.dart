import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tasksphere/core/router/routes.dart';
import 'package:tasksphere/core/utils/dialogs/show_logout_dialog.dart';
import 'package:tasksphere/features/auth/presentation/providers/auth_providers.dart';
import 'package:tasksphere/features/todos/presentation/providers/todo_providers.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.asData?.value.user;
    final name = user?.name ?? "Guest User";
    final email = user?.email ?? "";
    final avatarUrl = user?.imgUrl;
    final themeMode = Theme.brightnessOf(context);
    final isDarkMode = themeMode == Brightness.dark;

    return AppBar(
      title: Row(
        children: const [
          Image(
            image: AssetImage("assets/images/logo_icon.png"),
            width: 24,
            height: 24,
          ),
          SizedBox(width: 8),
          Text("Task sphere", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          offset: const Offset(0, 45),
          onSelected: (value) async {
            switch (value) {
              case 'profile':
                context.pushNamed(RouteNames.profile);
                break;

              case 'logout':
                final islogout = await showLogoutDialog(context);
                if (islogout == true) {
                  await ref.read(todoProvider.notifier).reset();
                  await ref.read(authProvider.notifier).logout();
                }
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              enabled: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: avatarUrl != null
                            ? NetworkImage(avatarUrl)
                            : null,
                        child: avatarUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              email,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey, thickness: .5, height: 20),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person_outline, size: 18),
                  SizedBox(width: 8),
                  Text('Profile'),
                ],
              ),
            ),

            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Logout', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          icon: CircleAvatar(
            radius: 16,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
            child: avatarUrl == null
                ? const Icon(Icons.person, size: 18, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
