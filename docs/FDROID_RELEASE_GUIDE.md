# Releasing IsShopping on Official F-Droid

This guide outlines how to submit **IsShopping** to the official public F-Droid repository ([`fdroid/fdroiddata`](https://gitlab.com/fdroid/fdroiddata)) and how future releases will update automatically.

---

## Why F-Droid?

- **No Tester Hurdles**: Bypasses Google Play's 20-tester 14-day requirement entirely.
- **Built Directly From Source**: F-Droid builds apps transparently from your GitHub repository using their secure build infrastructure.
- **Privacy & FOSS First**: No proprietary tracking, closed-source dependencies, or Play Services required.
- **Automated Updates**: Once merged, F-Droid automatically discovers new Git tags and publishes updates with zero manual intervention.

---

## What Has Been Prepared

1. **FOSS Compliance**:
   - Removed proprietary Microsoft font (`Segore.ttf`) and standardized typography on open-source **Manrope** (SIL Open Font License).
   - Removed unused font assets to reduce download size.
   - Verified that zero network permissions and zero telemetry exist.
2. **Fastlane Store Metadata**:
   - Created in-repo metadata in `fastlane/metadata/android/en-US/`:
     - `title.txt`: App name.
     - `short_description.txt`: Summary (< 80 chars).
     - `full_description.txt`: Full feature list.
     - `images/icon.png`: 512x512 app icon.
     - `images/phoneScreenshots/1.png`: Phone screenshot.
     - `changelogs/16.txt`: Version 2.0.2 release notes.
   - F-Droid's client automatically pulls this metadata from your GitHub repository.
3. **F-Droid Build Recipe**:
   - Ready-to-submit YAML recipe created at [`fdroid/com.lovaszakos.is_shopping.yml`](../fdroid/com.lovaszakos.is_shopping.yml).
4. **Gradle Wrapper**:
   - Switched to `gradle-8.7-bin.zip` adhering to F-Droid build environment standards.

---

## Step 1: Commit and Tag the Release

Commit the font cleanups, Fastlane metadata, and version bump, then push the tag to GitHub:

```bash
git add .
git commit -m "Prepare v2.0.2 for official F-Droid release"
git push origin <your-working-branch>

# Ensure changes are merged into main, then create and push the release tag:
git checkout main
git merge <your-working-branch>
git push origin main

git tag v2.0.2
git push origin v2.0.2
```

> [!IMPORTANT]
> The tag name **`v2.0.2`** must match the `commit: v2.0.2` line in `com.lovaszakos.is_shopping.yml`.

---

## Step 2: Submit the Merge Request to F-Droid

The official F-Droid catalogue is maintained on GitLab at [`gitlab.com/fdroid/fdroiddata`](https://gitlab.com/fdroid/fdroiddata).

1. Log into or create an account on [GitLab](https://gitlab.com).
2. Go to the F-Droid metadata repository: [https://gitlab.com/fdroid/fdroiddata](https://gitlab.com/fdroid/fdroiddata).
3. Click **Fork** (top right) to create a fork in your own GitLab account.
4. In your fork:
   - Create a new branch (e.g., `add-com.lovaszakos.is_shopping`).
   - Create a new file under `metadata/com.lovaszakos.is_shopping.yml`.
   - Copy and paste the contents of [`fdroid/com.lovaszakos.is_shopping.yml`](../fdroid/com.lovaszakos.is_shopping.yml).
   - Commit the file with message: `Add com.lovaszakos.is_shopping`.
5. Open a **Merge Request** from your fork to `fdroid/fdroiddata:master`:
   - F-Droid will provide a "New App" MR template.
   - Fill out the short checklist (confirming the app is open-source, GPL-3.0, and has no proprietary blobs or anti-features).
6. Submit the Merge Request!

---

## Step 3: Review and Publishing

- **Automated CI**: F-Droid's GitLab CI pipeline will automatically run `fdroid lint` and test the build recipe on a clean Docker container.
- **Review**: A human volunteer from the F-Droid team will review the MR (usually within a few days) and merge it.
- **App Store Indexing**: Once merged, F-Droid's build server compiles the APK, signs it with F-Droid's key, and publishes it to the official F-Droid index (available to all users of the F-Droid app).

---

## How Future Releases Work (Fully Automated)

You do **not** need to open a new Merge Request for future updates!

Because `AutoUpdateMode: Version` and `UpdateCheckMode: Tags` are set:
1. When you develop a new version, increment `version:` in `pubspec.yaml` (e.g. `version: 2.0.3+17`).
2. Add a new changelog file in `fastlane/metadata/android/en-US/changelogs/17.txt`.
3. Commit, push, and push a matching Git tag (e.g., `git tag v2.0.3 && git push origin v2.0.3`).
4. F-Droid's `checkupdates` bot checks tags periodically, automatically notices the new tag, compiles the release, and updates your app on F-Droid!
