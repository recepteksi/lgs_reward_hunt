import 'package:lgs_reward_hunt/core/base/base_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_gender_enum.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_style_enum.dart';

/// One face a child can pick for themselves.
///
/// It is a recipe rather than a picture: five colours and a hair style, which
/// the app draws. That keeps the catalogue a few hundred bytes over the wire
/// instead of a sprite sheet, lets a face be redrawn at any size without going
/// soft, and means a new face is a row in a list rather than an app release.
///
/// [name] is the suggestion that comes with the face, and it is only a
/// suggestion — a child who picks Defne's face and types their own name gets
/// their own name.
///
/// [gender] files the face under one of the setup screen's two tabs, and
/// [isFor] is that filter.
final class AvatarEntity extends BaseEntity {
  const AvatarEntity({
    required this.id,
    required this.name,
    required this.gender,
    required this.style,
    required this.skin,
    required this.hair,
    required this.shirt,
    required this.background,
    this.accessory,
  });

  @override
  final String id;

  final String name;

  final AvatarGenderEnum gender;

  final AvatarStyleEnum style;

  final int skin;

  final int hair;

  final int shirt;

  final int background;

  final int? accessory;

  bool isFor(AvatarGenderEnum filter) => gender == filter;
}
