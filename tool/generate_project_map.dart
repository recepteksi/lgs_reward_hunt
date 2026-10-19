import 'dart:io';

import 'structure/project_map.dart';

/// Rewrites `PROJECT-MAP.md` from the tree.
///
/// Run it after moving or adding files; `tool/check_structure.dart` fails
/// while the map on disk differs from what this would write.
void main() {
  File('PROJECT-MAP.md').writeAsStringSync(buildProjectMap());
  stdout.writeln('project map: written');
}
