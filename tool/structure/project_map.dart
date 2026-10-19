import 'dart:io';

import 'conventions.dart';
import 'source_file.dart';

/// `PROJECT-MAP.md`: where things live, in as few tokens as answer the
/// question.
///
/// It summarises — a folder and its count, never a file list — because the map
/// only pays for itself while reading it is cheaper than a `find`. Everything
/// in it is derived from the tree, so `check_structure` can regenerate it in
/// memory and fail when the file on disk has drifted.
String buildProjectMap() {
  final List<SourceFile> lib = SourceFile.under('lib');
  final StringBuffer out = StringBuffer()
    ..writeln('# Project map')
    ..writeln()
    ..writeln(
      '**GENERATED — do not edit.** `dart run tool/generate_project_map.dart` '
      'rewrites it; `dart run tool/check_structure.dart` fails while it is stale. '
      'Rules: [CLAUDE.md](CLAUDE.md). ${lib.length} source files.',
    )
    ..writeln()
    ..writeln(
      '`core` → nothing · `domain` → core · `application` → domain · '
      '`infrastructure` → domain · `presentation` → application, domain. '
      '`main.dart` and `application/di/` are the composition root.',
    )
    ..writeln()
    ..writeln('## Features — `lib/<layer>/<feature>/<kind>/`')
    ..writeln()
    ..writeln(
      '| feature | domain | application | infrastructure | presentation pages |',
    )
    ..writeln('|---|---|---|---|---|');

  for (final String feature in Conventions.features) {
    out.writeln(
      '| `$feature` | ${_kinds('lib/domain/$feature')} | '
      '${_kinds('lib/application/$feature')} | ${_kinds('lib/infrastructure/$feature')} | '
      '${_children('lib/presentation/$feature/pages').join(', ')} |',
    );
  }

  out
    ..writeln()
    ..writeln(
      'Kind folders hold one suffix each: entities · value_objects · read_models · '
      'enums · interfaces · rules · validators · use_cases · cubit/<page> · repositories · '
      'services · dto · mock. A page folder: `<page>_page.dart`, `body/<page>_body.dart`, '
      'items/ widgets/ app_bar/ modal_bottom_sheet/.',
    )
    ..writeln()
    ..writeln('## Shared folders')
    ..writeln();

  for (final String layer in Conventions.layers) {
    for (final String folder in Conventions.sharedFolders[layer]!) {
      final String path = 'lib/$layer/$folder';
      final List<String> inner = _children(path);
      out.writeln(
        '- `$layer/$folder/` _(${_count(path)})_'
        '${inner.isEmpty ? '' : ' — ${inner.join(', ')}'}',
      );
    }
  }
  out
    ..writeln(
      '- `presentation/base/ui/widgets/` — ${_children('lib/presentation/base/ui/widgets').join(', ')}',
    )
    ..writeln()
    ..writeln('## Tests — mirror lib')
    ..writeln()
    ..writeln(
      '`test/<layer>/<feature>/`; `test/support/mock_backend.dart` builds the mock '
      'backend (`mockBackend()`, `demoParent()`). Page tests pump a 360-wide phone (`test/support/pump_page.dart`).',
    )
    ..writeln()
    ..writeln('## Gate')
    ..writeln()
    ..writeln(
      '`flutter analyze` · `dart run tool/check_structure.dart` · `flutter test`',
    );

  return out.toString();
}

List<String> _children(String path) {
  final Directory directory = Directory(path);
  if (!directory.existsSync()) return <String>[];
  return directory
      .listSync()
      .whereType<Directory>()
      .map((Directory d) => d.path.split('/').last)
      .toList()
    ..sort();
}

int _count(String path) => SourceFile.under(path).length;

String _kinds(String path) =>
    _children(path)
        .map((String kind) => '$kind ${_count('$path/$kind')}')
        .join(' · ');
