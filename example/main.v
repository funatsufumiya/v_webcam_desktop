import webcam_desktop

fn main(){
	println("openpnp-capture version: ${webcam_desktop.library_version()}")

	mut ctx := webcam_desktop.create_context()
	devices := webcam_desktop.list_devices(ctx)
	for device in devices {
		println('${device.id}: Name: ${device.name}, Unique ID: ${device.unique_id}')
	}
	webcam_desktop.release_context(mut ctx)
}