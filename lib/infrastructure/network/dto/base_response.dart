/// What every object read back from a service is.
///
/// Reading happens once, in one place, where a missing key or a changed type is
/// answered immediately rather than surfacing as a null three screens later.
/// The repository that fetched it turns it into an entity; nothing above the
/// repository ever sees one of these.
///
/// [toJson] exists for the round trip — logging a response, replaying one in a
/// test — and not because anything sends one.
abstract class BaseResponse {
  const BaseResponse();

  Map<String, dynamic> toJson();
}
