import 'dart:io';

/// Raises `version:` in `pubspec.yaml` — the one place the app's version name
/// lives.
///
/// Semantic versioning, decided by what the release contains: `major` for a
/// change a user has to relearn, `minor` for a feature, `patch` for a fix.
/// The build number after `+` is left alone: CI derives it from the run, so
/// every upload is higher than the last without anyone counting.
///
/// It also closes `## [Unreleased]` in `CHANGELOG.md`, stamping what is under
/// it with the new version and today's date — the notes CI then ships to
/// testers. An empty Unreleased section is a warning, not a failure: a release
/// with nothing to say for it is unusual, but it is the author's call.
///
///     dart run tool/bump_version.dart patch
void main(List<String> arguments) {
  const List<String> parts = <String>['major', 'minor', 'patch'];
  final String? part = arguments.isEmpty ? null : arguments.first;
  if (!parts.contains(part)) {
    stderr.writeln('usage: dart run tool/bump_version.dart ${parts.join('|')}');
    exitCode = 1;
    return;
  }

  final File pubspec = File('pubspec.yaml');
  final String text = pubspec.readAsStringSync();
  final RegExpMatch? current = RegExp(
    r'^version: (\d+)\.(\d+)\.(\d+)(\+\d+)?$',
    multiLine: true,
  ).firstMatch(text);
  if (current == null) {
    stderr.writeln('pubspec.yaml has no semantic version: line');
    exitCode = 1;
    return;
  }

  final List<int> numbers = <int>[
    for (int group = 1; group <= 3; group++) int.parse(current.group(group)!),
  ];
  final int index = parts.indexOf(part!);
  numbers[index] += 1;
  for (int rest = index + 1; rest < numbers.length; rest++) {
    numbers[rest] = 0;
  }
  final String next = numbers.join('.');

  pubspec.writeAsStringSync(
    text.replaceRange(
      current.start,
      current.end,
      'version: $next${current.group(4) ?? ''}',
    ),
  );
  _stampChangelog(next);
  stdout.writeln('version: $next');
}

/// Turns `## [Unreleased]` into `## [<version>] - <today>` and opens a fresh
/// Unreleased section above it.
void _stampChangelog(String version) {
  final File changelog = File('CHANGELOG.md');
  if (!changelog.existsSync()) return;

  const String unreleased = '## [Unreleased]';
  final String text = changelog.readAsStringSync();
  final int start = text.indexOf(unreleased);
  if (start == -1) {
    stderr.writeln('CHANGELOG.md has no $unreleased section');
    return;
  }

  final int next = text.indexOf('\n## ', start + unreleased.length);
  final String notes = text
      .substring(start + unreleased.length, next == -1 ? text.length : next)
      .trim();
  if (notes.isEmpty) {
    stderr.writeln('warning: $unreleased is empty — $version ships no notes');
  }

  final DateTime today = DateTime.now();
  final String date = '${today.year}-${_two(today.month)}-${_two(today.day)}';
  changelog.writeAsStringSync(
    text.replaceRange(
      start,
      start + unreleased.length,
      '$unreleased\n\n## [$version] - $date',
    ),
  );
}

String _two(int number) => number.toString().padLeft(2, '0');
