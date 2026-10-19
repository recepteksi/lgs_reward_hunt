/// The project's vocabulary, stated once for every rule and for the map.
///
/// Changing a list here is changing a rule: add a feature to [features] (and
/// to CLAUDE.md) before creating its folder.
abstract final class Conventions {
  static const List<String> layers = <String>[
    'core',
    'domain',
    'application',
    'infrastructure',
    'presentation',
  ];

  static const List<String> features = <String>[
    'account',
    'auth',
    'avatar',
    'exam',
    'parent',
    'points',
    'profile',
    'progress',
    'reward',
    'session',
    'settings',
    'study_path',
    'task',
  ];

  static const Map<String, List<String>> sharedFolders = <String, List<String>>{
    'core': <String>['base', 'constants', 'failure', 'validators'],
    'domain': <String>[],
    'application': <String>['di'],
    'infrastructure': <String>['config', 'network'],
    'presentation': <String>['base', 'debug', 'router'],
  };

  static const Map<String, Map<String, String>> featureKinds =
      <String, Map<String, String>>{
        'core': <String, String>{},
        'domain': <String, String>{
          'entities': '_entity.dart',
          'value_objects': '_value_object.dart',
          'read_models': '_read_model.dart',
          'enums': '_enum.dart',
          'interfaces': '_interface.dart',
          'rules': '_rules.dart',
          'validators': '_validator.dart',
        },
        'application': <String, String>{
          'use_cases': '_use_case.dart',
          'cubit': '',
        },
        'infrastructure': <String, String>{
          'repositories': '_repository.dart',
          'services': '_service.dart',
          'dto': '_dto.dart',
          'mock': '_handler.dart',
        },
        'presentation': <String, String>{'pages': ''},
      };

  static const Map<String, String> baseOf = <String, String>{
    '_entity.dart': 'BaseEntity',
    '_value_object.dart': 'BaseValueObject<',
    '_read_model.dart': 'BaseReadModel',
    '_validator.dart': 'BaseValueValidator<',
  };

  static const List<String> pageFolders = <String>[
    'body',
    'items',
    'widgets',
    'app_bar',
    'modal_bottom_sheet',
  ];

  static const List<String> appWideCubits = <String>['appearance'];

  static const Map<String, List<String>> mayImport = <String, List<String>>{
    'core': <String>['core'],
    'domain': <String>['core', 'domain'],
    'application': <String>['core', 'domain', 'application'],
    'infrastructure': <String>['core', 'domain', 'infrastructure'],
    'presentation': <String>['core', 'domain', 'application', 'presentation'],
  };
}
