# PRISM — Admin Login + Control Room + Sidebar Profile (Phase 1 slice)

This is a self-contained slice of the PRISM Flutter frontend covering the
three pieces requested for starters:

1. **Admin Login** (`screens/auth/admin_login_screen.dart`) — Auth Screen 4.
2. **Control Room Dashboard** (`screens/admin/dashboard/admin_dashboard_screen.dart`) — Admin Screen 1.
3. **Admin profile widget** (`_AdminProfileFooter` in `widgets/common/prism_sidebar.dart`) — avatar/initials, name, logout icon pinned to the bottom of the sidebar.

Built with **BLoC** per the tech lead's spec — no Riverpod anywhere.

## Run it

```bash
flutter pub get
flutter run -d chrome   # or any device
```

Login with any email containing `@` and a password of 6+ characters —
`MockAuthRepository` accepts anything that looks valid. This lets you
demo the full flow (login → Control Room → logout) before Stone's real
`/auth/admin/login` and `/admin/dashboard` endpoints exist.

## What's real vs. mocked

- **Real:** theme tokens (colours, type, spacing), BLoC wiring, widget
  library (`PrismButton`, `PrismCard`, `PrismInput`, `PrismBadge`,
  `PrismLabel`, `PrismSidebar`, `StatCard`, `PrismLoader`, `PrismError`),
  responsive shell (sidebar on desktop, bottom nav on mobile), all screen
  layouts and copy per spec.
- **Mocked:** `MockAuthRepository` and `MockAdminRepository` return
  in-memory data instead of hitting Supabase/Dio. Swap the repository
  implementation passed into `AuthBloc`/`AdminDashboardBloc` in `app.dart`
  and `admin_dashboard_screen.dart` — nothing else needs to change.

## Folder structure

Matches the master doc's `lib/` layout exactly (just the subset needed
for this slice):

```
lib/
  core/theme/           app_colors, app_text_styles, app_spacing, app_theme
  models/                admin_model, admin_dashboard_model
  repositories/          auth_repository, admin_repository (+ mocks)
  blocs/
    auth/                auth_bloc / auth_event / auth_state
    admin/dashboard/      admin_dashboard_bloc / event / state
  screens/
    auth/                admin_login_screen
    admin/               admin_shell, dashboard/admin_dashboard_screen
  widgets/common/        prism_button, prism_card, prism_input, prism_badge
                          (+PrismLabel), prism_sidebar, stat_card,
                          prism_loader, prism_error
```

## Not in this slice (next steps per the build order)

- `go_router` with role-based redirect (`app.dart` currently gates on
  `AuthBloc` state directly with a small `_AuthGate` widget — swap this
  for the router once Client/Clipper auth screens exist).
- Every other admin nav destination (Clients, Clippers, Clip Review,
  Campaigns, Messages, Analytics, Financials) — `AdminShell` renders a
  placeholder for these so the sidebar/bottom-nav is fully navigable
  today, but each screen + its own BLoC is a separate build step.
- Client portal, Clipper portal — untouched, per "Admin first."

One step, screen recording, approved, next step.
