/// Lightweight localization for Vietnamese (default) and English.
///
/// Usage:
/// ```dart
/// final s = AppStrings.of(context);
/// Text(s.campaign)
/// ```
import 'package:flutter/material.dart';

// ── Locale constants ────────────────────────────────────────────────────────

const localeVi = Locale('vi');
const localeEn = Locale('en');

// ── InheritedWidget scope ────────────────────────────────────────────────────

class AppLocale extends InheritedWidget {
  const AppLocale({
    required this.locale,
    required this.notifier,
    required super.child,
    super.key,
  });

  final Locale locale;
  final ValueNotifier<Locale> notifier;

  static AppLocale of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppLocale>()!;
  }

  /// Current locale, re-subscribes widget on change.
  static Locale currentLocale(BuildContext context) => of(context).locale;

  /// String table for the current locale.
  static AppStrings strings(BuildContext context) {
    // Force rebuild when locale changes via dependOnInheritedWidgetOfExactType
    return currentLocale(context) == localeEn ? _en : _vi;
  }

  @override
  bool updateShouldNotify(AppLocale oldWidget) =>
      oldWidget.locale != locale;
}

/// Convenience extension so any widget can call `context.l10n`.
extension AppLocaleX on BuildContext {
  AppStrings get l10n => AppLocale.strings(this);
  Locale get appLocale => AppLocale.currentLocale(this);
  ValueNotifier<Locale> get localeNotifier => AppLocale.of(this).notifier;
}

// ── String tables ────────────────────────────────────────────────────────────

abstract class AppStrings {
  const AppStrings();

  // ── Common ──────────────────────────────────────────────────────────────
  String get cancel;
  String get save;
  String get delete;
  String get confirm;
  String get back;
  String get close;
  String get search;
  String get loading;
  String get noData;
  String get error;
  String get success;
  String get refresh;
  String get create;
  String get edit;
  String get clear;

  // ── Language toggle ──────────────────────────────────────────────────────
  String get languageVietnamese;
  String get languageEnglish;
  String get switchLanguage;

  // ── Navigation ───────────────────────────────────────────────────────────
  String get map;
  String get campaign;
  String get manageUsers;
  String get overview;
  String get notifications;
  String get account;
  String get profile;
  String get logout;

  // ── Map controls ─────────────────────────────────────────────────────────
  String get recenterVietnam;
  String get zoomIn;
  String get zoomOut;
  String get myLocation;
  String get mapStyleLight;
  String get mapStyleDark;
  String get mapStyleSatellite;
  String get choroplethOn;
  String get choroplethOff;
  String get filterEvents;
  String get filterActive;

  // ── Province / location ──────────────────────────────────────────────────
  String get province;
  String get district;
  String get commune;
  String get city;
  String get noProvinceSelected;

  // ── Campaign panel ───────────────────────────────────────────────────────
  String get campaigns;
  String get createCampaign;
  String get editCampaign;
  String get deleteCampaign;
  String get campaignName;
  String get campaignStatus;
  String get campaignDescription;
  String get selectCampaign;
  String get searchCampaignHint;
  String get campaignListAndStatsHint;
  String get createNewCampaignTitle;
  String get statusActive;
  String get searchEventHint;
  String get selectCampaignHint;
  String get noCampaigns;

  // ── Event form ────────────────────────────────────────────────────────────
  String get createEvent;
  String get editEvent;
  String get eventName;
  String get eventDate;
  String get eventLocation;
  String get eventStatus;
  String get eventHost;
  String get noHost;
  String get latitude;
  String get longitude;
  String get useCurrentLocation;
  String get employees;
  String get employeeSearch;
  String get noEmployeeFound;
  String get assignedEmployees;
  String get isHost;

  // ── Status labels ─────────────────────────────────────────────────────────
  String get statusInProgress;
  String get statusPreparing;
  String get statusCompleted;
  String get statusCanceled;

  // ── Event filter sheet ────────────────────────────────────────────────────
  String get filterSheet;
  String get filterByStatus;
  String get clearFilter;
  String get filteringCount;

  // ── Choropleth legend ─────────────────────────────────────────────────────
  String get eventDensity;
  String get densityOne;
  String get densityTwo;
  String get densityFour;
  String get densitySeven;

  // ── Check-in / Check-out ──────────────────────────────────────────────────
  String get checkIn;
  String get checkOut;
  String get interaction;
  String get interactions;

  // ── Stats Dashboard ───────────────────────────────────────────────────────
  String get users;
  String get provinces;
  String get populationMillions;
  String get areaSqKm;
  String get avgDensity;
  String get top10Population;
  String get top10Area;
  String get top10Density;
  String get regionDistribution;
  String get unitClassification;
  String get exportPdf;
  String get exporting;

  // ── User Management ───────────────────────────────────────────────────────
  String get searchByEmailOrName;
  String get role;
  String get status;
  String get all;
  String get active;
  String get disabled;
  String get sortBy;
  String get fullName;
  String get email;
  String get sortAsc;
  String get sortDesc;
  String get retry;
  String get noOtherUsers;
  String get noResultsFound;
  String get unnamed;
  String get confirmDelete;
  String get deleteUserConfirmText;
  String get cannotUpdate;
  String get cannotDelete;
  String get deletedUser;

  // ── Regional Names (Stats) ────────────────────────────────────────────────
  String get regionRedRiverDelta;
  String get regionNorthernMidlands;
  String get regionCentralCoast;
  String get regionCentralHighlands;
  String get regionSoutheast;
  String get regionMekongDelta;
  String get exportPdfSuccess;
  String get openPdf;
  String get exportPdfError;

  // ── Firebase Demo ─────────────────────────────────────────────────────────
  String get crashlyticsMobileOnly;
  String get crashlyticsTestSent;
  String get crashlyticsHandledSuccess;

  // ── Campaign Management ───────────────────────────────────────────────────
  String get employee;
  String get unknown;
  String get unknownDate;
  String get unknownTime;
  String get student;
  String get parent;
  String get schoolStaff;
  String get teacher;
  String get principal;
  String get school;
  String get phoneNumber;
  String get notUpdated;

  // ── Notifications ─────────────────────────────────────────────────────────
  String get filterCreated;
  String get filterUpdated;
  String get filterEnded;
  String get markAllAsRead;
  String get notificationsTitle;
  
  // Sidebar
  String get firebaseDemo;
  String get noNotifications;
  String get noNotificationsOfType;
  String get cannotOpenCampaign;
  String get eventsListTitle;
  String get noEventsYet;
  String get fromDate;
  String get toDate;
  String get relatedNotification;
}

// ── Vietnamese ────────────────────────────────────────────────────────────────

class _Vi extends AppStrings {
  const _Vi();

  @override String get cancel => 'Hủy';
  @override String get save => 'Lưu';
  @override String get delete => 'Xóa';
  @override String get confirm => 'Xác nhận';
  @override String get back => 'Quay lại';
  @override String get close => 'Đóng';
  @override String get search => 'Tìm kiếm';
  @override String get loading => 'Đang tải...';
  @override String get noData => 'Không có dữ liệu';
  @override String get error => 'Đã xảy ra lỗi';
  @override String get success => 'Thành công';
  @override String get refresh => 'Làm mới';
  @override String get create => 'Tạo mới';
  @override String get edit => 'Chỉnh sửa';
  @override String get clear => 'Xóa bộ lọc';

  @override String get languageVietnamese => 'VI';
  @override String get languageEnglish => 'EN';
  @override String get switchLanguage => 'Chuyển ngôn ngữ';

  @override String get map => 'Bản đồ';
  @override String get campaign => 'Chiến dịch';
  @override String get manageUsers => 'Quản lí người dùng';
  @override String get overview => 'Tổng Quan';
  @override String get notifications => 'Thông báo';
  @override String get account => 'Tài khoản';
  @override String get profile => 'Hồ sơ cá nhân';
  @override String get logout => 'Đăng xuất';

  @override String get recenterVietnam => 'Căn giữa về Việt Nam';
  @override String get zoomIn => 'Phóng to';
  @override String get zoomOut => 'Thu nhỏ';
  @override String get myLocation => 'Vị trí của tôi';
  @override String get mapStyleLight => 'Sáng';
  @override String get mapStyleDark => 'Tối';
  @override String get mapStyleSatellite => 'Vệ tinh';
  @override String get choroplethOn => 'Tắt bản đồ mật độ';
  @override String get choroplethOff => 'Bật bản đồ mật độ sự kiện';
  @override String get filterEvents => 'Lọc sự kiện trên bản đồ';
  @override String get filterActive => 'Đang lọc sự kiện — bấm để chỉnh';

  @override String get province => 'Tỉnh/Thành phố';
  @override String get district => 'Quận/Huyện';
  @override String get commune => 'Phường/Xã';
  @override String get city => 'Thành phố';
  @override String get noProvinceSelected => 'Chưa chọn tỉnh';

  @override String get campaigns => 'Chiến dịch';
  @override String get createCampaign => 'Tạo chiến dịch';
  @override String get editCampaign => 'Sửa chiến dịch';
  @override String get deleteCampaign => 'Xóa chiến dịch';
  @override String get campaignName => 'Tên chiến dịch';
  @override String get campaignStatus => 'Trạng thái';
  @override String get campaignDescription => 'Mô tả';
  @override String get selectCampaign => 'Chọn một chiến dịch';
  @override String get searchCampaignHint => 'Tìm kiếm chiến dịch...';
  @override String get campaignListAndStatsHint => 'Danh sách sự kiện và thống kê chi tiết sẽ hiển thị ở đây.';
  @override String get createNewCampaignTitle => 'Tạo chiến dịch mới';
  @override String get statusActive => 'Hoạt động';
  @override String get searchEventHint => 'Tìm kiếm sự kiện...';
  @override String get selectCampaignHint => 'Danh sách sự kiện và thống kê chi tiết sẽ hiển thị ở đây.';
  @override String get noCampaigns => 'Chưa có chiến dịch nào';

  @override String get createEvent => 'Tạo event';
  @override String get editEvent => 'Sửa event';
  @override String get eventName => 'Tên event';
  @override String get eventDate => 'Ngày diễn ra';
  @override String get eventLocation => 'Địa điểm';
  @override String get eventStatus => 'Trạng thái';
  @override String get eventHost => 'Người chủ trì (Main Host)';
  @override String get noHost => 'Chưa phân công host';
  @override String get latitude => 'Vĩ độ (Lat)';
  @override String get longitude => 'Kinh độ (Lng)';
  @override String get useCurrentLocation => 'Lấy vị trí hiện tại';
  @override String get employees => 'Nhân viên';
  @override String get employeeSearch => 'Tìm nhân viên...';
  @override String get noEmployeeFound => 'Không tìm thấy nhân viên';
  @override String get assignedEmployees => 'Nhân viên phụ trách';
  @override String get isHost => 'Đang là Người chủ trì (Host)';

  @override String get statusInProgress => 'Đang diễn ra';
  @override String get statusPreparing => 'Sắp diễn ra';
  @override String get statusCompleted => 'Đã kết thúc';
  @override String get statusCanceled => 'Đã hủy';

  @override String get filterSheet => 'Lọc sự kiện trên bản đồ';
  @override String get filterByStatus => 'Trạng thái sự kiện';
  @override String get clearFilter => 'Xóa bộ lọc';
  @override String get filteringCount => 'Đang hiển thị';

  @override String get eventDensity => 'Mật độ sự kiện';
  @override String get densityOne => '1 sự kiện';
  @override String get densityTwo => '2–3 sự kiện';
  @override String get densityFour => '4–6 sự kiện';
  @override String get densitySeven => '7+ sự kiện';

  @override String get checkIn => 'Check-in';
  @override String get checkOut => 'Check-out';
  @override String get interaction => 'Tương tác';
  @override String get interactions => 'Tương tác';

  @override String get users => 'Người dùng';
  @override String get provinces => 'Tỉnh/Thành';
  @override String get populationMillions => 'Dân số (triệu)';
  @override String get areaSqKm => 'Diện tích (km²)';
  @override String get avgDensity => 'Mật độ TB (ng/km²)';
  @override String get top10Population => 'Top 10 tỉnh/thành theo dân số';
  @override String get top10Area => 'Top 10 tỉnh/thành theo diện tích';
  @override String get top10Density => 'Top 10 tỉnh/thành theo mật độ dân số';
  @override String get regionDistribution => 'Phân bố vùng miền';
  @override String get unitClassification => 'Phân loại đơn vị';
  @override String get exportPdf => 'Xuất PDF';
  @override String get exporting => 'Đang xuất...';

  @override String get searchByEmailOrName => 'Tìm kiếm theo email hoặc tên...';
  @override String get role => 'Role';
  @override String get status => 'Trạng thái';
  @override String get all => 'Tất cả';
  @override String get active => 'Hoạt động';
  @override String get disabled => 'Đã tắt';
  @override String get sortBy => 'Sắp xếp';
  @override String get fullName => 'Họ và tên';
  @override String get email => 'Email';
  @override String get sortAsc => 'Tăng dần';
  @override String get sortDesc => 'Giảm dần';
  @override String get retry => 'Thử lại';
  @override String get noOtherUsers => 'Chưa có người dùng nào khác.';
  @override String get noResultsFound => 'Không tìm thấy kết quả phù hợp.';
  @override String get unnamed => 'Chưa có tên';
  @override String get confirmDelete => 'Xác nhận xóa';
  @override String get deleteUserConfirmText => 'Xóa người dùng "{email}"?\n\nHành động này không thể hoàn tác.';
  @override String get cannotUpdate => 'Không thể cập nhật: {error}';
  @override String get cannotDelete => 'Không thể xóa: {error}';
  @override String get deletedUser => 'Đã xóa {email}';

  @override String get regionRedRiverDelta => 'ĐB sông Hồng';
  @override String get regionNorthernMidlands => 'Miền núi Bắc Bộ';
  @override String get regionCentralCoast => 'DH Trung Bộ';
  @override String get regionCentralHighlands => 'Tây Nguyên';
  @override String get regionSoutheast => 'Đông Nam Bộ';
  @override String get regionMekongDelta => 'ĐB sông Cửu Long';
  @override String get exportPdfSuccess => 'Xuất PDF thành công!';
  @override String get openPdf => 'Mở PDF';
  @override String get exportPdfError => 'Lỗi xuất PDF: {error}';

  @override String get crashlyticsMobileOnly => 'Crashlytics chỉ hoạt động trên Android/iOS';
  @override String get crashlyticsTestSent => 'Handled test exception — gửi từ Firebase Demo screen';
  @override String get crashlyticsHandledSuccess => 'Handled exception đã gửi lên Crashlytics!';

  @override String get employee => 'Nhân viên';
  @override String get unknown => 'Không rõ';
  @override String get unknownDate => 'Chưa xác định';
  @override String get unknownTime => 'Chưa xác định thời gian';
  @override String get student => 'Học sinh';
  @override String get parent => 'Phụ huynh';
  @override String get schoolStaff => 'Cán bộ trường';
  @override String get teacher => 'Giáo viên';
  @override String get principal => 'Hiệu trưởng';
  @override String get school => 'Trường học';
  @override String get phoneNumber => 'Số điện thoại';
  @override String get notUpdated => '(Chưa cập nhật)';

  @override String get filterCreated => 'Tạo mới';
  @override String get filterUpdated => 'Cập nhật';
  @override String get filterEnded => 'Kết thúc';
  @override String get markAllAsRead => 'Đọc tất cả';
  @override String get notificationsTitle => 'Thông báo';
  @override String get firebaseDemo => 'Firebase';
  @override String get noNotifications => 'Chưa có thông báo';
  @override String get noNotificationsOfType => 'Không có thông báo loại này';
  @override String get cannotOpenCampaign => 'Không thể mở chiến dịch: {error}';
  @override String get eventsListTitle => 'Sự kiện';
  @override String get noEventsYet => 'Chưa có sự kiện nào';
  @override String get fromDate => 'Từ {date}';
  @override String get toDate => 'Đến {date}';
  @override String get relatedNotification => 'Thông báo liên quan';
}

// ── English ───────────────────────────────────────────────────────────────────

class _En extends AppStrings {
  const _En();

  @override String get cancel => 'Cancel';
  @override String get save => 'Save';
  @override String get delete => 'Delete';
  @override String get confirm => 'Confirm';
  @override String get back => 'Back';
  @override String get close => 'Close';
  @override String get search => 'Search';
  @override String get loading => 'Loading...';
  @override String get noData => 'No data available';
  @override String get error => 'An error occurred';
  @override String get success => 'Success';
  @override String get refresh => 'Refresh';
  @override String get create => 'Create';
  @override String get edit => 'Edit';
  @override String get clear => 'Clear filter';

  @override String get languageVietnamese => 'VI';
  @override String get languageEnglish => 'EN';
  @override String get switchLanguage => 'Switch language';

  @override String get map => 'Map';
  @override String get campaign => 'Campaign';
  @override String get manageUsers => 'Manage Users';
  @override String get overview => 'Overview';
  @override String get notifications => 'Notifications';
  @override String get account => 'Account';
  @override String get profile => 'Profile';
  @override String get logout => 'Logout';

  @override String get recenterVietnam => 'Recenter on Vietnam';
  @override String get zoomIn => 'Zoom in';
  @override String get zoomOut => 'Zoom out';
  @override String get myLocation => 'My location';
  @override String get mapStyleLight => 'Light';
  @override String get mapStyleDark => 'Dark';
  @override String get mapStyleSatellite => 'Satellite';
  @override String get choroplethOn => 'Hide density map';
  @override String get choroplethOff => 'Show event density map';
  @override String get filterEvents => 'Filter events on map';
  @override String get filterActive => 'Filter active — tap to edit';

  @override String get province => 'Province/City';
  @override String get district => 'District';
  @override String get commune => 'Ward/Commune';
  @override String get city => 'City';
  @override String get noProvinceSelected => 'No province selected';

  @override String get campaigns => 'Campaigns';
  @override String get createCampaign => 'Create campaign';
  @override String get editCampaign => 'Edit campaign';
  @override String get deleteCampaign => 'Delete campaign';
  @override String get campaignName => 'Campaign name';
  @override String get campaignStatus => 'Status';
  @override String get campaignDescription => 'Description';
  @override String get selectCampaign => 'Select a campaign';
  @override String get searchCampaignHint => 'Search campaign...';
  @override String get campaignListAndStatsHint => 'Events and detailed statistics will be displayed here.';
  @override String get createNewCampaignTitle => 'Create new campaign';
  @override String get statusActive => 'Active';
  @override String get searchEventHint => 'Search event...';
  @override String get selectCampaignHint => 'Event list and details will appear here.';
  @override String get noCampaigns => 'No campaigns yet';

  @override String get createEvent => 'Create event';
  @override String get editEvent => 'Edit event';
  @override String get eventName => 'Event name';
  @override String get eventDate => 'Event date';
  @override String get eventLocation => 'Location';
  @override String get eventStatus => 'Status';
  @override String get eventHost => 'Main Host';
  @override String get noHost => 'No host assigned';
  @override String get latitude => 'Latitude (Lat)';
  @override String get longitude => 'Longitude (Lng)';
  @override String get useCurrentLocation => 'Use current location';
  @override String get employees => 'Employees';
  @override String get employeeSearch => 'Search employees...';
  @override String get noEmployeeFound => 'No employee found';
  @override String get assignedEmployees => 'Assigned employees';
  @override String get isHost => 'Is Main Host';

  @override String get statusInProgress => 'In progress';
  @override String get statusPreparing => 'Upcoming';
  @override String get statusCompleted => 'Completed';
  @override String get statusCanceled => 'Canceled';

  @override String get filterSheet => 'Filter events on map';
  @override String get filterByStatus => 'Event status';
  @override String get clearFilter => 'Clear filter';
  @override String get filteringCount => 'Showing';

  @override String get eventDensity => 'Event density';
  @override String get densityOne => '1 event';
  @override String get densityTwo => '2–3 events';
  @override String get densityFour => '4–6 events';
  @override String get densitySeven => '7+ events';

  @override String get checkIn => 'Check-in';
  @override String get checkOut => 'Check-out';
  @override String get interaction => 'Interaction';
  @override String get interactions => 'Interactions';

  @override String get users => 'Users';
  @override String get provinces => 'Provinces/Cities';
  @override String get populationMillions => 'Population (M)';
  @override String get areaSqKm => 'Area (km²)';
  @override String get avgDensity => 'Avg Density (p/km²)';
  @override String get top10Population => 'Top 10 by Population';
  @override String get top10Area => 'Top 10 by Area';
  @override String get top10Density => 'Top 10 by Density';
  @override String get regionDistribution => 'Region Distribution';
  @override String get unitClassification => 'Unit Classification';
  @override String get exportPdf => 'Export PDF';
  @override String get exporting => 'Exporting...';

  @override String get searchByEmailOrName => 'Search by email or name...';
  @override String get role => 'Role';
  @override String get status => 'Status';
  @override String get all => 'All';
  @override String get active => 'Active';
  @override String get disabled => 'Disabled';
  @override String get sortBy => 'Sort by';
  @override String get fullName => 'Full name';
  @override String get email => 'Email';
  @override String get sortAsc => 'Ascending';
  @override String get sortDesc => 'Descending';
  @override String get retry => 'Retry';
  @override String get noOtherUsers => 'No other users yet.';
  @override String get noResultsFound => 'No matching results found.';
  @override String get unnamed => 'Unnamed';
  @override String get confirmDelete => 'Confirm delete';
  @override String get deleteUserConfirmText => 'Delete user "{email}"?\n\nThis action cannot be undone.';
  @override String get cannotUpdate => 'Cannot update: {error}';
  @override String get cannotDelete => 'Cannot delete: {error}';
  @override String get deletedUser => 'Deleted {email}';

  @override String get regionRedRiverDelta => 'Red River Delta';
  @override String get regionNorthernMidlands => 'Northern Midlands';
  @override String get regionCentralCoast => 'Central Coast';
  @override String get regionCentralHighlands => 'Central Highlands';
  @override String get regionSoutheast => 'Southeast';
  @override String get regionMekongDelta => 'Mekong Delta';
  @override String get exportPdfSuccess => 'Export PDF successful!';
  @override String get openPdf => 'Open PDF';
  @override String get exportPdfError => 'Error exporting PDF: {error}';

  @override String get crashlyticsMobileOnly => 'Crashlytics only works on Android/iOS';
  @override String get crashlyticsTestSent => 'Handled test exception — sent from Firebase Demo screen';
  @override String get crashlyticsHandledSuccess => 'Handled exception sent to Crashlytics!';

  @override String get employee => 'Employee';
  @override String get unknown => 'Unknown';
  @override String get unknownDate => 'Undetermined';
  @override String get unknownTime => 'Undetermined time';
  @override String get student => 'Student';
  @override String get parent => 'Parent';
  @override String get schoolStaff => 'School staff';
  @override String get teacher => 'Teacher';
  @override String get principal => 'Principal';
  @override String get school => 'School';
  @override String get phoneNumber => 'Phone number';
  @override String get notUpdated => '(Not updated)';

  @override String get filterCreated => 'Created';
  @override String get filterUpdated => 'Updated';
  @override String get filterEnded => 'Ended';
  @override String get markAllAsRead => 'Mark all as read';
  @override String get notificationsTitle => 'Notifications';
  @override String get firebaseDemo => 'Firebase';
  @override String get noNotifications => 'No notifications yet';
  @override String get noNotificationsOfType => 'No notifications of this type';
  @override String get cannotOpenCampaign => 'Cannot open campaign: {error}';
  @override String get eventsListTitle => 'Events';
  @override String get noEventsYet => 'No events yet';
  @override String get fromDate => 'From {date}';
  @override String get toDate => 'To {date}';
  @override String get relatedNotification => 'Related notification';
}

// ── Singletons ────────────────────────────────────────────────────────────────

const _vi = _Vi();
const _en = _En();
