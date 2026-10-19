/// What a household may hold.
///
/// Rules rather than measurements, so they sit beside the auth and points rules
/// in `core/`. Each is enforced in the domain before a request is sent and
/// again by the server, and a screen reads the same constant to explain the
/// limit rather than repeating the number in its copy.
///
/// [maxChildren] is two for now: every child carries their own map, balance and
/// streak, and the parent side is designed around switching between two, not
/// scrolling a list. [gradeLevels] are the two years that use the app — the one
/// sitting the LGS and the one below it starting early — and
/// [defaultGradeLevel] is the year sitting it.
abstract final class AccountRules {
  static const int maxChildren = 2;

  static const int seventhGrade = 7;

  static const int eighthGrade = 8;

  static const List<int> gradeLevels = <int>[seventhGrade, eighthGrade];

  static const int defaultGradeLevel = eighthGrade;
}
