import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../domain/entities/workout.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_card.dart';

class WorkoutPlayerScreen extends ConsumerStatefulWidget {
  final Workout workout;
  const WorkoutPlayerScreen({super.key, required this.workout});

  @override
  ConsumerState<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends ConsumerState<WorkoutPlayerScreen> {
  int _exIndex = 0;
  int _set = 1;
  bool _resting = false;
  bool _paused = false;
  int _restRemaining = 0;
  int _elapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _tick(Timer _) {
    if (_paused || !mounted) return;
    setState(() {
      _elapsed++;
      if (_resting) {
        _restRemaining--;
        if (_restRemaining <= 0) _resting = false;
      }
    });
  }

  WorkoutExercise get _current => widget.workout.exercises[_exIndex];

  void _completeSet() {
    final ex = _current;
    if (_set < ex.sets) {
      setState(() {
        _set++;
        _resting = true;
        _restRemaining = ex.restSeconds;
      });
    } else {
      if (_exIndex < widget.workout.exercises.length - 1) {
        setState(() {
          _exIndex++;
          _set = 1;
          _resting = true;
          _restRemaining = ex.restSeconds;
        });
      } else {
        _finish();
      }
    }
  }

  void _skipRest() => setState(() {
    _resting = false;
    _restRemaining = 0;
  });

  Future<void> _finish() async {
    _timer?.cancel();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [Icon(Icons.celebration, color: AppColors.pulseCyan), SizedBox(width: 10), Text('Great work!')],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total time: ${(_elapsed ~/ 60)}m ${_elapsed % 60}s'),
            Text('Estimated burned: ${widget.workout.estimatedCalories} kcal'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/home');
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ex = _current;
    final totalSets = widget.workout.exercises.fold<int>(0, (s, e) => s + e.sets);
    final doneSets = widget.workout.exercises.take(_exIndex).fold<int>(0, (s, e) => s + e.sets) + (_set - 1);
    final progress = totalSets == 0 ? 0.0 : doneSets / totalSets;

    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _topBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(AppColors.pulseCyan),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Exercise ${_exIndex + 1}/${widget.workout.exercises.length}'),
                    Text('${(_elapsed ~/ 60).toString().padLeft(2, '0')}:${(_elapsed % 60).toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontFeatures: [FontFeature.tabularFigures()],
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                ),
              ),
              Expanded(
                child: _resting ? _restView(ex) : _exerciseView(ex),
              ),
              _controls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _timer?.cancel();
              context.pop();
            },
            icon: const Icon(Icons.close),
          ),
          const Spacer(),
          Expanded(
            flex: 3,
            child: Text(
              widget.workout.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.music_note)),
        ],
      ),
    );
  }

  Widget _exerciseView(WorkoutExercise ex) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: GlassCard(
              padding: EdgeInsets.zero,
              radius: 28,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(colors: [
                        AppColors.pulseCyan.withOpacity(0.3),
                        AppColors.auroraViolet.withOpacity(0.3),
                      ]),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.fitness_center, size: 120, color: Colors.white.withOpacity(0.7)),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(begin: const Offset(1, 1), end: const Offset(1.08, 1.08), duration: 1200.ms),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(ex.exercise.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Set $_set / ${ex.sets}',
              style: const TextStyle(color: AppColors.pulseCyan, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            ex.exercise.isTimed
                ? '${ex.durationSeconds ?? 30} seconds'
                : '${ex.reps} reps',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w900, color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _restView(WorkoutExercise ex) {
    final pct = ex.restSeconds == 0 ? 0.0 : (ex.restSeconds - _restRemaining) / ex.restSeconds;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('REST', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 3, color: AppColors.pulseCyan)),
          const SizedBox(height: 20),
          CircularPercentIndicator(
            radius: 110,
            lineWidth: 14,
            percent: pct.clamp(0.0, 1.0),
            progressColor: AppColors.pulseCyan,
            backgroundColor: Colors.white12,
            circularStrokeCap: CircularStrokeCap.round,
            center: Text(
              '$_restRemaining',
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 24),
          Text('Next: ${ex.exercise.name}',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _skipRest,
            icon: const Icon(Icons.skip_next),
            label: const Text('Skip Rest'),
          ),
        ],
      ),
    );
  }

  Widget _controls() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
      child: Row(
        children: [
          _circleBtn(_paused ? Icons.play_arrow : Icons.pause, () => setState(() => _paused = !_paused)),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 64,
              child: ElevatedButton.icon(
                onPressed: _completeSet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pulseCyan,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                icon: const Icon(Icons.check_circle),
                label: const Text('Complete Set', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _circleBtn(Icons.skip_next, _completeSet),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64, height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, size: 28),
      ),
    );
  }
}
