import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/radix_constants.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_gender_enum.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_style_enum.dart';
import 'package:lgs_reward_hunt/domain/avatar/interfaces/avatar_repository_interface.dart';
import 'package:lgs_reward_hunt/infrastructure/avatar/dto/avatar_response_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/network/api_paths.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/network/failure_from_dio.dart';

/// The catalogue of faces, fetched.
///
/// Colours arrive as `#RRGGBB` strings and become opaque ints here, which is
/// the one piece of translation this file does: the wire speaks CSS and Flutter
/// speaks ARGB, and a screen should know about neither.
///
/// A face whose style the app has never heard of still renders — the enum falls
/// back rather than failing — because a catalogue is content and content ships
/// ahead of the app that reads it.
@LazySingleton(as: AvatarRepositoryInterface)
final class AvatarRepository implements AvatarRepositoryInterface {
  const AvatarRepository(this._client);

  static const int _opaque = 0xFF000000;

  static const String _hexPrefix = '#';

  final DioClient _client;

  @override
  Future<Either<Failure, List<AvatarEntity>>> catalog() async {
    try {
      final response = await _client.dio.get<List<dynamic>>(ApiPaths.avatars);

      return Right(
        response.data!
            .map(
              (dynamic row) => _avatarFrom(
                AvatarResponseDto.fromJson(
                  Map<String, dynamic>.from(row as Map),
                ),
              ),
            )
            .toList(),
      );
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  AvatarEntity _avatarFrom(AvatarResponseDto dto) => AvatarEntity(
    id: dto.id,
    name: dto.name,
    gender: AvatarGenderEnum.fromName(dto.gender),
    style: AvatarStyleEnum.fromName(dto.style),
    skin: _colour(dto.skin),
    hair: _colour(dto.hair),
    shirt: _colour(dto.shirt),
    background: _colour(dto.background),
    accessory: dto.accessory == null ? null : _colour(dto.accessory!),
  );

  int _colour(String hex) =>
      _opaque |
      int.parse(
        hex.replaceFirst(_hexPrefix, CharConstants.empty),
        radix: RadixConstants.hexadecimal,
      );
}
