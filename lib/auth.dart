/// Optional authentication surface for `frosted_ui_kit`.
///
/// Applications that only need the design-system widgets can import
/// `frosted_ui_kit.dart` without using this facade. The exports remain grouped
/// here so authentication consumers can depend on a smaller, discoverable
/// entry point while all legacy exports stay available from the main library.
library;

// Domain contracts.
export 'src/features/auth/domain/entities/auth_response_entity.dart';
export 'src/features/auth/domain/entities/user_entity.dart';
export 'src/features/auth/domain/repositories/auth_repository.dart';
export 'src/features/auth/domain/usecases/confirm_email_verification_usecase.dart';
export 'src/features/auth/domain/usecases/confirm_password_reset_usecase.dart';
export 'src/features/auth/domain/usecases/login_usecase.dart';
export 'src/features/auth/domain/usecases/register_usecase.dart';
export 'src/features/auth/domain/usecases/request_password_reset_usecase.dart';

// Injectable data adapters and models.
export 'src/features/auth/data/datasources/auth_remote_datasource.dart';
export 'src/features/auth/data/models/auth_response_model.dart';
export 'src/features/auth/data/models/login_request_model.dart';
export 'src/features/auth/data/models/register_request_model.dart';
export 'src/features/auth/data/models/reset_password_request_model.dart';
export 'src/features/auth/data/models/user_model.dart';
export 'src/features/auth/data/repositories/auth_repository_impl.dart';

// Ready-to-use presentation layer.
export 'src/features/auth/presentation/controllers/auth_controller.dart';
export 'src/features/auth/presentation/screen/auth_screen.dart';
export 'src/features/auth/presentation/widgets/forgot_password_form_widget.dart';
export 'src/features/auth/presentation/widgets/login_form_widget.dart';
export 'src/features/auth/presentation/widgets/register_form_widget.dart';
export 'src/features/auth/presentation/widgets/reset_password_form_widget.dart';
export 'src/features/auth/presentation/widgets/verify_email_form_widget.dart';
