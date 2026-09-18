import 'dart:io';

/// Raises `version:` in `pubspec.yaml` — the one place the app's version name
/// lives.
///
/// Semantic versioning, decided by what the release contains: `major` for a
/// change a user has to relearn, `minor` for a feature, `patch` for a fix.
/// The build number after `+` is left alone: CI derives it from the run, so
/// every upload is higher than the last without anyone counting.
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
  stdout.writeln('version: $next');
}
