import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/notification_model.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// Screen 6 — Notifications.
///
/// Demonstrates the list-view requirement with:
///   - Read / unread visual distinction
///   - Empty state when the list is clear
///   - Live-region semantics so screen readers announce changes
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  String _age(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24)   return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final notes    = appState.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (appState.unreadCount > 0)
            Semantics(
              label: 'Mark all notifications as read',
              button: true,
              child: TextButton(
                onPressed: () =>
                    context.read<AppState>().markAllRead(),
                child: const Text('Mark all read',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
        ],
      ),
      body: notes.isEmpty
          ? const _EmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _NotifTile(
                note: notes[i],
                age: _age(notes[i].timestamp),
                onTap: () =>
                    context.read<AppState>().markRead(notes[i].id),
              ),
            ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final NotificationModel note;
  final String age;
  final VoidCallback onTap;
  const _NotifTile(
      {required this.note, required this.age, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final unread = !note.isRead;

    return Semantics(
      button: true,
      label: '${note.title}. ${note.body}. $age.'
          '${unread ? " Unread." : " Already read."}',
      child: Material(
        color: unread
            ? AppTheme.primaryContainer
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        elevation: unread ? 0 : 1,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Unread indicator dot
                Container(
                  width: 10, height: 10,
                  margin: const EdgeInsets.only(top: 5, right: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        unread ? AppTheme.primary : Colors.transparent,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(note.title,
                          style: TextStyle(
                            fontWeight: unread
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 15,
                          )),
                      const SizedBox(height: 4),
                      Text(note.body,
                          style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                              height: 1.4)),
                      const SizedBox(height: 6),
                      Text(age,
                          style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.notifications_none_rounded,
                size: 72, color: AppTheme.textSecondary),
            const SizedBox(height: 16),
            Text('No notifications yet.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}
