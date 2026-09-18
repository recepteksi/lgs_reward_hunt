import 'package:equatable/equatable.dart';

/// A snapshot assembled from several entities for one purpose — a household,
/// a study map, a parent's dashboard.
///
/// It is not a value object: it has no rules of its own to validate, only
/// derivations over the entities it holds. It is not an entity: nothing
/// tracks it, and the next load builds a new one. What it shares with a value
/// object is equality by content, through `Equatable` — a subclass lists every
/// field in `props` — so a page that reloads the same household does not
/// rebuild for nothing.
abstract class BaseReadModel extends Equatable {
  const BaseReadModel();
}
