/// `frosted_ui_kit` - Premium Flutter UI system combining Apple Liquid Glass aesthetics
/// with Telegram modern Android UI fluidity.
library;

// Shared Glassmorphic UI Widgets
export 'src/shared/widgets/app_bar.dart';
export 'src/shared/widgets/base_widget.dart';
export 'src/shared/widgets/bottom_sheet.dart';
export 'src/shared/widgets/navigation_bar.dart';
export 'src/shared/widgets/buttons.dart';
export 'src/shared/widgets/cards.dart';
export 'src/shared/widgets/loading.dart';
export 'src/shared/widgets/loading_button.dart';
export 'src/shared/widgets/inputs.dart';
export 'src/shared/widgets/stepper.dart';
export 'src/shared/widgets/tabs.dart';
export 'src/shared/widgets/list_tile.dart';
export 'src/shared/widgets/dialogs.dart';

// Extensions
export 'src/extensions/context.dart';

// Localization
export 'src/core/l10n/arb/app_localizations.dart';

// Auth Feature - Domain Layer
export 'src/features/auth/domain/entities/auth_response_entity.dart';
export 'src/features/auth/domain/entities/user_entity.dart';
export 'src/features/auth/domain/repositories/auth_repository.dart';
export 'src/features/auth/domain/usecases/confirm_email_verification_usecase.dart';
export 'src/features/auth/domain/usecases/confirm_password_reset_usecase.dart';
export 'src/features/auth/domain/usecases/login_usecase.dart';
export 'src/features/auth/domain/usecases/register_usecase.dart';
export 'src/features/auth/domain/usecases/request_password_reset_usecase.dart';

// Auth Feature - Data Layer
export 'src/features/auth/data/datasources/auth_remote_datasource.dart';
export 'src/features/auth/data/models/auth_response_model.dart';
export 'src/features/auth/data/models/login_request_model.dart';
export 'src/features/auth/data/models/register_request_model.dart';
export 'src/features/auth/data/models/reset_password_request_model.dart';
export 'src/features/auth/data/models/user_model.dart';
export 'src/features/auth/data/repositories/auth_repository_impl.dart';

// Auth Feature - Presentation Layer
export 'src/features/auth/presentation/controllers/auth_controller.dart';
export 'src/features/auth/presentation/screen/auth_screen.dart';
export 'src/features/auth/presentation/widgets/forgot_password_form_widget.dart';
export 'src/features/auth/presentation/widgets/login_form_widget.dart';
export 'src/features/auth/presentation/widgets/register_form_widget.dart';
export 'src/features/auth/presentation/widgets/reset_password_form_widget.dart';
export 'src/features/auth/presentation/widgets/verify_email_form_widget.dart';
