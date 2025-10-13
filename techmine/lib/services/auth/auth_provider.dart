import 'package:techmine/services/auth/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:techmine/services/auth/models/profile_data.dart';
import 'package:techmine/services/auth/models/token.dart';
import 'package:techmine/services/auth/models/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isCheckingAuth = true;
  bool _isLoggedIn = false;
  String? _accessToken;
  bool _isLoading = false;
  bool _isRegisterLoading = false;
  String? _error;
  bool _isInitialized = false;


  User? get user => _user;
  bool get isCheckingAuth => _isCheckingAuth;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  bool get isRegisterLoading => _isRegisterLoading;
  String? get accessToken => _accessToken;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  Future<void> initializeAuth() async {
    if (_isInitialized) return;

    _isCheckingAuth = true;
    notifyListeners();

    try {
      await checkAuthStatus();
      _isInitialized = true;
    }
    catch (e) {
      _error = e.toString();
      _isInitialized = true;
    }
    finally {
      _isCheckingAuth = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<User?> login(String username, String password) async {

    if (_isLoading) return null;

    _isLoading = true;
    _error = null;
    _user = null;
    _isLoggedIn = false;
    notifyListeners();

    try {
      final accessToken = await _authService.login(username, password);
      if (accessToken != null) {
        await _fetchUser();
        _isLoggedIn = true;
        _error = null;
        notifyListeners();
        return _user;
      }
      else {
        _error = 'Invalid username or password';
        _isLoggedIn = false;
        notifyListeners();
        return null;
      }
      
    }
    catch (e) {
      _error = e.toString();
      _isLoggedIn = false;
      notifyListeners();
      return null;
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  } 

  Future<User?> register(String email, String username, String password, String repeatPassword) async {
    
    if (_isRegisterLoading) return null;

    _isRegisterLoading = true;
    _error = null;
    _user = null;
    notifyListeners();
    
    try {
      final user = await _authService.register(email, username, password);
      if (user != null) {
        final currentUser = await login(username, password);
        _isRegisterLoading = false;
        _error = null;
        return currentUser;
      }
      else {
        _isRegisterLoading = false;
        _error = 'error during login after register. Check registration!';
        return null;
      }
    }
    catch (e) {
      _isRegisterLoading = false;
      _error = e.toString();
      return null;
    }
    finally {
      _isRegisterLoading = false;
      notifyListeners();
    }
  } 

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _error = null;
    _isLoggedIn = false;
    _isLoading = false;
    notifyListeners();
    
  }


  Future<void> checkAuthStatus() async {
    
    // if (_isCheckingAuth) return;

    _isCheckingAuth = true;
    _isLoading = true;
    notifyListeners();

    try {
      final hasValidToken = await _authService.hasValidToken();
      // print(hasValidToken);
      if (hasValidToken) {
        // print(_user);
        await _fetchUser();
        _isCheckingAuth = false;
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoggedIn = false;
        _user = null;
        _isCheckingAuth = false;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      _isLoggedIn = false;
      _user = null;
      _isCheckingAuth = false;
      _isLoading = false;
      notifyListeners();
    } finally {
      _isCheckingAuth = false;
      _isLoading = false;
      notifyListeners();
    }
  }


  /*  */
  Future<void> _fetchUser() async {
    
    _isLoading = true;

    try {
      
      final user = await _authService.getCurrentUser();

      if (user != null) {
        _user = user;
        _isLoggedIn = true;
        _isLoading = false;
        _isCheckingAuth = false;
        notifyListeners();
      }
      else {
        await _authService.logout();
        _user = null;
        _isLoggedIn = false;
        _isLoading = false;
        _isCheckingAuth = false;
        notifyListeners();
      }
    }
    catch (e) {
      await _authService.logout();
      _user = null;
      _isLoggedIn = false;
      _isLoading = false;
      _isCheckingAuth = false;
      notifyListeners();
      rethrow;
    }

  }

  Future<ProfileData?> getUserProfile() async {
    _isLoading = true;
    
    if (_isLoggedIn) {
      final profile = await _authService.getProfile();
      _isLoading = false;
      notifyListeners();
      return profile;
    }
    else {
      await checkAuthStatus();
      return null;
    }
  }

}