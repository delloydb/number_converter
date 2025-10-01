// main.dart
// Flutter Number System Converter
// Clean, minimalist UI with blue/white/black theme.
// Supports Binary, Decimal, Hexadecimal, Octal input -> shows all 4 representations.
// Uses BigInt for large integers and validates input before converting.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(NumberConverterApp());
}

class NumberConverterApp extends StatelessWidget {
  const NumberConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number System Converter',
      theme: ThemeData(
        // Minimalist blue/white/black theme
        primaryColor: Color(0xFF0B63D1),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0B63D1),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
      ),
      home: ConverterHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum NumberBase { binary, decimal, hexadecimal, octal }

extension NumberBaseExtension on NumberBase {
  String get label {
    switch (this) {
      case NumberBase.binary:
        return 'Binary';
      case NumberBase.decimal:
        return 'Decimal';
      case NumberBase.hexadecimal:
        return 'Hexadecimal';
      case NumberBase.octal:
        return 'Octal';
    }
  }

  int get radix {
    switch (this) {
      case NumberBase.binary:
        return 2;
      case NumberBase.decimal:
        return 10;
      case NumberBase.hexadecimal:
        return 16;
      case NumberBase.octal:
        return 8;
    }
  }
}

class ConverterHomePage extends StatefulWidget {
  const ConverterHomePage({super.key});

  @override
  _ConverterHomePageState createState() => _ConverterHomePageState();
}

class _ConverterHomePageState extends State<ConverterHomePage> {
  final TextEditingController _controller = TextEditingController();
  NumberBase _selectedBase = NumberBase.decimal;
  String? _errorText;

  // Store results as strings
  String _binary = '-';
  String _decimal = '-';
  String _hex = '-';
  String _octal = '-';

  // Validate input for given base.
  // Accepts optional leading '-' for negative integers.
  bool _validateInput(String input, NumberBase base) {
    if (input.trim().isEmpty) return false;
    final s = input.trim();
    final signRemoved = s.startsWith('-') ? s.substring(1) : s;
    if (signRemoved.isEmpty) return false;

    final patterns = {
      NumberBase.binary: RegExp(r'^[01]+$'),
      NumberBase.decimal: RegExp(r'^[0-9]+$'),
      NumberBase.hexadecimal: RegExp(r'^[0-9a-fA-F]+$'),
      NumberBase.octal: RegExp(r'^[0-7]+$'),
    };

    final regex = patterns[base]!;
    return regex.hasMatch(signRemoved);
  }

  // Convert using BigInt for large integers.
  // Returns null and sets _errorText if conversion fails.
  void _convert(String input, NumberBase fromBase) {
    setState(() {
      _errorText = null;
      _binary = _decimal = _hex = _octal = '-';
    });

    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _errorText = null; // empty input isn't an error, just no output
      });
      return;
    }

    if (!_validateInput(trimmed, fromBase)) {
      setState(() {
        _errorText =
            'Invalid ${fromBase.label} input. Check characters allowed for ${fromBase.label}.';
      });
      return;
    }

    try {
      final sign = trimmed.startsWith('-') ? -1 : 1;
      final uns = trimmed.startsWith('-') ? trimmed.substring(1) : trimmed;

      // BigInt.parse supports radix
      final BigInt value =
          BigInt.parse(uns, radix: fromBase.radix) * BigInt.from(sign);

      setState(() {
        // Using toRadixString for other bases; for hex convert to uppercase for nicer display.
        _binary =
            (value < BigInt.zero ? '-' : '') + value.abs().toRadixString(2);
        _decimal = (value < BigInt.zero ? '-' : '') + value.abs().toString();
        _hex =
            (value < BigInt.zero ? '-' : '') +
            value.abs().toRadixString(16).toUpperCase();
        _octal =
            (value < BigInt.zero ? '-' : '') + value.abs().toRadixString(8);
        _errorText = null;
      });
    } on FormatException catch (e) {
      setState(() {
        _errorText = 'Conversion error: ${e.message}';
      });
    } on Exception catch (e) {
      setState(() {
        _errorText = 'Unexpected error: ${e.toString()}';
      });
    }
  }

  // Called when text changes or base changes.
  void _onInputChanged() {
    _convert(_controller.text, _selectedBase);
  }

  // Helper to copy a result to clipboard and show a small snack bar.
  void _copyToClipboard(String label, String value) {
    if (value == '-' || value.isEmpty) return;
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        duration: Duration(milliseconds: 900),
        backgroundColor: Color(0xFF0B63D1),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onInputChanged);
    _controller.dispose();
    super.dispose();
  }

  Widget _buildResultTile(String title, String value) {
    return InkWell(
      onTap: () => _copyToClipboard(title, value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Expanded(
              child: SelectableText(
                value,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.copy, size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to make it responsive for narrow/wide screens.
    return Scaffold(
      appBar: AppBar(title: Text('Number System Converter')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input card
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Input',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    hintText: 'Enter number',
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.black12,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 16,
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  // allow letters for hex; no numeric-optimized keyboard
                                  inputFormatters: [
                                    // Do not force input filtering here; validation handles invalid chars
                                    LengthLimitingTextInputFormatter(200),
                                  ],
                                  onSubmitted: (_) => _onInputChanged(),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: DropdownButton<NumberBase>(
                                    value: _selectedBase,
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    items: NumberBase.values
                                        .map(
                                          (b) => DropdownMenuItem(
                                            value: b,
                                            child: Text(b.label),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (val) {
                                      if (val == null) return;
                                      setState(() {
                                        _selectedBase = val;
                                      });
                                      _onInputChanged();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_errorText != null) ...[
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.redAccent,
                                  size: 18,
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    _errorText!,
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          SizedBox(height: 8),
                          Text(
                            'Tap any result to copy it to clipboard.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18),

                    // Results area
                    isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    _labelWithTile('Binary', _binary),
                                    SizedBox(height: 12),
                                    _labelWithTile('Decimal', _decimal),
                                  ],
                                ),
                              ),
                              SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  children: [
                                    _labelWithTile('Hexadecimal', _hex),
                                    SizedBox(height: 12),
                                    _labelWithTile('Octal', _octal),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _labelWithTile('Binary', _binary),
                              SizedBox(height: 12),
                              _labelWithTile('Decimal', _decimal),
                              SizedBox(height: 12),
                              _labelWithTile('Hexadecimal', _hex),
                              SizedBox(height: 12),
                              _labelWithTile('Octal', _octal),
                            ],
                          ),

                    SizedBox(height: 20),

                    // Helpful tip / footer
                    Center(
                      child: Text(
                        'Only integer conversions supported. For fractional conversions, extend with fixed-point logic or BigDecimal-like handling.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // convenience widget that pairs a title with the styled result tile
  Widget _labelWithTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        _buildResultTile(label, value),
      ],
    );
  }
}
