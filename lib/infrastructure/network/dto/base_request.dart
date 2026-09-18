/// What every object sent to a service is.
///
/// A request is built from typed fields rather than a map literal, so a key is
/// spelled once and a field the backend renames breaks the build instead of
/// arriving as a 422 nobody can explain.
///
/// It is a separate type from `BaseResponse` on purpose. The two directions are
/// not interchangeable — a response can never be sent and a request is never
/// read back — and giving them one ancestor would let either be passed where
/// the other belongs.
///
/// A request is only ever written, so its `@JsonSerializable` sets
/// `createFactory: false`: no `fromJson` is generated, and none can be called.
///
/// [toJson] is the wire shape. Everything past it is the transport's business:
/// the interceptors are free to wrap this map in an encrypted envelope, and
/// nothing that built the request has to know they did.
abstract class BaseRequest {
  const BaseRequest();

  Map<String, dynamic> toJson();
}
