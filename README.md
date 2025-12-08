# Attendance App (GetX + Clean Architecture)

Flutter client for the Attendance API (`http://148.230.108.157:8080`) with separate experiences for employees and admins/managers. The app uses GetX for state management/navigation and follows a Clean Architecture layout (core ➜ data ➜ domain ➜ presentation).

## Tech stack

- **Flutter 3.32 / Dart 3.8**
- **GetX** for DI, routing, and reactive controllers
- **Dio** + `PrettyDioLogger` for HTTP
- **json_serializable** for models
- **flutter_secure_storage** for Sanctum token persistence

## Project structure

```
lib/
 ├─ core/            # config, errors, networking, secure storage
 ├─ data/            # DTOs, remote service, repository implementations
 ├─ domain/          # entities, repository contracts, use-cases
 ├─ presentation/    # bindings, controllers, views, widgets, routing
 └─ main.dart        # GetMaterialApp + AppBinding bootstrap
```

Key flows:

- **AuthController** → login/logout/session restore (`/api/v1/auth/*`, `/api/v1/me`)
- **AttendanceController** → daily roster, summary, employee overview
- **RequestController** → personal requests + approvals (`/api/v1/requests*`)

Admin dashboards show org-wide stats and pending approvals, while employees see their recent attendance and submissions.

## Running the app

```bash
cd attendance_app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run            # or flutter test / flutter analyze
```

Update `AppConfig.baseUrl` if the backend host changes. Sanctum tokens are stored securely; remove them via the in-app logout action.

## Testing

```
flutter test
```

Currently includes a smoke test for the splash/auth bootstrap; expand with widget/integration tests as features grow.
