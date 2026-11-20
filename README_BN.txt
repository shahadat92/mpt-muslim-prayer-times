MPT v1.5.3 DAILY DUAS - 8 LANGUAGES

Upload these THREE files to the SAME relative paths in your GitHub repository:
  1) lib/mpt_daily_duas_additions.dart    (NEW)
  2) integrate_daily_duas.py              (NEW, repo root)
  3) codemagic.yaml                       (REPLACE existing root file)

IMPORTANT: This update uses a build-time integration script. It patches the
working copy of lib/mpt_learning.dart inside Codemagic, not the GitHub copy.
Existing UI, prayer alarms, native Kotlin files and other Dart files remain
unchanged in GitHub. The script stops the build if the expected original
source structure has changed, rather than making an unsafe edit.

Contains 7 distinct duas covering 8 requested occasions. Each has Arabic,
8 localized titles, 8 pronunciation guides and 8 meanings. Pronunciations
are approximate and should be reviewed by qualified native speakers.

Not yet Flutter-compiled or device-tested. First run Codemagic DEBUG build.
Keep a backup of codemagic.yaml before replacing it.

REVISED 2026-11-20: pronunciation and source review; see REVIEW_NOTES_BN.txt.
After upload, run: python3 verify_daily_duas.py (optional local check).
Do not replace the existing 1.5.3 app in production until Codemagic and device testing passes.
