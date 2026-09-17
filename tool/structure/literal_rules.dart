import 'source_file.dart';

/// No magic literals: an empty string, a bare number in a widget, a colour
/// hex outside the palette (rule 7).
///
/// Holders of named values — `core/constants/`, `*_rules.dart`,
/// `presentation/base/ui/values/` — are where the literals are allowed to be
/// written, and a line that IS a declaration names its own number. A hex in
/// infrastructure is data being parsed, not a colour being chosen.
List<String> literalRules(List<SourceFile> lib) {
  final List<String> problems = <String>[];

  for (final SourceFile file in lib) {
    if (_holdsValues(file.path)) continue;
    final bool widget =
        file.isUnder('lib/presentation/base/ui/widgets/') ||
        file.path.contains('/pages/');

    for (int i = 0; i < file.lines.length; i++) {
      final String line = file.lines[i];
      final String code = file.code[i];
      final String where = '${file.path}:${i + 1}';

      if (line.contains("''") &&
          !line.trimLeft().startsWith('//') &&
          !file.path.endsWith('char_constants.dart')) {
        problems.add('$where  empty string — use CharConstants.empty');
      }
      final RegExpMatch? number = _number.firstMatch(code);
      if (widget &&
          number != null &&
          !_isDeclaration(line) &&
          !file.isUnder('lib/presentation/debug/')) {
        problems.add(
          '$where  bare number ${number[0]} — name it in base/ui/values/ or core/constants/',
        );
      }
      if (file.isUnder('lib/presentation/') &&
          !file.path.endsWith('app_palette.dart') &&
          _hex.hasMatch(code)) {
        problems.add('$where  colour literal — read it from AppPalette');
      }
    }
  }
  return problems;
}

final RegExp _number = RegExp(r'(?<![\w.$])\d+(\.\d+)?(?![\w.])');

final RegExp _hex = RegExp('0x[0-9A-Fa-f]{6,8}');

bool _holdsValues(String path) =>
    path.contains('core/constants/') ||
    path.endsWith('_rules.dart') ||
    path.contains('base/ui/values/');

bool _isDeclaration(String line) {
  final String trimmed = line.trimLeft();
  return trimmed.startsWith('static const') ||
      trimmed.startsWith('const ') ||
      trimmed.startsWith('final ') ||
      trimmed.startsWith('//');
}
