# v_webcam_desktop

Webcam desktop for V-lang (using [openpnp-capture](https://github.com/openpnp/openpnp-capture))

## Install

```bash
$ git clone https://github.com/funatsufumiya/v_webcam_desktop ~/.vmodules/webcam_desktop
```

## Example (using gg)

```bash
$ v run ~/.vmodules/webcam_desktop/example/main.v

# if mac
$ DYLD_LIBRARY_PATH=~/.vmodules/webcam_desktop/libs/macos_arm64 v run ~/.vmodules/webcam_desktop/example/main.v
```