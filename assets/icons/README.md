# App Icons

## Required files

- `app_icon.png` — 1024×1024 PNG, full bleed icon (used by flutter_launcher_icons)
- `app_icon_foreground.png` — 1024×1024 PNG, adaptive icon foreground (with safe-zone padding)

## Icon concept (original design)

**PulseFit AI logo**:
- Circular gradient base (cyan #00E5FF → violet #7C4DFF)
- White lightning bolt centered (Material `bolt_rounded`)
- Soft glowing halo at 30% opacity
- Background color for adaptive icon: `#0A0E27` (deep space navy)

## Generate adaptive icons

```bash
flutter pub run flutter_launcher_icons
```

This will produce all density buckets (mdpi → xxxhdpi) in `android/app/src/main/res/mipmap-*/`.

## Feature graphic
- File: `assets/images/feature_graphic.png`
- Size: 1024×500
- Suggested: gradient background + 3D-style phone mockup + "PulseFit AI — Your AI Coach" headline.
