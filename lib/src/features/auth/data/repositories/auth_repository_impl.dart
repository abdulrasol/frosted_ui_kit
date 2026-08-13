import 'package:starter/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:starter/src/features/auth/data/models/login_request_model.dart';
import 'package:starter/src/features/auth/data/models/register_request_model.dart';
import 'package:starter/src/features/auth/data/models/reset_password_request_model.dart';
import 'package:starter/src/features/auth/domain/entities/auth_response_entity.dart';
import 'package:starter/src/features/auth/domain/entities/user_entity.dart';
import 'package:starter/src/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository] in the data layer connecting usecases to remote data source.
class AuthRepositoryImpl implements AuthRepository {
  /// Remote data source instance.
  final AuthRemoteDataSource remoteDataSource;

  /// Creates an [AuthRepositoryImpl].
  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthResponseEntity> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequestModel(identity: email, password: password);
    final model = await remoteDataSource.login(request);
    return model.toEntity();
  }

  @override
  Future<UserEntity> register(RegisterRequestModel request) async {
    final model = await remoteDataSource.register(request);
    return model.toEntity();
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    await remoteDataSource.requestPasswordReset(email);
  }

  @override
  Future<void> confirmPasswordReset({
    required String token,
    required String password,
    required String passwordConfirm,
  }) async {
    final request = ResetPasswordRequestModel(
      token: token,
      password: password,
      passwordConfirm: passwordConfirm,
    );
    await remoteDataSource.confirmPasswordReset(request);
  }

  @override
  Future<void> confirmEmailVerification({required String token}) async {
    await remoteDataSource.confirmEmailVerification(token);
  }
}
