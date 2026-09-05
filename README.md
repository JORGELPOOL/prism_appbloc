# PRISM — Admin Portal (Phase 1 slice)

Built with **BLoC** for the Dashboard/Login state, **go_router** for
navigation, and a shared `MockData` class for everything else — no
Riverpod anywhere.

## Run it

```bash
flutter pub get
flutter run -d chrome
```

Login with any email containing `@` and a password of 6+ characters.

## Screens

| Screen | File | Route |
|---|---|---|
| Admin Login | `screens/auth/admin_login_screen.dart` | `/login` |
| Control Room Dashboard | `screens/admin/dashboard/admin_dashboard_screen.dart` | `/admin` |
| Clients | `screens/admin/clients/admin_clients_screen.dart` | `/admin/clients` |
| Clipper Approvals | `screens/admin/clippers/clipper_approvals_screen.dart` | `/admin/clippers` |
| Clip Review | `screens/admin/clips/clip_review_screen.dart` | `/admin/clips` |
| Campaigns | `screens/admin/campaigns/campaign_builder_screen.dart` | `/admin/campaigns` |
| Messages | `screens/admin/messages/admin_messages_screen.dart` | `/admin/messages` |
| Analytics / Financials | placeholder in `admin_shell.dart` | `/admin/analytics`, `/admin/financials` |

## Navigation

`app.dart` owns a single `AuthBloc` and a `GoRouter` built around it.
The router's `redirect` reads `AuthBloc.state` on every navigation
attempt and bounces unauthenticated users to `/login`, and logged-in
users away from `/login` to `/admin` — no manual `context.go` calls
scattered through screens for login/logout. `AdminShell` is the
`ShellRoute` builder: it renders the sidebar (desktop) or bottom nav
(mobile) around whatever the matched nested route returns, and derives
the selected nav item from the current location instead of local state.

## Data

- **Real (BLoC):** Admin Login (`AuthBloc`) and the Control Room
  Dashboard (`AdminDashboardBloc`) — both backed by mock repositories
  (`MockAuthRepository`, `MockAdminRepository`) that are drop-in
  replaceable once Stone's endpoints exist.
- **Mock (static):** the 5 new screens read directly from
  `lib/core/mock/mock_data.dart` — one file, all dummy data. Swap
  individual lists for repository calls once those endpoints exist;
  screen code won't need to change shape since it already reads
  `Map<String, dynamic>`, matching what JSON API responses look like.

## Global fixes applied this pass

1. **Cyan** — confirmed `0xFF00D4FF` everywhere (already correct, no
   `Colors.cyan` or `0xFF00FFFF` anywhere in the project).
2. **Stat cards** — number down to 36px, padding down to 20px.
3. **Sidebar badges** — compact rounded-rect pills, max 20px wide, 9px
   font, tucked directly next to the label instead of floating at the
   panel edge.
4. **Dashboard stat row** — confirmed single `Row` + `Expanded` on
   desktop (already the case; not a grid).

## Not in this slice

- Wiring the mobile bottom nav's overflow items (Analytics, Financials,
  and the admin profile/logout action aren't reachable from the bottom
  nav yet — desktop sidebar has all of it).
- Real Approve/Reject/Send actions on Clipper Approvals, Clip Review,
  Campaigns and Messages — buttons are present and styled per spec but
  not yet wired to repository calls (matches the "dummy data" scope of
  this pass).
- Client portal, Clipper portal — untouched, per "Admin first."

