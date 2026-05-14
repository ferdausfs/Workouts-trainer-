# Exercise Animations

This folder is reserved for Lottie (`.json`) and Rive (`.riv`) animations referenced by the `animationAsset` field in each `Exercise` entity (see `lib/data/local/exercise_database.dart`).

## Recommended sources (open-source / CC)

- **LottieFiles Free Library**: https://lottiefiles.com/free-animations/fitness
- **Rive Community**: https://rive.app/community/
- **Self-created**: Export from After Effects via Bodymovin (open source).

## Required animations

| Asset key | Suggested type |
|-----------|----------------|
| `pushup.json` | Lottie |
| `squat.json` | Lottie |
| `plank.json` | Lottie |
| `burpee.json` | Lottie or Rive |
| `pullup.json` | Lottie |
| `db_press.json` | Lottie |
| `db_curl.json` | Lottie |
| `db_row.json` | Lottie |
| `lunge.json` | Lottie |
| `rdl.json` | Lottie |
| `glute_bridge.json` | Lottie |
| `jumping_jack.json` | Lottie |
| `mountain_climber.json` | Lottie |
| `high_knees.json` | Lottie |
| `russian_twist.json` | Lottie |
| `crunch.json` | Lottie |
| ... and more (see `exercise_database.dart`) |

## License reminder
**Do NOT use copyrighted or paid animations without proper licensing.**
The app currently uses a styled fallback icon when an animation is missing — it will not crash if any asset is absent.
