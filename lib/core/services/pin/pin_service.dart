abstract class PinService {
  Future<bool> hasPin(String userId);
  Future<String?> getPin(String userId);
  Future<void> savePin(String userId, String pin);
  Future<bool> validatePin(String userId, String inputPin);
  Future<void> removePin(String userId);
}
