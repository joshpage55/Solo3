# Tip Calculator

A Flutter app that calculates restaurant tips and splits the bill among multiple people. Built for CPSC 4150 Solo 3.

## What It Does

- Enter a **bill amount** (required, numeric, must be > 0)
- Adjust **tip percentage** with a slider (0–50%, default 18%)
- Enter **number of people** to split the bill (required, integer 1–100)
- Tap **Calculate Tip** to see tip amount, total with tip, and per-person share
- Tap **empty screen areas** to cycle through 5 background themes; text and icons automatically switch for readable contrast

## How to Run

Requires [Flutter SDK](https://docs.flutter.dev/get-started/install) (tested with Flutter 3.41+).

```bash
cd tip_calculator
flutter pub get
flutter run
```

Run on a specific device:

```bash
flutter devices
flutter run -d <device_id>
```

Run tests:

```bash
flutter test
```

## Color Palette & Contrast

Tapping empty areas cycles through these 5 colors (wraps after the fifth):

| # | Name        | Hex       | Foreground |
|---|-------------|-----------|------------|
| 1 | Warm Cream  | `#FFF8E7` | Black      |
| 2 | Sky Blue    | `#87CEEB` | Black      |
| 3 | Coral Red   | `#FF6B6B` | White      |
| 4 | Deep Teal   | `#006D77` | White      |
| 5 | Charcoal    | `#2D3436` | White      |

**Contrast method:** Each background color uses Flutter's `Color.computeLuminance()`. If luminance > 0.5, foreground text/icons use `Colors.black87`; otherwise they use `Colors.white`. The same logic applies to the AppBar title, form labels, results, and icons. Interactive widgets (text fields, slider, button) keep their normal tap behavior and do not trigger color changes.

Implementation: `lib/theme/app_background_theme.dart`

## Sample Inputs & Expected Outputs

| Bill | Tip % | People | Tip Amount | Total | Per Person |
|------|-------|--------|------------|-------|------------|
| 100.00 | 20 | 1 | $20.00 | $120.00 | $120.00 |
| 42.50 | 18 | 2 | $7.65 | $50.15 | $25.08 |
| 25.00 | 0 | 4 | $0.00 | $25.00 | $6.25 |

### Edge Cases

| Input | Expected Behavior |
|-------|-------------------|
| Empty bill | Error: "Bill amount is required" |
| Bill = 0 or negative | Error: "Bill must be greater than zero" |
| Bill = "abc" | Error: "Enter a valid number" |
| Split = 0 | Error: "At least 1 person required" |
| Split = 101 | Error: "Maximum 100 people" |
| Tip = 0%, Bill = $25, 2 people | Valid: $0 tip, $25 total, $12.50 each (no crash) |

## Project Structure

```
lib/
  main.dart                      # App entry point
  models/tip_calculation.dart    # Calculation logic
  screens/tip_calculator_screen.dart  # UI, validation, state
  theme/app_background_theme.dart     # 5-color palette & contrast
test/
  tip_calculation_test.dart      # Unit tests
```
