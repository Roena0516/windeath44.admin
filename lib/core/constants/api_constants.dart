class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://prod.windeath44.wiki/api';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String verify = '/auth/verify';
  static const String emailVerify = '/auth/email';
  static const String emailValid = '/auth/email/valid';

  // User endpoints
  static const String users = '/users';
  static const String usersAdmin = '/users/admin';
  static const String userProfile = '/users/profile';
  static const String registerUser = '/users/register';
  static const String registerAdmin = '/users/register/admin';
  static const String changeProfile = '/users/change/profile';
  static const String changeName = '/users/change/name';
  static const String retrieveUserId = '/users/retrieve/userId';
  static const String retrievePassword = '/users/retrieve/password';

  // Health endpoint
  static const String health = '/health';

  // Observability URLs
  static const String grafanaUrl = 'https://prod.windeath44.wiki/admin/grafana/login';
  static const String argoCdUrl = 'https://prod.windeath44.wiki/admin/argocd/';
  static const String kialiUrl = 'https://prod.windeath44.wiki/admin/kiali';
  static const String prometheusUrl = 'https://prod.windeath44.wiki/admin/prometheus';
  static const String kafkaUiUrl = 'https://prod.windeath44.wiki/admin/kafka-ui';

  // Storage keys
  static const String authTokenKey = 'auth_token';
}
