import webcam_desktop

fn main(){
	println("openpnp-capture version: ${webcam_desktop.library_version()}")

	mut ctx := webcam_desktop.create_context()
	defer {	webcam_desktop.release_context(mut ctx) }

	devices := webcam_desktop.list_devices(ctx)

	if devices.len == 0 {
		println('No device')
	}
	for device in devices {
		println('${device.id}: Name: ${device.name}, Unique ID: ${device.unique_id}')
	}
}