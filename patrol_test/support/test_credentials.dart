class PatrolTestCredentials {
  static const googleEmail = String.fromEnvironment('PATROL_GOOGLE_TEST_EMAIL');
  static const googlePassword = String.fromEnvironment('PATROL_GOOGLE_TEST_PASSWORD');

  static const testUserEmail = String.fromEnvironment('TEST_USER_EMAIL');
  static const testUserPassword = String.fromEnvironment('TEST_USER_PASSWORD');
  static const testAdminEmail = String.fromEnvironment('TEST_ADMIN_EMAIL');
  static const testAdminPassword = String.fromEnvironment('TEST_ADMIN_PASSWORD');

  static bool get hasGooglePassword => googlePassword.isNotEmpty;

  static void validateGoogleLogin() {
    if (googleEmail.isEmpty) {
      throw StateError(
        'PATROL_GOOGLE_TEST_EMAIL must be provided. Load it from .env.test via the Patrol runner script.',
      );
    }
  }
}