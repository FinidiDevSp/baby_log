import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import 'package:baby_log/core/providers.dart';
import 'package:baby_log/core/theme/app_colors.dart';
import 'package:baby_log/core/utils/baby_age_formatter.dart';
import 'package:baby_log/domain/entities/baby_profile.dart';
import 'package:baby_log/domain/entities/pediatrician_question.dart';
import 'package:baby_log/l10n/app_localizations.dart';

import 'state/pediatrician_questions_provider.dart';

class PediatricianQuestionsPage extends ConsumerStatefulWidget {
  const PediatricianQuestionsPage({super.key});

  @override
  ConsumerState<PediatricianQuestionsPage> createState() =>
      _PediatricianQuestionsPageState();
}

class _PediatricianQuestionsPageState
    extends ConsumerState<PediatricianQuestionsPage> {
  late final TextEditingController _questionController;
  bool _isSaving = false;
  bool _isSharing = false;
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();
    _questionController.addListener(_handleQuestionChanged);
  }

  @override
  void dispose() {
    _questionController.removeListener(_handleQuestionChanged);
    _questionController.dispose();
    super.dispose();
  }

  void _handleQuestionChanged() {
    final shouldEnable = _questionController.text.trim().isNotEmpty;
    if (shouldEnable != _canSubmit) {
      setState(() {
        _canSubmit = shouldEnable;
      });
    }
  }

  Future<void> _saveQuestion() async {
    final l10n = AppLocalizations.of(context);
    final text = _questionController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.questionsValidationMessage)));
      return;
    }

    final repository = ref.read(pediatricianQuestionRepositoryProvider);
    final now = DateTime.now();

    setState(() {
      _isSaving = true;
    });

    try {
      await repository.addQuestion(
        PediatricianQuestion(
          content: text,
          isResolved: false,
          createdAt: now,
          updatedAt: now,
        ),
      );
      _questionController.clear();
      FocusScope.of(context).unfocus();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.questionsSaveError('$error'))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _toggleResolved(PediatricianQuestion question) async {
    final repository = ref.read(pediatricianQuestionRepositoryProvider);
    final l10n = AppLocalizations.of(context);

    try {
      await repository.updateQuestion(
        question.copyWith(isResolved: !question.isResolved),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.questionsUpdateError('$error'))),
      );
    }
  }

  Future<void> _deleteQuestion(PediatricianQuestion question) async {
    final repository = ref.read(pediatricianQuestionRepositoryProvider);
    final l10n = AppLocalizations.of(context);
    final id = question.id;
    if (id == null) {
      return;
    }

    try {
      await repository.deleteQuestion(id);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.questionsDeleteError('$error'))),
      );
    }
  }

  Future<void> _editQuestion(PediatricianQuestion question) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: question.content);

    final updatedText = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.questionsEditDialogTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 4,
            minLines: 1,
            decoration: InputDecoration(
              labelText: l10n.questionsEditDialogLabel,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.questionsEditDialogCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text(l10n.questionsEditDialogSave),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (updatedText == null) {
      return;
    }

    final trimmed = updatedText.trim();
    if (trimmed.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.questionsValidationMessage)));
      return;
    }

    final repository = ref.read(pediatricianQuestionRepositoryProvider);

    try {
      await repository.updateQuestion(question.copyWith(content: trimmed));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.questionsUpdateError('$error'))),
      );
    }
  }

  Future<void> _sharePendingQuestions(
    List<PediatricianQuestion> pending,
    BabyProfile? baby,
  ) async {
    if (pending.isEmpty || _isSharing) {
      return;
    }

    final l10n = AppLocalizations.of(context);
    setState(() {
      _isSharing = true;
    });

    try {
      final doc = pw.Document();
      final locale = l10n.localeName;
      final dateFormat = DateFormat('d MMM y, HH:mm', locale);

      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return [
              pw.Text(
                l10n.questionsShareTitle,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              ...pending.map((question) {
                final ageLabel = formatBabyAgeAt(
                  l10n,
                  baby,
                  question.createdAt,
                );
                final details = [
                  dateFormat.format(question.createdAt),
                  if (ageLabel != null) ageLabel else l10n.questionsAgeUnknown,
                ].join(' • ');
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        question.content,
                        style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(details, style: const pw.TextStyle(fontSize: 11)),
                    ],
                  ),
                );
              }),
            ];
          },
        ),
      );

      final bytes = await doc.save();
      final directory = await getTemporaryDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File('${directory.path}/preguntas_pediatra_$timestamp.pdf');
      await file.writeAsBytes(bytes, flush: true);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: l10n.questionsShareMessage);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.questionsShareError('$error'))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final questionsAsync = ref.watch(pediatricianQuestionsProvider);
    final babyAsync = ref.watch(babyStreamProvider);
    final baby = babyAsync.value;

    final questions = questionsAsync.value ?? const <PediatricianQuestion>[];
    final pendingQuestions = questions
        .where((question) => !question.isResolved)
        .toList();
    final resolvedQuestions = questions
        .where((question) => question.isResolved)
        .toList();

    final locale = l10n.localeName;
    final dateFormat = DateFormat('d MMM y, HH:mm', locale);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        title: Text(l10n.questionsTitle),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.share2),
            tooltip: l10n.questionsShareTooltip,
            onPressed: !_isSharing && pendingQuestions.isNotEmpty
                ? () => _sharePendingQuestions(pendingQuestions, baby)
                : null,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            Center(
              child: Hero(
                tag: 'questions_shortcut',
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    LucideIcons.messageCircleQuestionMark,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _QuestionComposer(
              controller: _questionController,
              onSubmit: _saveQuestion,
              isSaving: _isSaving,
              canSubmit: _canSubmit,
            ),
            const SizedBox(height: 24),
            if (questionsAsync.isLoading && questions.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (questionsAsync.hasError && questions.isEmpty)
              _ErrorPlaceholder(message: l10n.questionsLoadError)
            else if (questions.isEmpty)
              _EmptyQuestionsPlaceholder(accentColor: theme.colorScheme.primary)
            else ...[
              if (pendingQuestions.isNotEmpty) ...[
                Text(
                  l10n.questionsPendingSection,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                ...pendingQuestions.map(
                  (question) => _QuestionTile(
                    question: question,
                    dateFormat: dateFormat,
                    baby: baby,
                    onToggle: () => _toggleResolved(question),
                    onEdit: () => _editQuestion(question),
                    onDelete: () => _deleteQuestion(question),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              if (resolvedQuestions.isNotEmpty) ...[
                Text(
                  l10n.questionsResolvedSection,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                ...resolvedQuestions.map(
                  (question) => _QuestionTile(
                    question: question,
                    dateFormat: dateFormat,
                    baby: baby,
                    onToggle: () => _toggleResolved(question),
                    onEdit: () => _editQuestion(question),
                    onDelete: () => _deleteQuestion(question),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _QuestionComposer extends StatelessWidget {
  const _QuestionComposer({
    required this.controller,
    required this.onSubmit,
    required this.isSaving,
    required this.canSubmit,
  });

  final TextEditingController controller;
  final Future<void> Function() onSubmit;
  final bool isSaving;
  final bool canSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.questionsComposerTitle, style: theme.textTheme.titleSmall),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 4,
            minLines: 1,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText: l10n.questionsComposerPlaceholder,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: !canSubmit || isSaving ? null : onSubmit,
              icon: isSaving
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : const Icon(LucideIcons.plus),
              label: Text(l10n.questionsComposerAction),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  const _QuestionTile({
    required this.question,
    required this.dateFormat,
    required this.baby,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final PediatricianQuestion question;
  final DateFormat dateFormat;
  final BabyProfile? baby;
  final Future<void> Function() onToggle;
  final Future<void> Function() onEdit;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ageLabel = formatBabyAgeAt(l10n, baby, question.createdAt);
    final metadata = [
      dateFormat.format(question.createdAt),
      ageLabel ?? l10n.questionsAgeUnknown,
    ].join(' • ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: ValueKey(question.id ?? question.createdAt.toIso8601String()),
        background: _DismissBackground(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          icon: LucideIcons.pencil,
          alignment: Alignment.centerLeft,
          label: l10n.questionsEditAction,
        ),
        secondaryBackground: _DismissBackground(
          color: const Color(0x33FF5252),
          icon: LucideIcons.trash2,
          alignment: Alignment.centerRight,
          label: l10n.questionsDeleteAction,
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            await onEdit();
            return false;
          }
          if (direction == DismissDirection.endToStart) {
            final confirmed =
                await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.questionsDeleteDialogTitle),
                    content: Text(l10n.questionsDeleteDialogMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(l10n.questionsEditDialogCancel),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(l10n.questionsDeleteDialogConfirm),
                      ),
                    ],
                  ),
                ) ??
                false;
            if (confirmed) {
              await onDelete();
              return true;
            }
            return false;
          }
          return false;
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: question.isResolved
                  ? AppColors.outline
                  : theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: question.isResolved,
                onChanged: (_) => onToggle(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.content,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        decoration: question.isResolved
                            ? TextDecoration.lineThrough
                            : null,
                        color: question.isResolved
                            ? theme.textTheme.bodyLarge?.color?.withOpacity(0.6)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      metadata,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  const _DismissBackground({
    required this.color,
    required this.icon,
    required this.alignment,
    this.label,
  });

  final Color color;
  final IconData icon;
  final Alignment alignment;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          if (label != null) ...[
            const SizedBox(width: 8),
            Text(
              label!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  const _ErrorPlaceholder({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.redAccent),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _EmptyQuestionsPlaceholder extends StatelessWidget {
  const _EmptyQuestionsPlaceholder({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Icon(LucideIcons.notebookPen, size: 42, color: accentColor),
          const SizedBox(height: 16),
          Text(
            l10n.questionsEmptyTitle,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.questionsEmptySubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
