import 'dart:io';

import 'conventions.dart';

/// Where files may live: the folder method, kind folders, bases, pages,
/// Cubits and tests.
///
/// Every problem names the path and the rule, so the message is the fix.
List<String> folderRules() => <String>[
  ..._layerFolders(),
  ..._emptyFolders('lib'),
  ..._emptyFolders('test'),
  ..._pages(),
  ..._cubits(),
  ..._tests(),
];

String _name(String path) => path.split('/').last;

List<String> _layerFolders() {
  final List<String> problems = <String>[];

  for (final String layer in Conventions.layers) {
    final Directory root = Directory('lib/$layer');
    if (!root.existsSync()) continue;

    for (final FileSystemEntity entry in root.listSync()) {
      final String name = _name(entry.path);
      if (entry is! Directory || name.startsWith('.')) continue;
      final bool isFeature = Conventions.features.contains(name);
      if (!isFeature && !Conventions.sharedFolders[layer]!.contains(name)) {
        problems.add(
          '${entry.path}  not a listed feature nor a shared $layer folder',
        );
        continue;
      }
      if (isFeature) problems.addAll(_featureFolder(layer, entry));
    }
  }
  return problems;
}

List<String> _featureFolder(String layer, Directory feature) {
  final List<String> problems = <String>[];
  final Map<String, String> kinds = Conventions.featureKinds[layer]!;

  for (final FileSystemEntity inner in feature.listSync()) {
    final String name = _name(inner.path);
    if (name.startsWith('.')) continue;
    if (inner is File) {
      problems.add(
        '${inner.path}  no loose files in a feature — use ${kinds.keys.join(', ')}',
      );
      continue;
    }
    if (!kinds.containsKey(name)) {
      problems.add(
        '${inner.path}  a $layer feature holds only ${kinds.keys.join(', ')}',
      );
      continue;
    }
    final String suffix = kinds[name]!;
    if (suffix.isEmpty) continue;

    for (final File file in Directory(
      inner.path,
    ).listSync().whereType<File>()) {
      final String fileName = _name(file.path);
      if (fileName.startsWith('.') || fileName.endsWith('.g.dart')) continue;
      if (!fileName.endsWith(suffix)) {
        problems.add('${file.path}  $name/ holds only *$suffix');
        continue;
      }
      final String? base = Conventions.baseOf[suffix];
      if (base != null &&
          !RegExp('extends\\s+${RegExp.escape(base)}')
              .hasMatch(file.readAsStringSync())) {
        problems.add('${file.path}  must extend $base');
      }
    }
  }
  return problems;
}

List<String> _emptyFolders(String root) => Directory(root)
    .listSync(recursive: true)
    .whereType<Directory>()
    .where((Directory directory) => !directory.path.contains('/.'))
    .where(
      (Directory directory) => directory
          .listSync()
          .where((FileSystemEntity entry) => !_name(entry.path).startsWith('.'))
          .isEmpty,
    )
    .map((Directory directory) => '${directory.path}  empty folder — delete it')
    .toList();

List<String> _pages() {
  final List<String> problems = <String>[];

  for (final Directory owner in Directory(
    'lib/presentation',
  ).listSync().whereType<Directory>()) {
    final Directory pages = Directory('${owner.path}/pages');
    if (!pages.existsSync()) continue;

    for (final Directory page in pages.listSync().whereType<Directory>()) {
      final String name = _name(page.path);
      problems.addAll(_pageTest(owner, name));
      if (!File('${page.path}/${name}_page.dart').existsSync()) {
        problems.add('${page.path}  needs ${name}_page.dart');
      }
      final Directory body = Directory('${page.path}/body');
      final List<String> bodies = body.existsSync()
          ? body
                .listSync()
                .map((FileSystemEntity e) => _name(e.path))
                .where((String n) => !n.startsWith('.'))
                .toList()
          : <String>[];
      if (bodies.length != 1 || bodies.single != '${name}_body.dart') {
        problems.add(
          '${page.path}/body  holds exactly ${name}_body.dart (rule 14)',
        );
      }
      for (final FileSystemEntity entry in page.listSync()) {
        final String entryName = _name(entry.path);
        if (entryName.startsWith('.')) continue;
        if (entry is Directory &&
            !Conventions.pageFolders.contains(entryName)) {
          problems.add(
            '${entry.path}  a page holds only ${Conventions.pageFolders.join(', ')}',
          );
        }
        if (entry is File && !entryName.startsWith('${name}_')) {
          problems.add(
            '${entry.path}  a file at a page root is named ${name}_*',
          );
        }
      }
    }
  }
  return problems;
}

List<String> _cubits() {
  final List<String> problems = <String>[];

  for (final String feature in Conventions.features) {
    final Directory cubits = Directory('lib/application/$feature/cubit');
    if (!cubits.existsSync()) continue;

    for (final Directory cubit in cubits.listSync().whereType<Directory>()) {
      final String page = _name(cubit.path);
      final List<String> files =
          cubit
              .listSync()
              .map((FileSystemEntity e) => _name(e.path))
              .where((String n) => !n.startsWith('.'))
              .toList()
            ..sort();
      if (files.join(',') != '${page}_cubit.dart,${page}_state.dart') {
        problems.add(
          '${cubit.path}  holds exactly ${page}_cubit.dart and ${page}_state.dart (rule 5)',
        );
      }
      if (!Conventions.appWideCubits.contains(page) &&
          !Directory('lib/presentation/$feature/pages/$page').existsSync()) {
        problems.add(
          '${cubit.path}  has no page lib/presentation/$feature/pages/$page — a Cubit is named after its page, in the same feature',
        );
      }
    }
  }
  return problems;
}

List<String> _tests() {
  final List<String> problems = <String>[];

  for (final File file in Directory(
    'test',
  ).listSync(recursive: true).whereType<File>()) {
    if (!file.path.endsWith('_test.dart')) continue;
    final List<String> parts = file.path.split('/');
    final String layer = parts.length > 2 ? parts[1] : '';
    final String area = parts.length > 3 ? parts[2] : '';
    if (!Conventions.layers.contains(layer) ||
        !(Conventions.features.contains(area) ||
            Conventions.sharedFolders[layer]!.contains(area))) {
      problems.add(
        '${file.path}  tests mirror lib: test/<layer>/<feature or shared folder>/…',
      );
    }
  }
  return problems;
}

/// A page ships with a test that pumps it on a small phone.
///
/// Layouts that only fit a large phone have shipped here more than once; a
/// test at 360 logical pixels wide, or through `pumpPage`, is what caught them.
List<String> _pageTest(Directory owner, String page) {
  final String folder = 'test/presentation/${_name(owner.path)}/pages/$page';
  final Directory directory = Directory(folder);
  final List<File> tests = directory.existsSync()
      ? directory
            .listSync(recursive: true)
            .whereType<File>()
            .where((File file) => file.path.endsWith('_test.dart'))
            .toList()
      : <File>[];
  if (tests.isEmpty) {
    return <String>['$folder  every page has a test (rule 11)'];
  }
  final bool small = tests.any((File file) {
    final String text = file.readAsStringSync();
    return text.contains('pumpPage(') ||
        RegExp(r'Size\((\d+)')
            .allMatches(text)
            .any((RegExpMatch match) => int.parse(match.group(1)!) <= 360);
  });
  return small
      ? <String>[]
      : <String>[
          '$folder  a page test pumps a phone no wider than 360 (pumpPage)',
        ];
}
