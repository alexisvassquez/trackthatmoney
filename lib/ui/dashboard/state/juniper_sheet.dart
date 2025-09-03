import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';

/// Track That Money
/// lib/ui/dashboard/state/juniper_sheet.dart

class _JuniperSheet extended StatefulWidget {
  final ScrollController scrollController;
  const _JuniperSheet({required this.scrollController});
  @override State<_JuniperSheet> createState () => _JuniperSheetState();
}

enum _Role { user, assistant }
class _ChatMessage {
  final _Role role;
  final String text;
  const _ChatMessage({required this.role, required this.text});
}

class _JuniperSheetState extends State<_JuniperSheet> {
  final _controller = TextEditingController();
  final List<_ChatMessage> _messages = const [
    _ChatMessage(
      role: _Role.assistant,
      text: "Hi! I'm Juniper2.0. How can I help with your budget today? 🙂",
    ),
  ];

  @override void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(.18),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circuler(999),
              ),
            ),
            SizedBox(height: 12),
            const ListTile(
              leading: Icon(Icons.smart_toy_outline),
              title: Text('Juniper2.0'),
              subtitle: Text('Your budgeting copilot'),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: widget.scrollController,
                reverse: true,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[_messages.length - 1 - index];
                  final isUser = msg.role == _Role.user;
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isUser ? cs.primaryContainer : cs.secondaryContainer,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cs.outlineVariant.withOpacity(.6)),
                      ),
                      child: Text(msg.text),
                    ),
                  );
                },
              ),
            ),
            const Divider (height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Ask me about budgets, goals, or tips...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(icon: const Icon(Icons.send_rounded), onPressed: _send),
                ],
              ),
            ),
          ],
        ),
      );
    }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      // FastAPI: POST /encourage + /predict
      setState(() => _messages.add(_ChatMessage(role: _Role.assistant, text:reply)));
    });    
  }
}
