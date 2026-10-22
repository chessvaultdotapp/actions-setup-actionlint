# Setup actionlint

Install official [actionlint](https://github.com/rhysd/actionlint) release binaries
and add `actionlint` to `PATH` for subsequent GitHub Actions steps. No Go toolchain
is needed.

## Usage

After publishing this action, replace `FULL_COMMIT_SHA` with its full commit SHA:

```yaml
steps:
  - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
    with:
      persist-credentials: false
  - uses: chessvaultdotapp/actions-setup-actionlint@FULL_COMMIT_SHA
    with:
      version: '1.7.11'
  - run: actionlint -shellcheck= -pyflakes=
```

### Inputs

| Input | Description | Default |
| --- | --- | --- |
| `version` | Exact stable release version, without the `v` prefix | `1.7.11` |

`latest`, version ranges, and prerelease versions are not supported.

### Supported platforms

- Linux: x64 and ARM64
- macOS: x64 and ARM64
- Windows: x64 and ARM64

The action requires Bash, curl, and tar (or unzip on Windows). Downloads come
directly from actionlint's public GitHub releases; no token is required. Downloaded
binaries are not checksum-verified.

This action only installs actionlint. It does not install ShellCheck or Pyflakes.
The example disables those optional checks; omit the flags to let actionlint use
these tools when available on your runner.

## Maintenance

The installer and default version live in this repository. To update actionlint,
change `inputs.version.default` in `action.yml`, the explicit-version test in
`.github/workflows/test.yml`, and the examples and default documented here.

CI exercises all six supported platform combinations, including Ubuntu 24.04,
Ubuntu 26.04, and Ubuntu Slim. After the checks pass, publish the commit and update
consuming repositories to its full SHA. Keep repository-specific lint commands,
configuration, and path filters in consumers.

## Local checks

```sh
bash -n install.sh
shellcheck install.sh
rumdl check README.md
```

## License

See [LICENSE](LICENSE).
