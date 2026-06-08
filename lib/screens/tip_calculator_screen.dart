import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/tip_calculation.dart';
import '../theme/app_background_theme.dart';

class TipCalculatorScreen extends StatefulWidget {
  const TipCalculatorScreen({super.key});

  @override
  State<TipCalculatorScreen> createState() => _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends State<TipCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _billController = TextEditingController();
  final _splitController = TextEditingController(text: '1');

  int _colorIndex = 0;
  double _tipPercent = 18;
  bool _showResults = false;
  TipCalculation? _result;

  Color get _background => AppBackgroundTheme.palette[_colorIndex];

  Color get _foreground => AppBackgroundTheme.foregroundFor(_background);

  Color get _mutedForeground => AppBackgroundTheme.mutedForegroundFor(_background);

  Color get _accent => AppBackgroundTheme.accentFor(_background);

  @override
  void dispose() {
    _billController.dispose();
    _splitController.dispose();
    super.dispose();
  }

  void _cycleBackgroundColor() {
    setState(() {
      _colorIndex = (_colorIndex + 1) % AppBackgroundTheme.palette.length;
    });
  }

  void _calculateTip() {
    FocusScope.of(context).unfocus();
    setState(() {
      _showResults = false;
      _result = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final bill = double.parse(_billController.text.trim());
    final split = int.parse(_splitController.text.trim());

    setState(() {
      _result = TipCalculation(
        billAmount: bill,
        tipPercent: _tipPercent,
        splitCount: split,
      );
      _showResults = true;
    });
  }

  InputDecoration _fieldDecoration({
    required String label,
    required String hint,
    String? prefixText,
    String? suffixText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixText: prefixText,
      suffixText: suffixText,
      labelStyle: TextStyle(color: _mutedForeground),
      hintStyle: TextStyle(color: _mutedForeground.withValues(alpha: 0.6)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _foreground.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _accent, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: _foreground.withValues(alpha: 0.06),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        foregroundColor: _foreground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Tip Calculator',
          style: TextStyle(
            color: _foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: _foreground),
      ),
      body: GestureDetector(
        onTap: _cycleBackgroundColor,
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Split bills and calculate tips quickly.',
                    style: TextStyle(color: _mutedForeground, fontSize: 15),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _billController,
                    style: TextStyle(color: _foreground),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    decoration: _fieldDecoration(
                      label: 'Bill Amount',
                      hint: 'e.g. 42.50',
                      prefixText: '\$ ',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Bill amount is required';
                      }
                      final parsed = double.tryParse(value.trim());
                      if (parsed == null) {
                        return 'Enter a valid number';
                      }
                      if (parsed <= 0) {
                        return 'Bill must be greater than zero';
                      }
                      if (parsed > 999999) {
                        return 'Bill amount is too large';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Tip: ${_tipPercent.round()}%',
                    style: TextStyle(
                      color: _foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Slider(
                    value: _tipPercent,
                    min: 0,
                    max: 50,
                    divisions: 50,
                    label: '${_tipPercent.round()}%',
                    activeColor: _accent,
                    inactiveColor: _foreground.withValues(alpha: 0.25),
                    onChanged: (value) {
                      setState(() => _tipPercent = value);
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _splitController,
                    style: TextStyle(color: _foreground),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: _fieldDecoration(
                      label: 'Split Between',
                      hint: 'Number of people',
                      suffixText: ' people',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Number of people is required';
                      }
                      final parsed = int.tryParse(value.trim());
                      if (parsed == null) {
                        return 'Enter a whole number';
                      }
                      if (parsed < 1) {
                        return 'At least 1 person required';
                      }
                      if (parsed > 100) {
                        return 'Maximum 100 people';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _calculateTip,
                    icon: const Icon(Icons.calculate_outlined),
                    label: const Text('Calculate Tip'),
                    style: FilledButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: AppBackgroundTheme.foregroundFor(_accent),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  if (_showResults && _result != null) ...[
                    const SizedBox(height: 28),
                    _ResultsCard(
                      result: _result!,
                      foreground: _foreground,
                      mutedForeground: _mutedForeground,
                      accent: _accent,
                      cardFill: _foreground.withValues(alpha: 0.08),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    'Tap empty space to change theme '
                    '(${AppBackgroundTheme.paletteNames[_colorIndex]})',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _mutedForeground,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultsCard extends StatelessWidget {
  const _ResultsCard({
    required this.result,
    required this.foreground,
    required this.mutedForeground,
    required this.accent,
    required this.cardFill,
  });

  final TipCalculation result;
  final Color foreground;
  final Color mutedForeground;
  final Color accent;
  final Color cardFill;

  String _formatMoney(double amount) => '\$${amount.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: foreground.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Results',
            style: TextStyle(
              color: foreground,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _ResultRow(
            label: 'Tip amount',
            value: _formatMoney(result.tipAmount),
            foreground: foreground,
            mutedForeground: mutedForeground,
          ),
          _ResultRow(
            label: 'Total with tip',
            value: _formatMoney(result.totalAmount),
            foreground: foreground,
            mutedForeground: mutedForeground,
            emphasize: true,
            accent: accent,
          ),
          if (result.splitCount > 1) ...[
            const Divider(height: 24),
            _ResultRow(
              label: 'Per person (${result.splitCount} people)',
              value: _formatMoney(result.perPerson),
              foreground: foreground,
              mutedForeground: mutedForeground,
              emphasize: true,
              accent: accent,
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    required this.foreground,
    required this.mutedForeground,
    this.emphasize = false,
    this.accent,
  });

  final String label;
  final String value;
  final Color foreground;
  final Color mutedForeground;
  final bool emphasize;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: mutedForeground,
              fontSize: emphasize ? 15 : 14,
              fontWeight: emphasize ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: emphasize ? (accent ?? foreground) : foreground,
              fontSize: emphasize ? 20 : 16,
              fontWeight: emphasize ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
