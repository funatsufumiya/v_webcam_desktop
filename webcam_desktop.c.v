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

pub struct FormatInfo { 
pub mut:
	width u32
///< width in pixels
	height u32
///< height in pixels
	fourcc u32
///< fourcc code (platform dependent)
	fps u32
///< frames per second
	bpp u32
///< bits per pixel
}

pub fn get_capresult_string(res CapResult) string {
	match res {
		capresult_ok { return "OK" }
		capresult_err { return "Error" }
		capresult_devicenotfound { return "Device not found" }
		capresult_formatnotsupported { return "Format not supported" }
		capresult_propertynotsupported { return "Property not supported" }
		else { return "Unknown error" }
	}
}

pub fn create_context() CapContext {
	return cap_create_context()
}

pub fn release_context(ctx CapContext) {
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

pub fn open_stream(ctx CapContext, device_id CapDeviceID, format_id CapFormatID) !CapStream {
	stream := cap_open_stream(ctx, device_id, format_id)
	if cap_is_open_stream(ctx, stream) {
		return stream
	}else{
		return error("Failed to open stream")
	}
}

pub fn close_stream(ctx CapContext, stream CapStream) CapResult {
	return cap_close_stream(ctx, stream)
}

pub fn capture_frame(ctx CapContext, stream CapStream, mut buffer []u8) CapResult {
	return cap_capture_frame(ctx, stream, buffer.data, u32(buffer.len))
}

pub fn has_new_frame(ctx CapContext, stream CapStream) bool {
	return cap_has_new_frame(ctx, stream) == 1
}

pub fn get_num_formats(ctx CapContext, device_id CapDeviceID) int {
	return cap_get_num_formats(ctx, device_id)
}

pub fn get_format_info(ctx CapContext, device_id CapDeviceID, format_id CapFormatID) !FormatInfo {
	mut finfo := C.CapFormatInfo{}
	res := cap_get_format_info(ctx, device_id, format_id, mut finfo)
	if res == capresult_ok {
		return FormatInfo {
			width: finfo.width,
			height: finfo.height,
			fourcc: finfo.fourcc,
			fps: finfo.fps,
			bpp: finfo.bpp,
		}
	} else {
		return error(get_capresult_string(res))
	}
}