import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';
import 'storage_service.dart';
import '../config/constants.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final StorageService _storage = StorageService();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Estado actual del usuario
  User? _currentUser;
  User? get currentUser => _currentUser;

  // Stream para escuchar cambios en el estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges().map((firebaseUser) {
        return firebaseUser == null ? null : _userFromFirebaseUser(firebaseUser);
      });

  // Convertir FirebaseUser a nuestro modelo User
  User _userFromFirebaseUser(firebase_auth.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      nombre: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL,
      fechaRegistro: DateTime.now(),
    );
  }

  // Iniciar sesión con email y contraseña
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        _currentUser = _userFromFirebaseUser(result.user!);
        await _storage.saveUser(_currentUser!);
        return _currentUser!;
      }

      throw Exception('Error al iniciar sesión');
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  // Registrar nuevo usuario
  Future<User> signUpWithEmailAndPassword(
    String email,
    String password,
    String nombre,
  ) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Actualizar el nombre del usuario
        await result.user!.updateDisplayName(nombre);

        // Crear el usuario en nuestra base de datos
        _currentUser = _userFromFirebaseUser(result.user!);
        await _storage.saveUser(_currentUser!);
        return _currentUser!;
      }

      throw Exception('Error al crear la cuenta');
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _storage.removeUser();
      await _storage.removeToken();
      _currentUser = null;
    } catch (e) {
      throw Exception('Error al cerrar sesión');
    }
  }

  // Recuperar contraseña
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  // Actualizar perfil
  Future<void> updateProfile({
    String? nombre,
    String? email,
    String? photoUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No hay usuario autenticado');

      if (nombre != null) {
        await user.updateDisplayName(nombre);
      }
      if (email != null) {
        await user.updateEmail(email);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // Actualizar usuario local
      _currentUser = _userFromFirebaseUser(user);
      await _storage.saveUser(_currentUser!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  // Cambiar contraseña
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No hay usuario autenticado');

      // Reautenticar usuario
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Cambiar contraseña
      await user.updatePassword(newPassword);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  // Eliminar cuenta
  Future<void> deleteAccount(String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No hay usuario autenticado');

      // Reautenticar usuario
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // Eliminar cuenta
      await user.delete();
      await _storage.clearAll();
      _currentUser = null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  // Verificar email
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No hay usuario autenticado');
      await user.sendEmailVerification();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  // Manejo de errores de Firebase Auth
  String _handleFirebaseAuthError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'El correo electrónico no es válido';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada';
      case 'user-not-found':
        return 'No existe una cuenta con este correo electrónico';
      case 'wrong-password':
        return 'La contraseña es incorrecta';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este correo electrónico';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres';
      case 'requires-recent-login':
        return 'Esta operación es sensible y requiere autenticación reciente';
      default:
        return AppConstants.genericError;
    }
  }

  // Verificar estado de la sesión
  Future<bool> isLoggedIn() async {
    final user = _auth.currentUser;
    if (user != null) {
      _currentUser = _userFromFirebaseUser(user);
      return true;
    }
    return false;
  }

  // Obtener token de autenticación
  Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }
}
