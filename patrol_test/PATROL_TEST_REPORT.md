# Patrol Test Report

Date: 2026-07-14

## Scope

This report summarizes the implemented Patrol end-to-end and widget-driven integration tests under `patrol_test/`.

- Total implemented Patrol test files: 14
- Source inventory basis: `patrol_test/*.dart`
- Execution evidence basis: recent local terminal runs captured in the workspace context

## Patrol Test Source Code Screenshots

Source code screenshots are embedded below from `patrol_test/screenshots/code` in the same E2E order as the report.

| Test file | Screenshot placeholder |
| --- | --- |
| `patrol_test/google_login_auth_test.dart` | ![Google authentication source code](screenshots/code/Test_case_1.png) |
| `patrol_test/admin_gate_login_authorization_test.dart` | ![Admin login authorization source code](screenshots/code/Test_case_2.png) |
| `patrol_test/dashboard_statistics_test.dart` | ![Dashboard statistics source code](screenshots/code/Test_case_3.png) |
| `patrol_test/admin_campaign_crud_test.dart` | ![Admin campaign CRUD source code](screenshots/code/Test_case_4.png) |
| `patrol_test/staff_checkin_interaction_test.dart` | ![Staff check-in and interaction source code](screenshots/code/Test_case_5.png) |
| `patrol_test/host_complete_event_campaign_test.dart` | ![Host completes event and campaign source code](screenshots/code/Test_case_6.png) |
| `patrol_test/core_map_viewport_controls_test.dart` | ![Core map viewport source code](screenshots/code/Test_case_7.png) |
| `patrol_test/map_search_filter_sort_test.dart` | ![Map search filter sort source code](screenshots/code/Test_case_8.png) |
| `patrol_test/province_selection_lower_level_reveal_test.dart` | ![Province selection source code](screenshots/code/Test_case_9.png) |
| `patrol_test/user_campaigns_display_test.dart` | ![User campaigns display source code](screenshots/code/Test_case_10.png) |
| `patrol_test/profile_navigation_test.dart` | ![Profile navigation source code](screenshots/code/Test_case_11.png) |
| `patrol_test/remote_config_values_test.dart` | ![Remote Config source code](screenshots/code/Test_case_12.png) |
| `patrol_test/pdf_export_upload_test.dart` | ![PDF export source code](screenshots/code/Test_case_13.png) |
| `patrol_test/logout_test.dart` | ![Logout source code](screenshots/code/Test_case_14.png) |

## Test Execution Screenshots

Execution screenshots are embedded below from `patrol_test/screenshots/execution` in the same E2E order as the report.

| Suite / command | Screenshot placeholder |
| --- | --- |
| `.\scripts\run_patrol_google_auth.ps1` or `.\scripts\run_patrol_e2e.ps1 -Suite google-auth` | ![Google authentication execution](screenshots/execution/Test_case_1.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite admin-login-auth` | ![Admin login authorization execution](screenshots/execution/Test_case_2.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite dashboard-stats` | ![Dashboard statistics execution](screenshots/execution/Test_case_3.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite admin-campaign-crud` | ![Admin campaign CRUD execution](screenshots/execution/Test_case_4.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite staff-checkin-interaction` | ![Staff check-in and interaction execution](screenshots/execution/Test_case_5.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite host-complete-event-campaign` | ![Host completes event and campaign execution](screenshots/execution/Test_case_6.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite us1-core-map` | ![Core map viewport execution](screenshots/execution/Test_case_7.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite us1-search-filter-sort` | ![Map search filter sort execution](screenshots/execution/Test_case_8.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite us1-province-selection` | ![Province selection execution](screenshots/execution/Test_case_9.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite user-campaigns-display` | ![User campaigns display execution](screenshots/execution/Test_case_10.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite profile-navigation` | ![Profile navigation execution](screenshots/execution/Test_case_11.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite remote-config` | ![Remote Config execution](screenshots/execution/Test_case_12.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite pdf-export` | ![PDF export execution](screenshots/execution/Test_case_13.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite logout` | ![Logout execution](screenshots/execution/Test_case_14.png) |

## Test Results Summary

### Implemented coverage summary

| E2E flow position | Suite |
| --- | --- |
| 1 | Google authentication |
| 2 | Admin gate login authorization |
| 3 | Dashboard statistics |
| 4 | Admin campaign and event creation |
| 5 | Staff check-in and interaction |
| 6 | Host completes event and campaign |
| 7 | Core map viewport controls |
| 8 | Map search, filter, and sort |
| 9 | Province selection and lower-level reveal |
| 10 | User campaigns display |
| 11 | Profile navigation |
| 12 | Remote Config values |
| 13 | PDF export and Firebase Storage upload |
| 14 | Logout |

### Observed execution evidence

| Command | Observed result | Notes |
| --- | --- | --- |
| `.\scripts\run_patrol_e2e.ps1 -Suite staff-checkin-interaction -Device emulator-5554` | Pass | Final rerun in this session passed after replacing brittle campaign/event taps with keyed selectors, skipping Crashlytics test-mode hooks, and accepting both `AlertDialog` and custom `Dialog` in the shared wait helper. |
| `.\scripts\run_patrol_e2e.ps1 -Suite host-complete-event-campaign -Device emulator-5554` | Pass | Final rerun in this session passed after waiting for the `Đã tạo event.` snackbar to clear and returning from `EventDetailScreen` before checking campaign completion controls. |
| `.\scripts\run_patrol_e2e.ps1 -Suite profile-navigation -Device emulator-5554` | Pass | Passed on emulator-5554 after signing in as the admin test account, opening the account menu, and verifying the profile screen renders the expected authenticated user information. |
| `.\scripts\run_patrol_e2e.ps1 -Suite remote-config -Device emulator-5554` | Pass | Passed on emulator-5554 after opening Firebase Demo and verifying the Remote Config keys and displayed values for chart count, PDF toggle, and check-in distance. |
| `.\scripts\run_patrol_e2e.ps1 -Suite pdf-export -Device emulator-5554` | Pass | Passed on emulator-5554 after generating the PDF report from Firebase Demo, uploading it to Firebase Storage, and confirming the success state and download URL. |
| `flutter analyze lib/services/auth_service.dart lib/viewmodels/auth_controller.dart` | Not a Patrol result | Included in terminal history, but it is static analysis rather than Patrol execution. |

### Current summary statement

The Patrol suite contains 14 implemented test files. Based on the execution evidence captured in this session, the repaired campaign lifecycle suites and the newly added profile navigation, Remote Config, and PDF export flows all pass on `emulator-5554`.

## Brief Explanation Of Each Implemented Test Case

| Test file | Patrol test name | Brief explanation |
| --- | --- | --- |
| `patrol_test/google_login_auth_test.dart` | `google login authenticates on Android emulator` | Exercises the Android emulator Google sign-in flow, including optional account selection, consent steps, permission handling, and final transition into the authenticated shell. |
| `patrol_test/admin_gate_login_authorization_test.dart` | `admin gate login authorizes right credentials` | Ensures an admin can authenticate from the login screen and reach admin-only navigation, proving that protected admin access is available only after a valid sign-in. |
| `patrol_test/dashboard_statistics_test.dart` | `dashboard statistics displayed correctly` | Checks that the statistics dashboard renders the expected chart section titles, supports scrolling to lower sections, and does not show an error state. |
| `patrol_test/admin_campaign_crud_test.dart` | `admin campaign and event creation work` | Signs in as an admin, opens campaign management, creates a unique campaign, opens campaign details, creates an event, and verifies that both success feedback and the new event are visible. |
| `patrol_test/staff_checkin_interaction_test.dart` | `staff can check in and create interactions for an event` | Creates a campaign and event as an admin, signs in as the assigned staff user, completes event check-in, and records an interaction from the event detail workflow. |
| `patrol_test/host_complete_event_campaign_test.dart` | `host completes the event and campaign successfully` | Creates a campaign and event as an admin, assigns the test staff account as the event host, signs in as that host to start and complete the event, then verifies the campaign can be marked complete once its event is finished. |
| `patrol_test/core_map_viewport_controls_test.dart` | `core map loads with Vietnam-focused default viewport and map controls visible` | Verifies that the map screen initializes with the expected Vietnam center coordinates, default zoom, and visible core map controls such as zoom in, zoom out, current location, and recenter. |
| `patrol_test/map_search_filter_sort_test.dart` | `search filter sort for province and lower level works` | Verifies the search UI logic for both province and district levels by checking filter selection, search text handling, and ascending/descending sort behavior against the controller's filtered results. |
| `patrol_test/province_selection_lower_level_reveal_test.dart` | `province selection and lower level reveal works by click` | Confirms that selecting a province from search results updates the selected province state, loads lower-level administrative places, and reveals the lower-level section in the UI. |
| `patrol_test/user_campaigns_display_test.dart` | `user can view campaigns screen` | Creates a fresh end-user account, authenticates into the user shell, opens the campaign section, and verifies that the campaign screen loads a valid empty state or content without exposing admin creation controls. |
| `patrol_test/profile_navigation_test.dart` | `profile navigation displays authenticated user information` | Signs in as the admin test user, opens the account menu, navigates to Hồ sơ cá nhân, and verifies the profile screen shows the expected authenticated user details and admin role state. |
| `patrol_test/remote_config_values_test.dart` | `remote config values are displayed in firebase demo` | Signs in as an admin, opens the Firebase Demo section, refreshes configuration when available, and verifies the expected Remote Config keys and rendered values are visible in the UI. |
| `patrol_test/pdf_export_upload_test.dart` | `pdf export uploads report to firebase storage` | Signs in as an admin, opens Firebase Demo, generates the PDF report, uploads it to Firebase Storage, and verifies the success message and resulting storage URL are displayed. |
| `patrol_test/logout_test.dart` | `authenticated admin can log out` | Ensures that an authenticated admin session can be terminated through the account menu and that the app returns to the login screen with the authenticated shell removed. |

## Notes

- Execution screenshot artifacts were found in `patrol_test/screenshots/execution` and embedded in the report.
- Source code screenshot artifacts were found in `patrol_test/screenshots/code` and embedded in the report.
- The suite aliases listed above come from `scripts/run_patrol_e2e.ps1`.
- Google authentication requires Android emulator execution and test credentials configured for the Patrol environment.