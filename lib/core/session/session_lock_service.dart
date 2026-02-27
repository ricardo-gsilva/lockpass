class SessionLockService {
  bool _isLocked = false;

  bool get isLocked => _isLocked;

  void lock() => _isLocked = true;
  
  void unlock() {
    _isLocked = false;
  }
}