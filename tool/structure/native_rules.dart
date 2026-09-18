import 'dart:convert';
import 'dart:io';

/// The platform wiring that a regenerating tool can silently undo.
///
/// Each check is a failure this project has already had or narrowly avoided:
/// a flavor build configuration with no signing team, a Google client that is
/// not the one in the flavor's `GoogleService-Info.plist`, an Android app with
/// no SHA-1 registered (Google sign-in fails only on a device), Sign in with
/// Apple missing from the entitlements, and flavorizr's `buildSettings`
/// drifting from the xcconfig it would regenerate.
List<String> nativeRules() {
  final String pubspec = File('pubspec.yaml').readAsStringSync();
  final List<String> problems = <String>[];

  for (final String flavor in _flavors(pubspec)) {
    problems
      ..addAll(_ios(flavor, pubspec))
      ..addAll(_android(flavor, pubspec));
  }

  final File entitlements = File('ios/Runner/Runner.entitlements');
  if (!entitlements.existsSync() ||
      !entitlements.readAsStringSync().contains(
        'com.apple.developer.applesignin',
      )) {
    problems.add(
      'ios/Runner/Runner.entitlements  must grant com.apple.developer.applesignin',
    );
  }
  final String info = File('ios/Runner/Info.plist').readAsStringSync();
  for (final String variable in <String>[
    r'$(GOOGLE_CLIENT_ID)',
    r'$(GOOGLE_REVERSED_CLIENT_ID)',
  ]) {
    if (!info.contains(variable)) {
      problems.add('ios/Runner/Info.plist  must read $variable');
    }
  }
  return problems;
}

List<String> _flavors(String pubspec) {
  final int start = pubspec.indexOf('\n  flavors:\n');
  if (start == -1) return <String>[];
  return RegExp(r'^    (\w+):$', multiLine: true)
      .allMatches(pubspec.substring(start))
      .map((RegExpMatch match) => match.group(1)!)
      .toList();
}

String _flavorBlock(String pubspec, String flavor) {
  final int start = pubspec.indexOf('\n    $flavor:\n');
  final int next = pubspec.indexOf(RegExp(r'\n    \w+:\n'), start + 1);
  return pubspec.substring(start, next == -1 ? pubspec.length : next);
}

String? _plistValue(String plist, String key) =>
    RegExp('<key>$key</key>\\s*<string>([^<]*)</string>')
        .firstMatch(plist)
        ?.group(1);

List<String> _ios(String flavor, String pubspec) {
  final List<String> problems = <String>[];
  final File plist = File('ios/config/$flavor/GoogleService-Info.plist');
  if (!plist.existsSync()) {
    return <String>['${plist.path}  missing — run flutterfire configure'];
  }
  final String google = plist.readAsStringSync();
  final Map<String, String?> expected = <String, String?>{
    'GOOGLE_CLIENT_ID': _plistValue(google, 'CLIENT_ID'),
    'GOOGLE_REVERSED_CLIENT_ID': _plistValue(google, 'REVERSED_CLIENT_ID'),
    'CODE_SIGN_ENTITLEMENTS': 'Runner/Runner.entitlements',
  };
  final String block = _flavorBlock(pubspec, flavor);

  for (final String config in <String>['Debug', 'Profile', 'Release']) {
    final File xcconfig = File('ios/Flutter/$flavor$config.xcconfig');
    if (!xcconfig.existsSync()) {
      problems.add('${xcconfig.path}  missing');
      continue;
    }
    final String text = xcconfig.readAsStringSync();
    if (!RegExp(r'^DEVELOPMENT_TEAM=\w+', multiLine: true).hasMatch(text)) {
      problems.add(
        '${xcconfig.path}  DEVELOPMENT_TEAM is not set — the build cannot be signed',
      );
    }
    for (final MapEntry<String, String?> entry in expected.entries) {
      if (entry.value == null ||
          !text.contains('${entry.key}=${entry.value}')) {
        problems.add('${xcconfig.path}  ${entry.key} must be ${entry.value}');
      }
    }
  }
  for (final MapEntry<String, String?> entry in expected.entries) {
    if (entry.value == null ||
        !block.contains('${entry.key}: "${entry.value}"')) {
      problems.add(
        'pubspec.yaml  flavorizr $flavor buildSettings must carry ${entry.key}, or a flavorizr run drops it',
      );
    }
  }
  return problems;
}

List<String> _android(String flavor, String pubspec) {
  final File file = File('android/app/src/$flavor/google-services.json');
  if (!file.existsSync()) {
    return <String>['${file.path}  missing — run flutterfire configure'];
  }
  final String? applicationId = RegExp(r'applicationId: "([^"]+)"')
      .firstMatch(_flavorBlock(pubspec, flavor))
      ?.group(1);
  final Map<String, dynamic> json =
      jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

  for (final dynamic client in json['client'] as List<dynamic>) {
    final Map<String, dynamic> entry = client as Map<String, dynamic>;
    final Map<String, dynamic> info =
        entry['client_info'] as Map<String, dynamic>;
    final String package =
        (info['android_client_info'] as Map<String, dynamic>)['package_name']
            as String;
    if (package != applicationId) continue;
    final bool signed = (entry['oauth_client'] as List<dynamic>).any(
      (dynamic oauth) => (oauth as Map<String, dynamic>)['client_type'] == 1,
    );
    return signed
        ? <String>[]
        : <String>[
            '${file.path}  no Android OAuth client for $package — register the SHA-1 in Firebase and refresh the file',
          ];
  }
  return <String>['${file.path}  has no client for $applicationId'];
}
