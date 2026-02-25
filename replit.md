# BlockRemote - Cybersecurity Defense System (Enterprise Premium)

## Overview
BlockRemote is a Flutter-based cybersecurity monitoring app with a premium deep tech aesthetic. Features glassmorphism UI, animated radar dashboard, system boot sequence, live operational counters, shield detail modals, haptic feedback engine, and smooth slide transitions between screens.

## Architecture
- **Framework**: Flutter 3.41.2 (Dart 3.11.0)
- **State Management**: Provider (ChangeNotifier pattern)
- **UI Rendering**: CustomPaint for radar and wave graphs, BackdropFilter for glassmorphism
- **Typography**: Inter (headings/UI) + JetBrains Mono (technical data) via google_fonts
- **Platform**: Built for web, designed with iOS native feel

## Project Structure
```
lib/
  main.dart                - App entry, splash routing, glassmorphism nav, page transitions
  theme/
    app_theme.dart         - Color palette, AppFonts dual-font system, ThemeData
  components/
    neon_container.dart    - Container with gradient + neon glow border
    cyber_button.dart      - Animated button with haptic feedback
    security_card.dart     - List item card with gradient + tap support
    neon_switch.dart       - Custom toggle switch with neon glow
    wave_painter.dart      - CustomPainter for real-time wave graphics
    glass_container.dart   - BackdropFilter glassmorphism wrapper
    breathing_glow.dart    - Pulsating glow AnimationController wrapper
  screens/
    splash_screen.dart           - System Initialization boot sequence
    dashboard_screen.dart        - Animated orb, live counters, threat simulation
    sensor_monitor_screen.dart   - Real-time sensor wave graphs
    app_shield_screen.dart       - Protection list with detail modal on tap
    audit_logs_screen.dart       - Terminal-style log viewer
    settings_screen.dart         - Sensitivity sliders and config
    subscription_overlay.dart    - Glassmorphism paywall overlay (R$9,90/mês)
  services/
    security_state.dart    - Global state (live counters, sensors, logs, protections, subscription)
server.dart                - Dart HTTP server serving Flutter web build on port 5000
```

## Premium Features (Enterprise Refinements)
- **Glassmorphism**: BackdropBlur on AppBar and BottomNav with gradient overlays
- **Dynamic Glow**: Breathing animation on all secure status elements
- **Dual Typography**: Inter for headings, JetBrains Mono for data
- **Status Orb**: Pulsing neon orb with rotating arcs, scan sweep, tick marks
- **Subscription Paywall**: Minimalist "digital vault" overlay — pure black background with subtle circuit texture (CustomPaint, ~8% opacity), centered glassmorphism card (white 5% fill, green border), clean Inter typography, JetBrains Mono price, CTA with external glow only (no fill), "Restaurar compra" text link, R$9,90/mês
- **Live Counters**: Requests Analyzed, Memory Integrity, Packets Scanned (auto-incrementing)
- **Shield Detail Modal**: Technical details per protection module (protocol, monitoring, scan results)
- **Boot Sequence**: 21-line system initialization splash with progress bar
- **Slide Transitions**: Curves.easeInOutCubic page transitions between tabs
- **Haptic Feedback**: Light on navigation, Heavy on threat simulation, Selection on toggles
- **True Black**: #000000 background for OLED screens

## Color Palette
- Background: #000000 (True Black OLED)
- Surface: #0D1117 (Carbon Grey)
- Primary Neon: #00FF41 (Matrix Green)
- Secondary Neon: #ADFF2F (Cyber Lime)
- Text: #F1F2F1 (Off-White)
- Danger: #FF0040
- Warning: #FFAA00

## Running
The app is served via a Dart HTTP server on port 5000. Flutter SDK is at `/home/runner/flutter/`.

To rebuild after changes:
```bash
export PATH="/home/runner/flutter/bin:$PATH"
flutter build web --release
```
Then restart the workflow.

## Dependencies
- flutter SDK (3.41.2)
- provider ^6.1.2
- google_fonts ^6.2.1
- cupertino_icons ^1.0.8
