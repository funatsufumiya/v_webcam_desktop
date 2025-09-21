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

pub fn library_version() string {
	return unsafe { cstring_to_vstring(cap_get_library_version()) }
}

pub struct DeviceInfo {
pub mut:
	id usize
	name string
	unique_id string
}

pub fn create_context() CapContext {
	return cap_create_context()
}

pub fn release_context(mut ctx CapContext) {
	cap_release_context(ctx)
}

pub fn list_devices(ctx CapContext) []DeviceInfo {
	mut devices := []DeviceInfo{}
	device_count := cap_get_device_count(ctx)
	for i := u32(0); i < device_count; i++ {
		name := cap_get_device_name(ctx, i)
		unique_id := cap_get_device_unique_id(ctx, i)
		unsafe { devices << DeviceInfo{ i, cstring_to_vstring(name), cstring_to_vstring(unique_id) } }
	}
	return devices
}