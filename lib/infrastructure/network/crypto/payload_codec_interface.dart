/// How a body is turned into what actually goes on the wire, and back.
///
/// The seam for encryption. Everything above it — repositories, DTOs, use
/// cases — builds and reads plain maps; whether those maps travel as JSON or as
/// an AES envelope is decided here and nowhere else.
///
/// It is an interface with one implementation today on purpose. When the
/// backend arrives with a key exchange, the change is a second implementation
/// and one line in the DI container: no repository is touched, and no test that
/// exercises a repository has to know encryption happened.
///
/// [encode] runs on the way out and [decode] on the way back, and they must be
/// exact inverses — a codec that loses a field is a bug that only shows up on a
/// screen nobody opened yet.
abstract interface class PayloadCodecInterface {
  Map<String, dynamic> encode(Map<String, dynamic> body);

  Map<String, dynamic> decode(Map<String, dynamic> body);
}
