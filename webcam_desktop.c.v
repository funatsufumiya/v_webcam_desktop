module webcam_desktop

#flag -I @VMODROOT/c

#include "openpnp-capture.h"

$if windows && x64 {
#flag -L @VMODROOT/libs/windows_x86_64
#flag -lopenpnp-capture
}

$if linux && x64 {
#flag -L @VMODROOT/libs/ubuntu_x86_64
#flag -lopenpnp-capture
}

$if linux && arm64 {
#flag -L @VMODROOT/libs/ubuntu_arm64
#flag -lopenpnp-capture
}

$if macos && x64 {
#flag -L @VMODROOT/libs/macos_x86_64
#flag -lopenpnp-capture
}

$if macos && arm64 {
#flag -L @VMODROOT/libs/macos_arm64
#flag -lopenpnp-capture
}

pub fn version() int {
	return int(*webcam_desktop.cap_get_library_version())
}