import gg
import webcam_desktop

const win_width = 640
const win_height = 480

struct App {
mut:
	gg      &gg.Context = unsafe { nil }
	ctx     webcam_desktop.CapContext
	stream  webcam_desktop.CapStream
	has_image bool
	image   int // gg.Image
	buffer  []u8
	width   int
	height  int
}

fn main() {
	mut app := &App{}

	// Create buffer
	app.buffer = []u8{len: app.width * app.height * 3}

	// Create gg context
	app.gg = gg.new_context(
		bg_color:      gg.black
		width:         win_width
		height:        win_height
		create_window: true
		window_title:  'Webcam Viewer'
		frame_fn:      frame
		init_fn:       init
		quit_fn:       on_quit
		user_data:     app
	)

	// // Create image
	// webcam_desktop.capture_frame(app.ctx, app.stream, mut app.buffer)
	// // res := webcam_desktop.capture_frame(app.ctx, app.stream, mut app.buffer)
	// // println(webcam_desktop.get_capresult_string(res))
	// app.image = app.gg.create_image_from_byte_array(app.buffer) or {
	// 	println('Failed to create image: ${err}')
	// 	return
	// }

	app.gg.run()
}

fn init(mut app App) {
	println("openpnp-capture version: ${webcam_desktop.library_version()}")

	app.ctx = webcam_desktop.create_context()

	devices := webcam_desktop.list_devices(app.ctx)

	if devices.len == 0 {
		println('No device')
		return
	}

	// Use first device
	device := devices[0]
	println('Using device: ${device.name} (ID: ${device.id})')

	// Get format info (use format 0)
	num_formats := webcam_desktop.get_num_formats(app.ctx, u32(device.id))
	if num_formats <= 0 {
		println('No formats available')
		return
	}

	finfo := webcam_desktop.get_format_info(app.ctx, u32(device.id), 0) or { panic(err) }
	app.width = int(finfo.width)
	app.height = int(finfo.height)
	println('Format: ${app.width}x${app.height} @ ${finfo.fps} FPS')

	// Open stream
	app.stream = webcam_desktop.open_stream(app.ctx, u32(device.id), 0) or { panic(err) }

    app.image = app.gg.new_streaming_image(app.width, app.height, 3, gg.StreamingImageConfig{
        pixel_format: .rgba8
    })
}

fn on_quit(event &gg.Event, mut app App) {
	// println("quit")
	if unsafe {app.stream >= 0 && app.ctx != nil}  {
		webcam_desktop.close_stream(app.ctx, app.stream)
	}

	if unsafe {app.ctx != nil}  {
		webcam_desktop.release_context(app.ctx)
	}
}

fn frame(mut app App) {
	app.gg.begin()
	app.update_frame()
	app.gg.end()
}

fn (mut app App) update_frame() {
	if webcam_desktop.has_new_frame(app.ctx, app.stream) {
		webcam_desktop.capture_frame(app.ctx, app.stream, mut app.buffer)
		mut rgba_buffer := []u8{len: app.width * app.height * 4}
        for i in 0..app.buffer.len / 3 {
            rgba_buffer[i * 4] = app.buffer[i * 3]     // R
            rgba_buffer[i * 4 + 1] = app.buffer[i * 3 + 1] // G
            rgba_buffer[i * 4 + 2] = app.buffer[i * 3 + 2] // B
            rgba_buffer[i * 4 + 3] = 255  // Alpha
        }
		app.gg.update_pixel_data(app.image, app.buffer.data)
	}
	app.gg.draw_image_by_id(0, 0, app.width, app.height, app.image)
}