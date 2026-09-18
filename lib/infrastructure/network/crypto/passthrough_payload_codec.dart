import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/infrastructure/network/crypto/payload_codec_interface.dart';

/// The codec while there is nothing to encrypt against.
///
/// It returns the body unchanged. That is not a placeholder in the sense of
/// unfinished work — it is the correct implementation for a mock backend
/// running in the same process, where a ciphertext would be encrypted and
/// decrypted by the same key on the same device and would prove nothing.
///
/// What it buys is the seam: `CryptoInterceptor` already runs on every request
/// and response, so turning encryption on is a second implementation of
/// [PayloadCodecInterface] and one binding, not a pass over every repository.
@LazySingleton(as: PayloadCodecInterface)
final class PassthroughPayloadCodec implements PayloadCodecInterface {
  const PassthroughPayloadCodec();

  @override
  Map<String, dynamic> encode(Map<String, dynamic> body) => body;

  @override
  Map<String, dynamic> decode(Map<String, dynamic> body) => body;
}
