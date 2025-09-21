# v_webcam_desktop

Webcam desktop for V-lang (using [openpnp-capture](https://github.com/openpnp/openpnp-capture))

## Install

```bash
$ git clone --recursive https://github.com/funatsufumiya/v_webcam_desktop ~/.vmodules/webcam_desktop
```

## Example (using gg)

### linux

```bash
$ LD_LIBRARY_PATH=~/.vmodules/webcam_desktop/libs/ubuntu_x86_64 v run ~/.vmodules/webcam_desktop/example/main.v
```

### mac
```bash
$ DYLD_LIBRARY_PATH=~/.vmodules/webcam_desktop/libs/macos_arm64 v run ~/.vmodules/webcam_desktop/example/main.v
```

### windows

#### powershell
```powershell
$env:PATH += ";$env:USERPROFILE\.vmodules\webcam_desktop\libs\windows_x86_64"
v run $env:USERPROFILE\.vmodules\webcam_desktop\example\main.v
```

#### cmd

```cmd
set PATH=%PATH%;%USERPROFILE%\.vmodules\webcam_desktop\libs\windows_x86_64
v run %USERPROFILE%\.vmodules\webcam_desktop\example\main.v
```