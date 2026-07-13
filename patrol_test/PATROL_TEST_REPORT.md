# Patrol Test Report

Date: 2026-07-13

## Scope

This report summarizes the implemented Patrol end-to-end and widget-driven integration tests under `patrol_test/`.

- Total implemented Patrol test files: 11
- Source inventory basis: `patrol_test/*.dart`
- Execution evidence basis: recent local terminal runs captured in the workspace context

## Patrol Test Source Code Screenshots

Source code screenshots are embedded below from `patrol_test/screenshots/code` in the same E2E order as the report.

| Test file | Screenshot placeholder |
| --- | --- |
| `patrol_test/google_login_auth_test.dart` | ![Google authentication source code](screenshots/code/Test_case_1.png) |
| `patrol_test/admin_gate_login_authorization_test.dart` | ![Admin login authorization source code](screenshots/code/Test_case_2.png) |
| `patrol_test/dashboard_statistics_test.dart` | ![Dashboard statistics source code](screenshots/code/Test_case_3.png) |
| `patrol_test/admin_user_list_test.dart` | ![Admin user list source code](screenshots/code/Test_case_4.png) |
| `patrol_test/admin_campaign_crud_test.dart` | ![Admin campaign CRUD source code](screenshots/code/Test_case_5.png) |
| `patrol_test/notification_workflow_test.dart` | ![Notification workflow source code](screenshots/code/Test_case_6.png) |
| `patrol_test/core_map_viewport_controls_test.dart` | ![Core map viewport source code](screenshots/code/Test_case_7.png) |
| `patrol_test/map_search_filter_sort_test.dart` | ![Map search filter sort source code](screenshots/code/Test_case_8.png) |
| `patrol_test/province_selection_lower_level_reveal_test.dart` | ![Province selection source code](screenshots/code/Test_case_9.png) |
| `patrol_test/user_campaigns_display_test.dart` | ![User campaigns display source code](screenshots/code/Test_case_10.png) |
| `patrol_test/logout_test.dart` | ![Logout source code](screenshots/code/Test_case_11.png) |

## Test Execution Screenshots

Execution screenshots are embedded below from `patrol_test/screenshots/execution` in the same E2E order as the report.

| Suite / command | Screenshot placeholder |
| --- | --- |
| `.\scripts\run_patrol_google_auth.ps1` or `.\scripts\run_patrol_e2e.ps1 -Suite google-auth` | ![Google authentication execution](screenshots/execution/Test_case_1.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite admin-login-auth` | ![Admin login authorization execution](screenshots/execution/Test_case_2.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite dashboard-stats` | ![Dashboard statistics execution](screenshots/execution/Test_case_3.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite admin-user-list` | ![Admin user list execution](screenshots/execution/Test_case_4.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite admin-campaign-crud` | ![Admin campaign CRUD execution](screenshots/execution/Test_case_5.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite notification-workflow` | ![Notification workflow execution](screenshots/execution/Test_case_6.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite us1-core-map` | ![Core map viewport execution](screenshots/execution/Test_case_7.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite us1-search-filter-sort` | ![Map search filter sort execution](screenshots/execution/Test_case_8.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite us1-province-selection` | ![Province selection execution](screenshots/execution/Test_case_9.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite user-campaigns-display` | ![User campaigns display execution](screenshots/execution/Test_case_10.png) |
| `.\scripts\run_patrol_e2e.ps1 -Suite logout` | ![Logout execution](screenshots/execution/Test_case_11.png) |

## Test Results Summary

### Implemented coverage summary

| E2E flow position | Suite |
| --- | --- |
| 1 | Google authentication |
| 2 | Admin gate login authorization |
| 3 | Dashboard statistics |
| 4 | Admin user list |
| 5 | Admin campaign and event creation |
| 6 | Notification workflow |
| 7 | Core map viewport controls |
| 8 | Map search, filter, and sort |
| 9 | Province selection and lower-level reveal |
| 10 | User campaigns display |
| 11 | Logout |

### Observed execution evidence

| Command | Observed result | Notes |
| --- | --- | --- |
| `.\scripts\run_patrol_e2e.ps1 -Suite admin-user-list` | Pass | Terminal context shows exit code `0`. |
| `.\scripts\run_patrol_e2e.ps1 -Suite admin-user-list -Device emulator-5554` | Fail | Terminal context shows exit code `1`; no detailed failure artifact was present in the workspace. |
| `flutter analyze lib/services/auth_service.dart lib/viewmodels/auth_controller.dart` | Not a Patrol result | Included in terminal history, but it is static analysis rather than Patrol execution. |

### Current summary statement

The Patrol suite contains 11 implemented test files. Based on the execution evidence available in the workspace at the time of writing, one Patrol suite run is confirmed passing (`admin-user-list`), one device-targeted retry is confirmed failing without a captured failure artifact, and the remaining suites are implemented but not execution-verified in this report.

## Brief Explanation Of Each Implemented Test Case

| Test file | Patrol test name | Brief explanation |
| --- | --- | --- |
| `patrol_test/google_login_auth_test.dart` | `google login authenticates on Android emulator` | Exercises the Android emulator Google sign-in flow, including optional account selection, consent steps, permission handling, and final transition into the authenticated shell. |
| `patrol_test/admin_gate_login_authorization_test.dart` | `admin gate login authorizes right credentials` | Ensures an admin can authenticate from the login screen and reach admin-only navigation, proving that protected admin access is available only after a valid sign-in. |
| `patrol_test/dashboard_statistics_test.dart` | `dashboard statistics displayed correctly` | Checks that the statistics dashboard renders the expected chart section titles, supports scrolling to lower sections, and does not show an error state. |
| `patrol_test/admin_user_list_test.dart` | `admin can view user list` | Signs in as an admin, navigates to user management, and verifies that the user list view loads without a retry error while showing either user rows or the expected empty state. |
| `patrol_test/admin_campaign_crud_test.dart` | `admin campaign and event creation work` | Signs in as an admin, opens campaign management, creates a unique campaign, opens campaign details, creates an event, and verifies that both success feedback and the new event are visible. |
| `patrol_test/notification_workflow_test.dart` | `notification workflow works after campaign creation` | Creates a campaign as an admin, opens the notification center, checks that a corresponding notification entry appears, and verifies that tapping the notification reveals the created campaign. |
| `patrol_test/core_map_viewport_controls_test.dart` | `core map loads with Vietnam-focused default viewport and map controls visible` | Verifies that the map screen initializes with the expected Vietnam center coordinates, default zoom, and visible core map controls such as zoom in, zoom out, current location, and recenter. |
| `patrol_test/map_search_filter_sort_test.dart` | `search filter sort for province and lower level works` | Verifies the search UI logic for both province and district levels by checking filter selection, search text handling, and ascending/descending sort behavior against the controller's filtered results. |
| `patrol_test/province_selection_lower_level_reveal_test.dart` | `province selection and lower level reveal works by click` | Confirms that selecting a province from search results updates the selected province state, loads lower-level administrative places, and reveals the lower-level section in the UI. |
| `patrol_test/user_campaigns_display_test.dart` | `user can view campaigns screen` | Creates a fresh end-user account, authenticates into the user shell, opens the campaign section, and verifies that the campaign screen loads a valid empty state or content without exposing admin creation controls. |
| `patrol_test/logout_test.dart` | `authenticated admin can log out` | Ensures that an authenticated admin session can be terminated through the account menu and that the app returns to the login screen with the authenticated shell removed. |

## Notes

- Execution screenshot artifacts were found in `patrol_test/screenshots/execution` and embedded in the report.
- Source code screenshot artifacts were found in `patrol_test/screenshots/code` and embedded in the report.
- The suite aliases listed above come from `scripts/run_patrol_e2e.ps1`.
- Google authentication requires Android emulator execution and test credentials configured for the Patrol environment.