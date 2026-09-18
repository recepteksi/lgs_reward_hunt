/// What marks a row the user has added on this device but not yet saved.
///
/// The setup steps let a parent add task lines and rewards before anything is
/// sent; such a row needs an id to be edited and removed by, and the server
/// gives it a real one when it is saved. [idPrefix] is how both the row and
/// the repository sending it can tell — one prefix for every kind of draft, so
/// "is this saved yet?" has one answer.
abstract final class DraftRules {
  static const String idPrefix = 'draft_';
}
