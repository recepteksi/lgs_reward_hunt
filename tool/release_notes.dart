import 'dart:io';

/// Prints the newest released section of `CHANGELOG.md`, as plain text.
///
/// The same words reach every tester: CI pipes this into Firebase App
/// Distribution's release notes and Google Play's "what's new". Headings and
/// list markers are stripped because the stores show plain text, and the notes
/// are truncated to Play's 500-character limit — which is the real limit on how
/// much anyone reads anyway.
///
///     dart run tool/release_notes.dart
void main() {
  const int playLimit = 500;
  final File changelog = File('CHANGELOG.md');
  if (!changelog.existsSync()) return;

  final List<String> lines = changelog.readAsLinesSync();
  final int first = lines.indexWhere(
    (String line) => line.startsWith('## [') && !line.contains('[Unreleased]'),
  );
  if (first == -1) return;

  final int next = lines.indexWhere(
    (String line) => line.startsWith('## '),
    first + 1,
  );
  final Iterable<String> body = lines
      .sublist(first + 1, next == -1 ? lines.length : next)
      .map((String line) => line.startsWith('### ') ? line.substring(4) : line);

  final String notes = body.join('\n').trim();
  stdout.write(
    notes.length <= playLimit ? notes : '${notes.substring(0, playLimit - 1)}…',
  );
}
