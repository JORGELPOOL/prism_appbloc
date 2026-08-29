/// Spacing and sizing rules from the PRISM design system.
/// Border radius is 0 everywhere — never override [radius].
class AppSpacing {
  AppSpacing._();

  static const double radius = 0;

  static const double cardPaddingMin = 24;
  static const double cardPaddingPreferred = 28;

  static const double sectionGapMin = 32;
  static const double sectionGapPreferred = 48;

  static const double buttonHeight = 48;

  static const double sidebarWidthDesktop = 220;

  // Common breakpoint used across shells for sidebar <-> bottom-nav switch.
  static const double mobileBreakpoint = 720;
}
