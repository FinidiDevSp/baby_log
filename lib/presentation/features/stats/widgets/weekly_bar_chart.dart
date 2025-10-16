part of '../baby_stats_page.dart';

class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({
    super.key,
    required this.points,
    required this.accentColor,
    required this.unitSuffix,
    this.yAxisLabel,
    this.maxValueOverride,
    this.valueLabelBuilder,
  });

  final List<DailyMetricPoint> points;
  final Color accentColor;
  final String unitSuffix;
  final String? yAxisLabel;
  final double? maxValueOverride;
  final String Function(DailyMetricPoint point)? valueLabelBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;
    final numberFormat = NumberFormat.compact(locale: locale);
    final labels = points
        .map((point) => _formatDayLabel(point.date, locale))
        .toList(growable: false);

    final maxValue = maxValueOverride ??
        points
            .where((point) => point.hasValue)
            .fold<double>(0, (previousValue, element) =>
                math.max(previousValue, element.value.abs()));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (yAxisLabel != null)
          Text(
            yAxisLabel!,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white60),
          ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 1.6,
          child: CustomPaint(
            painter: _WeeklyBarChartPainter(
              points: points,
              labels: labels,
              barColor: accentColor,
              numberFormat: numberFormat,
              maxValue: maxValue <= 0 ? 1 : maxValue,
              unitSuffix: unitSuffix,
              valueLabelBuilder: valueLabelBuilder,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDayLabel(DateTime date, String locale) {
    final dayName = DateFormat('EEE', locale).format(date);
    final capitalized = dayName.substring(0, 1).toUpperCase() +
        (dayName.length > 1 ? dayName.substring(1) : '');
    return '$capitalized\n${date.day.toString().padLeft(2, '0')}';
  }
}

class _WeeklyBarChartPainter extends CustomPainter {
  _WeeklyBarChartPainter({
    required this.points,
    required this.labels,
    required this.barColor,
    required this.numberFormat,
    required this.maxValue,
    required this.unitSuffix,
    this.valueLabelBuilder,
  });

  final List<DailyMetricPoint> points;
  final List<String> labels;
  final Color barColor;
  final NumberFormat numberFormat;
  final double maxValue;
  final String unitSuffix;
  final String Function(DailyMetricPoint point)? valueLabelBuilder;

  static const double _topPadding = 24;
  static const double _bottomPadding = 44;
  static const double _horizontalPadding = 16;
  static const double _barRadius = 6;

  @override
  void paint(Canvas canvas, Size size) {
    final chartHeight = size.height - _topPadding - _bottomPadding;
    final chartWidth = size.width - (_horizontalPadding * 2);
    if (chartHeight <= 0 || chartWidth <= 0) {
      return;
    }

    final barPaint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;
    final inactivePaint = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.fill;
    final baseLinePaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1;
    final trendPaint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final offsetY = size.height - _bottomPadding;
    final step = chartWidth / points.length;
    final barWidth = step * 0.5;

    // Draw horizontal baseline.
    canvas.drawLine(
      Offset(_horizontalPadding, offsetY),
      Offset(size.width - _horizontalPadding, offsetY),
      baseLinePaint,
    );

    final List<Offset> trendOffsets = [];
    final List<double> xValues = [];
    final List<double> yValues = [];

    for (var index = 0; index < points.length; index += 1) {
      final point = points[index];
      final xCenter = _horizontalPadding + (step * index) + (step / 2);
      final normalized = point.value / maxValue;
      final barHeight = math.max(0, normalized) * chartHeight;
      final barTop = offsetY - barHeight;

      if (point.hasValue && barHeight > 0) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            xCenter - (barWidth / 2),
            barTop,
            barWidth,
            barHeight,
          ),
          const Radius.circular(_barRadius),
        );
        canvas.drawRRect(rect, barPaint);
      } else if (point.hasValue && barHeight == 0) {
        canvas.drawLine(
          Offset(xCenter - (barWidth / 2), offsetY - 1),
          Offset(xCenter + (barWidth / 2), offsetY - 1),
          barPaint,
        );
      } else {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            xCenter - (barWidth / 4),
            offsetY - 12,
            barWidth / 2,
            12,
          ),
          const Radius.circular(_barRadius / 2),
        );
        canvas.drawRRect(rect, inactivePaint);
      }

      if (point.hasValue) {
        xValues.add(index.toDouble());
        yValues.add(point.value);
      }

      final label = valueLabelBuilder?.call(point) ??
          '${numberFormat.format(point.value)}$unitSuffix';
      if (label.trim().isNotEmpty && point.hasValue) {
        final textSpan = TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        );
        final painter = TextPainter(
          text: textSpan,
          textDirection: ui.TextDirection.ltr,
        )
          ..layout(maxWidth: step);
        final labelOffset = Offset(
          xCenter - (painter.width / 2),
          math.min(barTop - painter.height - 4, offsetY - painter.height - 4),
        );
        painter.paint(canvas, labelOffset);
      } else if (!point.hasValue) {
        final textSpan = const TextSpan(
          text: '—',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        );
        final painter = TextPainter(
          text: textSpan,
          textDirection: ui.TextDirection.ltr,
        )
          ..layout();
        painter.paint(
          canvas,
          Offset(xCenter - (painter.width / 2), offsetY - painter.height - 4),
        );
      }
    }

    if (xValues.length >= 2) {
      final meanX = xValues.reduce((a, b) => a + b) / xValues.length;
      final meanY = yValues.reduce((a, b) => a + b) / yValues.length;
      double numerator = 0;
      double denominator = 0;
      for (var i = 0; i < xValues.length; i += 1) {
        numerator += (xValues[i] - meanX) * (yValues[i] - meanY);
        denominator += math.pow(xValues[i] - meanX, 2).toDouble();
      }
      final slope = denominator == 0 ? 0 : numerator / denominator;
      final intercept = meanY - (slope * meanX);

      for (var index = 0; index < points.length; index += 1) {
        final xCenter = _horizontalPadding + (step * index) + (step / 2);
        final predicted = intercept + (slope * index);
        final normalized = predicted / maxValue;
        final clamped = normalized.isNaN
            ? 0.0
            : normalized.clamp(0.0, 1.0).toDouble();
        final yPosition = offsetY - (clamped * chartHeight);
        trendOffsets.add(Offset(xCenter, yPosition));
      }

      final path = Path()..moveTo(trendOffsets.first.dx, trendOffsets.first.dy);
      for (var i = 1; i < trendOffsets.length; i += 1) {
        path.lineTo(trendOffsets[i].dx, trendOffsets[i].dy);
      }
      canvas.drawPath(path, trendPaint);
    }

    for (var index = 0; index < labels.length; index += 1) {
      final painter = TextPainter(
        text: TextSpan(
          text: labels[index],
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
            height: 1.2,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: ui.TextDirection.ltr,
      )
        ..layout(maxWidth: step);
      final xCenter = _horizontalPadding + (step * index) + (step / 2);
      final labelOffset = Offset(
        xCenter - (painter.width / 2),
        offsetY + 8,
      );
      painter.paint(canvas, labelOffset);
    }
  }

  @override
  bool shouldRepaint(covariant _WeeklyBarChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.barColor != barColor ||
        oldDelegate.unitSuffix != unitSuffix;
  }
}
