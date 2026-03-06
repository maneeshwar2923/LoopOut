import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/models/message_model.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/repositories/chat_repository.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String activityId;
  final String activityTitle;

  const ChatScreen({
    super.key,
    required this.activityId,
    required this.activityTitle,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() async {
     final text = _controller.text.trim();
     if (text.isEmpty) return;

     final user = ref.read(currentUserProvider);
     if (user == null) return;

     _controller.clear();

     await ref.read(chatRepositoryProvider).sendMessage(
       activityId: widget.activityId,
       text: text,
       senderId: user.uid,
       senderName: user.displayName ?? 'User',
       senderPhotoUrl: user.photoURL,
     );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(currentUserProvider);
    final messagesAsync = ref.watch(activityMessagesProvider(widget.activityId));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.activityTitle,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            Text(
              'GROUP CHAT',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.3),
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded, size: 48, color: colorScheme.onSurface.withValues(alpha: 0.1)),
                        const SizedBox(height: 16),
                        Text(
                          'BREAK THE ICE',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: colorScheme.onSurface.withValues(alpha: 0.2),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == user?.uid;
                    return _buildMessageBubble(context, message, isMe)
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuart);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
          
          // Input Area
          Container(
             padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
             decoration: BoxDecoration(
               color: colorScheme.surface,
               border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
             ),
             child: Row(
               children: [
                 Container(
                   decoration: BoxDecoration(
                     color: colorScheme.surfaceContainerHighest,
                     borderRadius: BorderRadius.circular(16),
                   ),
                   child: IconButton(
                     icon: Icon(Icons.add_rounded, color: colorScheme.primary),
                     onPressed: () {},
                   ),
                 ),
                 const SizedBox(width: 12),
                 Expanded(
                   child: Container(
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                     decoration: BoxDecoration(
                       color: colorScheme.surfaceContainerHighest,
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: TextField(
                       controller: _controller,
                       textCapitalization: TextCapitalization.sentences,
                       style: theme.textTheme.bodyLarge,
                       decoration: InputDecoration(
                         hintText: 'Say something...',
                         hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.2)),
                         border: InputBorder.none,
                         contentPadding: EdgeInsets.zero,
                       ),
                       onSubmitted: (_) => _sendMessage(),
                     ),
                   ),
                 ),
                 const SizedBox(width: 12),
                 GestureDetector(
                   onTap: _sendMessage,
                   child: Container(
                     padding: const EdgeInsets.all(12),
                     decoration: BoxDecoration(
                       color: colorScheme.primary,
                       shape: BoxShape.circle,
                       boxShadow: [
                         BoxShadow(
                           color: colorScheme.primary.withValues(alpha: 0.3),
                           blurRadius: 12,
                           offset: const Offset(0, 4),
                         ),
                       ],
                     ),
                     child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                   ),
                 ),
               ],
             ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, Message message, bool isMe) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeStr = "${message.createdAt.hour}:${message.createdAt.minute.toString().padLeft(2, '0')}";

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
             Container(
               width: 32,
               height: 32,
               decoration: BoxDecoration(
                 color: colorScheme.primary.withValues(alpha: 0.1),
                 shape: BoxShape.circle,
                 image: message.senderPhotoUrl != null ? DecorationImage(image: NetworkImage(message.senderPhotoUrl!), fit: BoxFit.cover) : null,
               ),
               child: message.senderPhotoUrl == null 
                  ? Center(child: Text(message.senderName[0].toUpperCase(), style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 10)))
                  : null,
             ),
             const SizedBox(width: 12),
          ],
          
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      message.senderName.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.3),
                        fontWeight: FontWeight.w900,
                        fontSize: 8,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMe ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isMe ? Colors.white : colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    timeStr,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.2),
                      fontSize: 8,
                    ),
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
