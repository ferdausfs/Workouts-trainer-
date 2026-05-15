import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../widgets/common/animated_gradient_background.dart';
import '../../../core/theme/app_colors.dart';

class _ChatMsg {
  final String text;
  final bool fromUser;
  final DateTime time;
  _ChatMsg(this.text, this.fromUser) : time = DateTime.now();
}

class AICoachScreen extends ConsumerStatefulWidget {
  const AICoachScreen({super.key});

  @override
  ConsumerState<AICoachScreen> createState() => _AICoachScreenState();
}

class _AICoachScreenState extends ConsumerState<AICoachScreen> {
  final _msgs = <_ChatMsg>[
    _ChatMsg("Hi! I'm Pulse, your AI fitness coach. Ask me anything about training, nutrition, or recovery! 💪", false),
  ];
  final _ctrl = TextEditingController();
  bool _typing = false;

  final _quickPrompts = const [
    '💪 Suggest a quick workout',
    '🥗 Meal ideas under 500 kcal',
    '😴 Recovery tips',
    '🔥 How to break a plateau?',
  ];

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _msgs.add(_ChatMsg(text, true));
      _typing = true;
    });
    _ctrl.clear();

    await Future.delayed(const Duration(milliseconds: 800));
    final reply = _generateReply(text);
    if (!mounted) return;
    setState(() {
      _msgs.add(_ChatMsg(reply, false));
      _typing = false;
    });
  }

  String _generateReply(String prompt) {
    final p = prompt.toLowerCase();
    if (p.contains('workout') || p.contains('exercise')) {
      return "Great choice! Try this 20-min full-body burner: 🔥\n\n"
          "• 30s Jumping Jacks\n• 12 Push-ups\n• 15 Squats\n• 30s Plank\n• 10 Burpees\n\n"
          "Rest 30s between, repeat 3 rounds. You've got this!";
    }
    if (p.contains('meal') || p.contains('food') || p.contains('eat')) {
      return "Try this high-protein meal 🍽️:\n\n"
          "• 150g grilled chicken breast (248 kcal)\n• 1 cup brown rice (216 kcal)\n• Steamed broccoli (55 kcal)\n• 1 tsp olive oil (40 kcal)\n\n"
          "Total: ~559 kcal • 45g protein • Perfect for muscle recovery!";
    }
    if (p.contains('recovery') || p.contains('sleep') || p.contains('rest')) {
      return "Recovery is where gains happen! 💤\n\n"
          "1. Sleep 7-9 hours\n2. Stretch 10 min before bed\n3. Stay hydrated (35ml/kg body weight)\n4. Take a rest day every 3-4 training days\n5. Try foam rolling sore muscles";
    }
    if (p.contains('plateau')) {
      return "Plateaus are normal! Here's how to break through 💥:\n\n"
          "• Change rep ranges (try 5x5 if doing 3x12)\n• Add a deload week\n• Sleep more & eat enough protein (1.6-2.2g/kg)\n• Try new exercise variations\n• Track progressive overload weekly";
    }
    if (p.contains('motivat') || p.contains('lazy') || p.contains('tired')) {
      return "I hear you 💪 Some days are tough.\n\n"
          "Remember: showing up is 80% of success. Even 10 minutes is better than 0. "
          "Your future self will thank you. Let's start with just one exercise — what's your favorite?";
    }
    return "Awesome question! Based on your profile, I'd recommend focusing on consistency over intensity. "
        "Tell me more about your goal and I'll personalize advice for you! 🚀";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle, gradient: AppColors.primaryGradient,
                      ),
                      child: const Icon(Icons.psychology_rounded, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pulse AI',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                        Row(
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            const Text('Always ready', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _msgs.length + (_typing ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (_typing && i == _msgs.length) return _typingBubble();
                    return _bubble(_msgs[i]);
                  },
                ),
              ),
              if (_msgs.length <= 2) _quickPromptsBar(),
              _inputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bubble(_ChatMsg m) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: m.fromUser ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: m.fromUser ? AppColors.primaryGradient : null,
              color: m.fromUser ? null : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(m.fromUser ? 18 : 4),
                bottomRight: Radius.circular(m.fromUser ? 4 : 18),
              ),
            ),
            child: Text(m.text,
                style: TextStyle(color: m.fromUser ? Colors.white : null, height: 1.4)),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.1);
  }

  Widget _typingBubble() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < 3; i++)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.pulseCyan, shape: BoxShape.circle))
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(delay: Duration(milliseconds: i * 150), duration: 500.ms,
                          begin: const Offset(0.6, 0.6), end: const Offset(1, 1)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _stripLeadingEmoji(String s) {
    // Strip leading non-letter (emoji + spaces) characters safely.
    final runes = s.runes.toList();
    int i = 0;
    while (i < runes.length) {
      final r = runes[i];
      final isLetter = (r >= 0x41 && r <= 0x5A) || (r >= 0x61 && r <= 0x7A);
      if (isLetter) break;
      i++;
    }
    return String.fromCharCodes(runes.sublist(i)).trim();
  }

  Widget _quickPromptsBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _quickPrompts.map((p) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => _send(_stripLeadingEmoji(p)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.pulseCyan.withOpacity(0.3)),
              ),
              child: Text(p, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _inputBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).padding.bottom + 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _ctrl,
              onSubmitted: _send,
              decoration: InputDecoration(
                hintText: 'Ask your coach...',
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
                filled: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _send(_ctrl.text),
            child: Container(
              width: 48, height: 48,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
