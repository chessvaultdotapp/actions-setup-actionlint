#!/usr/bin/env bash
set -euo pipefail

if [[ ! "$ACTIONLINT_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  printf 'Expected an exact actionlint version without a v prefix, got: %s\n' "$ACTIONLINT_VERSION" >&2
  exit 1
fi

case "${RUNNER_OS}/${RUNNER_ARCH}" in
  Linux/X64) target=linux_amd64 ;;
  Linux/ARM64) target=linux_arm64 ;;
  macOS/X64) target=darwin_amd64 ;;
  macOS/ARM64) target=darwin_arm64 ;;
  Windows/X64) target=windows_amd64 ;;
  Windows/ARM64) target=windows_arm64 ;;
  *)
    printf 'Unsupported actionlint platform: %s/%s\n' "$RUNNER_OS" "$RUNNER_ARCH" >&2
    exit 1
    ;;
esac

extension=tar.gz
executable=actionlint
if [[ "$RUNNER_OS" == Windows ]]; then
  extension=zip
  executable=actionlint.exe
fi

install_dir=$(mktemp -d "${RUNNER_TEMP}/actionlint.XXXXXX")
archive="actionlint_${ACTIONLINT_VERSION}_${target}.${extension}"
curl --fail --silent --show-error --location --retry 3 \
  "https://github.com/rhysd/actionlint/releases/download/v${ACTIONLINT_VERSION}/${archive}" \
  --output "$install_dir/$archive"
if [[ "$RUNNER_OS" == Windows ]]; then
  unzip -q "$install_dir/$archive" -d "$install_dir"
else
  tar -xzf "$install_dir/$archive" -C "$install_dir"
fi
rm "$install_dir/$archive"

"$install_dir/$executable" --version

# GitHub expects a native Windows path, rather than Git Bash's /c/... form.
if [[ "$RUNNER_OS" == Windows ]]; then
  install_dir=$(cygpath -w "$install_dir")
fi
printf '%s\n' "$install_dir" >> "$GITHUB_PATH"
