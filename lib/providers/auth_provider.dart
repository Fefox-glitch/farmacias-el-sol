import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/service_locator.dart';
import 'base_provider.dart';

class AuthProvider extends BaseProvider {
  User? _currentUser;
  bool _isInitialized = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      setStatus(Status.loading);
      
      // Verificar si hay una sesión activa
      final isLoggedIn = await authService.isLoggedIn();
      if (isLoggedIn) {
        _currentUser = await storageService.getUser();
      }

      _isInitialized = true;
      setStatus(Status.success);
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> signIn(String email, String password) async {
    await handleFuture(() async {
      _currentUser = await authService.signInWithEmailAndPassword(
        email,
        password,
      );
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password, String nombre) async {
    await handleFuture(() async {
      _currentUser = await authService.signUpWithEmailAndPassword(
        email,
        password,
        nombre,
      );
      notifyListeners();
    });
  }

  Future<void> signOut() async {
    await handleFuture(() async {
      await authService.signOut();
      _currentUser = null;
      notifyListeners();
    });
  }

  Future<void> resetPassword(String email) async {
    await handleFuture(() async {
      await authService.resetPassword(email);
    });
  }

  Future<void> updateProfile({
    String? nombre,
    String? email,
    String? photoUrl,
  }) async {
    await handleFuture(() async {
      await authService.updateProfile(
        nombre: nombre,
        email: email,
        photoUrl: photoUrl,
      );
      
      // Actualizar usuario local
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          nombre: nombre ?? _currentUser!.nombre,
          email: email ?? _currentUser!.email,
          photoUrl: photoUrl ?? _currentUser!.photoUrl,
        );
        await storageService.saveUser(_currentUser!);
        notifyListeners();
      }
    });
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    await handleFuture(() async {
      await authService.changePassword(currentPassword, newPassword);
    });
  }

  Future<void> deleteAccount(String password) async {
    await handleFuture(() async {
      await authService.deleteAccount(password);
      _currentUser = null;
      notifyListeners();
    });
  }

  Future<void> verifyEmail() async {
    await handleFuture(() async {
      await authService.sendEmailVerification();
    });
  }

  Future<void> refreshUser() async {
    if (_currentUser != null) {
      await handleFuture(() async {
        final user = await storageService.getUser();
        if (user != null) {
          _currentUser = user;
          notifyListeners();
        }
      });
    }
  }

  // Manejo de dependientes
  Future<void> addDependent(Map<String, dynamic> dependentData) async {
    if (_currentUser == null) return;

    await handleFuture(() async {
      final updatedUser = await apiService.addDependent(
        _currentUser!.id,
        dependentData,
      );
      _currentUser = updatedUser;
      await storageService.saveUser(updatedUser);
      notifyListeners();
    });
  }

  Future<void> removeDependent(String dependentId) async {
    if (_currentUser == null) return;

    await handleFuture(() async {
      await apiService.removeDependent(_currentUser!.id, dependentId);
      _currentUser = _currentUser!.copyWith(
        dependientes: _currentUser!.dependientes
            .where((d) => d.id != dependentId)
            .toList(),
      );
      await storageService.saveUser(_currentUser!);
      notifyListeners();
    });
  }

  // Manejo de alergias y condiciones médicas
  Future<void> updateMedicalInfo({
    List<String>? alergias,
    Map<String, String>? condicionesMedicas,
  }) async {
    if (_currentUser == null) return;

    await handleFuture(() async {
      final updatedUser = await apiService.updateUserProfile(
        _currentUser!.id,
        {
          if (alergias != null) 'alergias': alergias,
          if (condicionesMedicas != null)
            'condicionesMedicas': condicionesMedicas,
        },
      );
      _currentUser = updatedUser;
      await storageService.saveUser(updatedUser);
      notifyListeners();
    });
  }
}
