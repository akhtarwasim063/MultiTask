import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../domain/entities/country_entity.dart';

class FlagQuizModal extends StatefulWidget {
  final List<CountryEntity> countries;

  const FlagQuizModal({super.key, required this.countries});

  static void show(BuildContext context, List<CountryEntity> countries) {
    if (countries.length < 4) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FlagQuizModal(countries: countries),
    );
  }

  @override
  State<FlagQuizModal> createState() => _FlagQuizModalState();
}

class _FlagQuizModalState extends State<FlagQuizModal> {
  int _score = 0;
  int _questionIndex = 0;
  final int _totalQuestions = 5;

  late CountryEntity _currentCountry;
  late List<String> _options;
  String? _selectedAnswer;
  bool _isAnswerChecked = false;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  void _loadQuestion() {
    if (widget.countries.length < 4) return;
    final countryPool = List<CountryEntity>.from(widget.countries)..shuffle();

    _currentCountry = countryPool[0];
    final optionPool = <String>{_currentCountry.commonName};

    for (int i = 1; i < countryPool.length && optionPool.length < 4; i++) {
      optionPool.add(countryPool[i].commonName);
    }

    _options = optionPool.toList()..shuffle();
    _selectedAnswer = null;
    _isAnswerChecked = false;
  }

  void _checkAnswer(String option) {
    if (_isAnswerChecked) return;
    setState(() {
      _selectedAnswer = option;
      _isAnswerChecked = true;
      if (option == _currentCountry.commonName) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_questionIndex + 1 < _totalQuestions) {
      setState(() {
        _questionIndex++;
        _loadQuestion();
      });
    } else {
      setState(() {
        _questionIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isGameOver = _questionIndex >= _totalQuestions;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.videogame_asset_rounded, color: Colors.amberAccent, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    context.tr('flag_quiz'),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),

          if (isGameOver)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_events_rounded, size: 72, color: Colors.amber),
                    const SizedBox(height: 16),
                    Text(
                      context.tr('quiz_complete'),
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${context.tr('score')}: $_score / $_totalQuestions',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _score = 0;
                          _questionIndex = 0;
                          _loadQuestion();
                        });
                      },
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('Play Again'),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Progress & Score Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${context.tr('question')} ${_questionIndex + 1} / $_totalQuestions',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${context.tr('score')}: $_score',
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Flag Display
            Center(
              child: Container(
                width: 180,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _currentCountry.flagPng,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.flag_rounded, size: 48),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Question Prompt
            Text(
              'Which country does this flag belong to?',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            // Options
            Expanded(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _options.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (ctx, idx) {
                  final option = _options[idx];
                  Color? tileColor;
                  BorderSide borderSide = BorderSide(
                    color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08),
                  );

                  if (_isAnswerChecked) {
                    if (option == _currentCountry.commonName) {
                      tileColor = Colors.green.withValues(alpha: 0.2);
                      borderSide = const BorderSide(color: Colors.greenAccent, width: 2);
                    } else if (option == _selectedAnswer) {
                      tileColor = Colors.red.withValues(alpha: 0.2);
                      borderSide = const BorderSide(color: Colors.redAccent, width: 2);
                    }
                  }

                  return GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    backgroundColor: tileColor,
                    border: Border.fromBorderSide(borderSide),
                    onTap: () => _checkAnswer(option),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + idx),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                        if (_isAnswerChecked && option == _currentCountry.commonName)
                          const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 20)
                        else if (_isAnswerChecked && option == _selectedAnswer)
                          const Icon(Icons.cancel_rounded, color: Colors.redAccent, size: 20),
                      ],
                    ),
                  );
                },
              ),
            ),

            if (_isAnswerChecked)
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text(context.tr('next')),
              ),
          ],
        ],
      ),
    );
  }
}
