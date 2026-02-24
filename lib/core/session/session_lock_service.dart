// class SessionLockService {
//   bool _isLocked = false;
//   bool _isNavigationInProgress = false;

//   bool get isLocked => _isLocked;
//   bool get isNavigationInProgress => _isNavigationInProgress;

//   void lock() => _isLocked = true;
  
//   void unlock() {
//     _isLocked = false;
//     _isNavigationInProgress = false;
//   }

//   void setNavigationInProgress(bool value) {
//     _isNavigationInProgress = value;
//   }
// }

class SessionLockService {
  bool _isLocked = false;

  bool get isLocked => _isLocked;

  void lock() => _isLocked = true;
  
  void unlock() {
    _isLocked = false;
  }  
}