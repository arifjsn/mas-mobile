class AppConstants {
  static const String appName = 'Mitra-Asset System';
  static const String baseUrl = 'https://mas.jasanet.co.id';
  static const String apiBase = '$baseUrl/api';

  // API Endpoints
  static const String loginUrl = '$apiBase/auth.php?action=login';
  static const String profileUrl = '$apiBase/profile.php';
  static const String attendancesUrl = '$apiBase/attendances.php';
  static const String servicesUrl = '$apiBase/services.php';
  static const String customerReportsUrl = '$apiBase/customer_reports.php';
  static const String companiesUrl = '$apiBase/companies.php';

  // Work Schedule
  static const int workStartHour = 10; // 10:00 WIB
  static const int workEndHour = 18;   // 18:00 WIB
  static const int weekendOvertimeBonus = 100000; // Rp 100k
}
