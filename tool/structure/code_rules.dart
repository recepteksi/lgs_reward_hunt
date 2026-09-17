import 'dart:convert';
import 'dart:io';

import 'conventions.dart';
import 'source_file.dart';

/// What may be written inside a file: one declaration named after the file,
/// comments only above declarations, the layer line, the app's own widgets,
/// English code, sealed states, DI, DTO direction, the kit and the copy.
///
/// The CLAUDE.md rule a check enforces is named in its message.
List<String> codeRules(List<SourceFile> lib) => <String>[
  for (final SourceFile file in lib) ...<String>[
    ..._declarations(file),
    ..._innerComments(file),
    ..._getIt(file),
    ..._layerImports(file),
    ..._widgets(file),
    ..._english(file),
    ..._states(file),
    ..._injection(file),
    ..._dtos(file),
  ],
  ..._kit(lib),
  ..._copy(lib),
];

final RegExp _typeDeclaration = RegExp(
  r'^(?:(?:abstract|sealed|final|base|interface|mixin)\s+)*(class|enum|mixin|extension|typedef)\s+(\w+)',
  multiLine: true,
);

final RegExp _functionDeclaration = RegExp(
  r'^(?!(?:import|export|part|library|class|enum|mixin|extension|typedef|abstract|sealed|final|const|base|interface|var|late)\b)[A-Za-z_][\w<>?,\[\] ]*?\s+([a-zA-Z]\w*)\s*\(',
  multiLine: true,
);

List<String> _declarations(SourceFile file) {
  if (file.isPart ||
      file.path == 'lib/main.dart' ||
      file.path.contains('/di/')) {
    return <String>[];
  }
  final List<String> problems = <String>[];
  final List<RegExpMatch> types = _typeDeclaration
      .allMatches(file.text)
      .toList();
  final List<String> public = <String>[
    for (final RegExpMatch type in types)
      if (!type.group(2)!.startsWith('_')) type.group(2)!,
    for (final RegExpMatch function in _functionDeclaration.allMatches(
      file.text,
    ))
      if (!function.group(1)!.startsWith('_')) function.group(1)!,
  ];
  final bool sealedFamily =
      public.isNotEmpty &&
      RegExp('sealed class ${public.first}\\b').hasMatch(file.text) &&
      public
          .skip(1)
          .every(
            (String name) =>
                RegExp('class $name extends ${public.first}\\b')
                    .hasMatch(file.text),
          );

  if (public.length > 1 && !sealedFamily) {
    problems.add(
      '${file.path}  one public declaration per file, found ${public.join(', ')} (rule 1)',
    );
  }
  if (public.isNotEmpty &&
      public.first != pascalCase(file.stem) &&
      public.first != camelCase(file.stem)) {
    problems.add(
      '${file.path}  declares ${public.first}; the file name says ${pascalCase(file.stem)} (rule 1)',
    );
  }
  for (final RegExpMatch type in types) {
    final String name = type.group(2)!;
    if (name.startsWith('_') &&
        !RegExp('class $name extends State<').hasMatch(file.text)) {
      problems.add(
        '${file.path}  private helper $name — give it its own file and public name (rule 1)',
      );
    }
  }
  return problems;
}

List<String> _innerComments(SourceFile file) => <String>[
  for (int i = 0; i < file.lines.length; i++)
    if (RegExp(r'^\s+//').hasMatch(file.lines[i]) &&
        !file.lines[i].contains('// ignore'))
      '${file.path}:${i + 1}  comment inside a declaration — say it in the block above (rule 13)',
];

List<String> _getIt(SourceFile file) {
  final bool allowed =
      file.path == 'lib/main.dart' ||
      file.path.contains('/di/') ||
      file.stem.endsWith('_page');
  return !allowed && file.code.any((String line) => line.contains('getIt'))
      ? <String>[
          '${file.path}  getIt outside main, di/ and a page BlocProvider (rule 9)',
        ]
      : <String>[];
}

List<String> _layerImports(SourceFile file) {
  final List<String> parts = file.path.split('/');
  if (parts.length < 3 || file.path.contains('/di/')) return <String>[];
  final List<String>? allowed = Conventions.mayImport[parts[1]];
  if (allowed == null) return <String>[];

  final List<String> problems = <String>[];
  for (final RegExpMatch match in RegExp(
    r"import 'package:lgs_reward_hunt/(\w+)/",
  ).allMatches(file.text)) {
    if (!allowed.contains(match.group(1))) {
      problems.add(
        '${file.path}  ${parts[1]} may not import ${match.group(1)} (layer rule)',
      );
    }
  }
  final String layer = parts[1];
  if ((layer == 'core' || layer == 'domain') &&
      file.text.contains("import 'package:flutter/")) {
    problems.add('${file.path}  $layer imports Flutter');
  }
  if (layer == 'application' &&
      RegExp(r"import 'package:flutter/(material|widgets|cupertino)\.dart'")
          .hasMatch(file.text)) {
    problems.add('${file.path}  application imports widgets');
  }
  return problems;
}

const Map<String, String> _ownWidget = <String, String>{
  'Scaffold': 'AppScaffold',
  'AppBar': 'AppAppBar',
  'Text': 'AppText',
  'IconButton': 'AppIconButton',
  'FilledButton': 'AppButton',
  'ElevatedButton': 'AppButton',
  'OutlinedButton': 'AppButton',
  'TextButton': 'AppButton',
  'BottomNavigationBar': 'AppChildNavigation',
  'NavigationBar': 'AppChildNavigation',
};

List<String> _widgets(SourceFile file) {
  if (!file.isUnder('lib/presentation/') ||
      file.isUnder('lib/presentation/base/') ||
      file.isUnder('lib/presentation/debug/')) {
    return <String>[];
  }
  final List<String> problems = <String>[];
  for (int i = 0; i < file.code.length; i++) {
    for (final MapEntry<String, String> own in _ownWidget.entries) {
      if (RegExp('(?<![\\w.])${own.key}(\\.\\w+)?\\(').hasMatch(file.code[i])) {
        problems.add(
          '${file.path}:${i + 1}  ${own.key} — use ${own.value} (rule 17)',
        );
      }
    }
    if (RegExp(r'\w+Loading\([^)]*\)\s*=>\s*(const\s+)?AppLoadingView')
        .hasMatch(file.lines[i])) {
      problems.add(
        '${file.path}:${i + 1}  a first load shows a skeleton in its bars, never a bare AppLoadingView (rule 23)',
      );
    }
    if (RegExp(r'\belevation:').hasMatch(file.code[i])) {
      problems.add(
        '${file.path}:${i + 1}  elevation on a page — a pressable sits on a solid edge (rule 22)',
      );
    }
    if (RegExp(r"\.(go|push|replace|pushReplacement)\(\s*''")
        .hasMatch(file.code[i])) {
      problems.add(
        '${file.path}:${i + 1}  route literal — use AppRoutePaths (rule 14)',
      );
    }
  }
  return problems;
}

final RegExp _turkish = RegExp('[çğıöşüÇĞİÖŞÜ]');

List<String> _english(SourceFile file) {
  final List<String> problems = <String>[];
  for (int i = 0; i < file.code.length; i++) {
    if (_turkish.hasMatch(file.code[i])) {
      problems.add(
        '${file.path}:${i + 1}  Turkish in code — code is English (rule 21)',
      );
    }
  }
  final bool speaks =
      file.isUnder('lib/presentation/') &&
      !file.isUnder('lib/presentation/debug/');
  if (speaks) {
    for (int i = 0; i < file.lines.length; i++) {
      final String line = file.lines[i];
      if (line.trimLeft().startsWith('//')) continue;
      if (RegExp("'[^']*[çğıöşüÇĞİÖŞÜ][^']*'").hasMatch(line)) {
        problems.add(
          '${file.path}:${i + 1}  Turkish copy in a widget — it belongs in app_tr.arb (rule 8)',
        );
      }
    }
  }
  return problems;
}

List<String> _states(SourceFile file) =>
    file.stem.endsWith('_state') &&
        file.isPart &&
        !file.text.contains('sealed class ${pascalCase(file.stem)}')
    ? <String>[
        '${file.path}  sealed class ${pascalCase(file.stem)} — one variant per thing the page shows (rule 6)',
      ]
    : <String>[];

List<String> _injection(SourceFile file) {
  final bool needs =
      file.stem.endsWith('_use_case') ||
      file.stem.endsWith('_cubit') ||
      (file.isUnder('lib/infrastructure/') &&
          (file.stem.endsWith('_repository') ||
              file.stem.endsWith('_service')));
  return needs &&
          !RegExp(
            r'@(injectable|lazySingleton|singleton|Injectable|LazySingleton|Singleton)\b',
          ).hasMatch(file.text)
      ? <String>['${file.path}  not registered for injection']
      : <String>[];
}

List<String> _dtos(SourceFile file) {
  final List<String> problems = <String>[];
  if (!file.isUnder('lib/infrastructure/') && file.text.contains('/dto/')) {
    problems.add('${file.path}  a DTO never leaves infrastructure (rule 16)');
  }
  if (file.stem.endsWith('_request_dto')) {
    if (!file.text.contains('extends BaseRequest')) {
      problems.add('${file.path}  extends BaseRequest (rule 16)');
    }
    if (!file.text.contains('createFactory: false') ||
        file.text.contains('fromJson')) {
      problems.add(
        '${file.path}  a request is never read back: createFactory: false, no fromJson (rule 16)',
      );
    }
  }
  if (file.path.contains('/repositories/') &&
      _functionDeclaration.hasMatch(file.text)) {
    problems.add(
      '${file.path}  a mapper is toEntity() on the response DTO, not a function beside the repository (rule 16)',
    );
  }
  if (file.stem.endsWith('_response_dto') &&
      !file.text.contains('extends BaseResponse')) {
    problems.add('${file.path}  extends BaseResponse (rule 16)');
  }
  return problems;
}

List<String> _kit(List<SourceFile> lib) {
  final Map<String, SourceFile> widgets = <String, SourceFile>{
    for (final SourceFile file in lib)
      if (file.isUnder('lib/presentation/base/ui/widgets/'))
        for (final RegExpMatch match in RegExp(
          r'^(?:final |abstract |sealed )*class (App\w+) extends (?:StatelessWidget|StatefulWidget)',
          multiLine: true,
        ).allMatches(file.text))
          match.group(1)!: file,
  };
  final Set<String> shown = <String>{};
  final List<SourceFile> queue = lib
      .where((SourceFile f) => f.isUnder('lib/presentation/debug/'))
      .toList();
  while (queue.isNotEmpty) {
    final SourceFile file = queue.removeLast();
    for (final MapEntry<String, SourceFile> widget in widgets.entries) {
      if (!shown.contains(widget.key) &&
          RegExp('\\b${widget.key}\\b').hasMatch(file.text)) {
        shown.add(widget.key);
        queue.add(widget.value);
      }
    }
  }
  return <String>[
    for (final MapEntry<String, SourceFile> widget in widgets.entries)
      if (!shown.contains(widget.key))
        '${widget.value.path}  ${widget.key} is not on the /ui-kit sheet (rule 15)',
  ];
}

List<String> _copy(List<SourceFile> lib) {
  final File arb = File('lib/presentation/base/ui/values/l10n/arb/app_tr.arb');
  if (!arb.existsSync()) return <String>[];
  final Map<String, dynamic> entries =
      jsonDecode(arb.readAsStringSync()) as Map<String, dynamic>;
  final String code = lib.map((SourceFile file) => file.text).join('\n');

  return <String>[
    for (final String key in entries.keys)
      if (!key.startsWith('@') && !RegExp('\\.$key\\b').hasMatch(code))
        '${arb.path}  "$key" is never used — delete it',
  ];
}
