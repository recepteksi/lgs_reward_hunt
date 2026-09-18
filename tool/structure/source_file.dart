import 'dart:io';

/// One hand-written Dart file, read once and shared by every rule.
///
/// [code] is each line with string literals and comments blanked out, so a rule
/// that looks for `Scaffold(` or a Turkish letter does not trip over a doc
/// comment quoting one. [stem] is the file name without `.dart`.
final class SourceFile {
  SourceFile(this.path, this.text)
    : lines = text.split('\n'),
      code = text.split('\n').map(stripStringsAndComments).toList();

  final String path;

  final String text;

  final List<String> lines;

  final List<String> code;

  String get name => path.split('/').last;

  String get stem => name.substring(0, name.length - '.dart'.length);

  bool get isPart => RegExp(r'^part of ', multiLine: true).hasMatch(text);

  bool isUnder(String folder) => path.startsWith(folder);

  static List<SourceFile> under(String root) {
    final Directory directory = Directory(root);
    if (!directory.existsSync()) return <SourceFile>[];

    return directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((File file) => file.path.endsWith('.dart'))
        .where((File file) => !isGenerated(file.path))
        .map((File file) => SourceFile(file.path, file.readAsStringSync()))
        .toList()
      ..sort((SourceFile a, SourceFile b) => a.path.compareTo(b.path));
  }
}

/// Whether [path] was written by a tool rather than a person.
///
/// Generated code follows its generator's conventions, not this project's,
/// and FlutterFire's options files are regenerated wholesale.
bool isGenerated(String path) =>
    path.endsWith('.g.dart') ||
    path.endsWith('.config.dart') ||
    path.contains('/generated/') ||
    path.contains('config/firebase/');

/// A line with its string literals emptied and its comment removed.
String stripStringsAndComments(String line) {
  final String withoutStrings = line
      .replaceAll(RegExp(r"'(?:[^'\\]|\\.)*'"), "''")
      .replaceAll(RegExp(r'"(?:[^"\\]|\\.)*"'), '""');
  final int comment = withoutStrings.indexOf('//');

  return comment == -1 ? withoutStrings : withoutStrings.substring(0, comment);
}

/// `task_plan_value_object` → `TaskPlanValueObject`.
String pascalCase(String snake) => snake
    .split('_')
    .map(
      (String part) =>
          part.isEmpty ? part : part[0].toUpperCase() + part.substring(1),
    )
    .join();

/// `failure_copy` → `failureCopy`.
String camelCase(String snake) {
  final String pascal = pascalCase(snake);
  return pascal.isEmpty
      ? pascal
      : pascal[0].toLowerCase() + pascal.substring(1);
}
