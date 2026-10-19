import 'dart:io';

/// Rule 21 for the docs: every tracked Markdown file is English.
///
/// A line may still name the product or quote the app's Turkish copy in
/// double quotes — both are stripped before the check. Generated folders and
/// the native projects' own READMEs are skipped.
List<String> docRules() {
  final List<String> problems = <String>[];
  for (final File file in _markdown()) {
    final List<String> lines = file.readAsLinesSync();
    for (int i = 0; i < lines.length; i++) {
      final String prose = lines[i]
          .replaceAll(_productName, '')
          .replaceAll(_quotedCopy, '');
      if (_turkish.hasMatch(prose)) {
        problems.add(
          '${file.path}:${i + 1}  Turkish in a doc — docs are English (rule 21)',
        );
      }
    }
  }
  return problems;
}

final RegExp _turkish = RegExp('[çğıöşüÇĞİÖŞÜ]');
final RegExp _productName = RegExp('LGS Ödül Avı');
final RegExp _quotedCopy = RegExp('"[^"]*"');
const List<String> _skipped = <String>[
  'build',
  '.dart_tool',
  'ios',
  'android',
  '.git',
];

Iterable<File> _markdown() => Directory('.')
    .listSync(recursive: true)
    .whereType<File>()
    .where((File file) => file.path.endsWith('.md'))
    .where(
      (File file) => !_skipped.any(
        (String folder) => file.path.startsWith('./$folder/'),
      ),
    );
