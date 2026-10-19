import 'dart:io';

import 'structure/code_rules.dart';
import 'structure/folder_rules.dart';
import 'structure/literal_rules.dart';
import 'structure/native_rules.dart';
import 'structure/project_map.dart';
import 'structure/source_file.dart';

/// The project's rules that the analyzer cannot see, checked in one pass.
///
/// Folders (the folder method, kinds, bases, pages, Cubits, tests), code (one
/// declaration per file, comments, the layer line, the app's own widgets,
/// English code, sealed states, DI, DTOs, the kit, unused copy), literals
/// (rule 7), the native wiring a regenerating tool can undo, and a current
/// `PROJECT-MAP.md`. Each problem names the path and the rule it breaks.
///
/// Run it with `dart run tool/check_structure.dart`; CI and the pre-commit
/// hook run it between `flutter analyze` and `flutter test`.
void main() {
  final List<SourceFile> lib = SourceFile.under('lib');
  final List<String> problems = <String>[
    ...folderRules(),
    ...codeRules(lib),
    ...literalRules(lib),
    ...nativeRules(),
    if (File('PROJECT-MAP.md').readAsStringSync() != buildProjectMap())
      'PROJECT-MAP.md  stale — run dart run tool/generate_project_map.dart',
  ];

  if (problems.isEmpty) {
    stdout.writeln('check_structure: clean');
    return;
  }
  stderr
    ..writeln('check_structure: ${problems.length} problem(s)')
    ..writeAll(problems, '\n')
    ..writeln();
  exitCode = 1;
}
