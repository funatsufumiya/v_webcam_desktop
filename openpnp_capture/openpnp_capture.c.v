@[translated]
module openpnp_capture

//
//
//    OpenPnp-Capture: a video capture subsystem.
//
//    Copyright (c) 2017 Jason von Nieda, Niels Moseley.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.
//
//!
//* @file
//* @brief C API for OpenPnP Capture Library
//
// 
//
// make sure its exported/imported as pure C 
// even if we're compiling with a C++ compiler
pub type CapContext = voidptr
///< an opaque pointer to the internal Context*
pub type CapStream = int
///< a stream identifier (normally >=0, <0 for error)
pub type CapResult = u32
///< result defined by CAPRESULT_xxx
pub type CapDeviceID = u32
///< unique device ID
pub type CapFormatID = u32
///< format identifier 0 .. numFormats
// supported properties:
pub type CapPropertyID = u32
///< property ID (exposure, zoom, focus etc.)
pub struct C.CapFormatInfo { 
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
//*****************************************
//     CONTEXT CREATION AND DEVICE ENUMERATION
//*****************************************/
//
///* Initialize the capture library
//    @return The context ID.
//
fn C.Cap_createContext() CapContext

pub fn cap_create_context() CapContext {
	return C.Cap_createContext()
}

//*Un-initialize the capture library context
//    @param ctx The ID of the context to destroy.
//    @return The context ID.
//
fn C.Cap_releaseContext(ctx CapContext) CapResult

pub fn cap_release_context(ctx CapContext) CapResult {
	return C.Cap_releaseContext(ctx)
}

//*Get the number of capture devices on the system.
//    note: this can change dynamically due to the
//    pluggin and unplugging of USB devices.
//    @param ctx The ID of the context.
//    @return The number of capture devices found.
//
fn C.Cap_getDeviceCount(ctx CapContext) u32

pub fn cap_get_device_count(ctx CapContext) u32 {
	return C.Cap_getDeviceCount(ctx)
}

//*Get the name of a capture device.
//    This name is meant to be displayed in GUI applications,
//    i.e. its human readable.
//
//    if a device with the given index does not exist,
//    NULL is returned.
//    @param ctx The ID of the context.
//    @param index The device index of the capture device.
//    @return a pointer to an UTF-8 string containting the name of the capture device.
//
fn C.Cap_getDeviceName(ctx CapContext, index CapDeviceID) &i8

pub fn cap_get_device_name(ctx CapContext, index CapDeviceID) &i8 {
	return C.Cap_getDeviceName(ctx, index)
}

//*Get the unique name of a capture device.
//    The string contains a unique concatenation
//    of the device name and other parameters.
//    These parameters are platform dependent.
//
//    Note: when a USB camera does not expose a serial number,
//          platforms might have trouble uniquely identifying 
//          a camera. In such cases, the USB port location can
//          be used to add a unique feature to the string.
//          This, however, has the down side that the ID of
//          the camera changes when the USB port location 
//          changes. Unfortunately, there isn't much to
//          do about this.
//
//    if a device with the given index does not exist,
//    NULL is returned.
//    @param ctx The ID of the context.
//    @param index The device index of the capture device.
//    @return a pointer to an UTF-8 string containting the unique ID of the capture device.
//
fn C.Cap_getDeviceUniqueID(ctx CapContext, index CapDeviceID) &i8

pub fn cap_get_device_unique_id(ctx CapContext, index CapDeviceID) &i8 {
	return C.Cap_getDeviceUniqueID(ctx, index)
}

//*Returns the number of formats supported by a certain device.
//    returns -1 if device does not exist.
//
//    @param ctx The ID of the context.
//    @param index The device index of the capture device.
//    @return The number of formats supported or -1 if the device does not exist.
//
fn C.Cap_getNumFormats(ctx CapContext, index CapDeviceID) int

pub fn cap_get_num_formats(ctx CapContext, index CapDeviceID) int {
	return C.Cap_getNumFormats(ctx, index)
}

//*Get the format information from a device. 
//    @param ctx The ID of the context.
//    @param index The device index of the capture device.
//    @param id The index/ID of the frame buffer format (0 .. number returned by Cap_getNumFormats() minus 1 ).
//    @param info pointer to a C.CapFormatInfo structure to be filled with data.
//    @return The CapResult.
//
fn C.Cap_getFormatInfo(ctx CapContext, index CapDeviceID, id CapFormatID, info &C.CapFormatInfo) CapResult

pub fn cap_get_format_info(ctx CapContext, index CapDeviceID, id CapFormatID, info &C.CapFormatInfo) CapResult {
	return C.Cap_getFormatInfo(ctx, index, id, info)
}

//*****************************************
//     STREAM MANAGEMENT
//*****************************************/
//
///* Open a capture stream to a device with specific format requirements 
//
//    Although the (internal) frame buffer format is set via the fourCC ID,
//    the frames returned by Cap_captureFrame are always 24-bit RGB.
//
//    @param ctx The ID of the context.
//    @param index The device index of the capture device.
//    @param formatID The index/ID of the frame buffer format (0 .. number returned by Cap_getNumFormats() minus 1 ).
//    @return The stream ID or -1 if the device does not exist or the stream format ID is incorrect.
//
fn C.Cap_openStream(ctx CapContext, index CapDeviceID, format_id CapFormatID) CapStream

pub fn cap_open_stream(ctx CapContext, index CapDeviceID, format_id CapFormatID) CapStream {
	return C.Cap_openStream(ctx, index, format_id)
}

//*Close a capture stream 
//    @param ctx The ID of the context.
//    @param stream The stream ID.
//    @return CapResult
//
fn C.Cap_closeStream(ctx CapContext, stream CapStream) CapResult

pub fn cap_close_stream(ctx CapContext, stream CapStream) CapResult {
	return C.Cap_closeStream(ctx, stream)
}

//*Check if a stream is open, i.e. is capturing data. 
//    @param ctx The ID of the context.
//    @param stream The stream ID.
//    @return 1 if the stream is open and capturing, else 0. 
//
fn C.Cap_isOpenStream(ctx CapContext, stream CapStream) u32

pub fn cap_is_open_stream(ctx CapContext, stream CapStream) u32 {
	return C.Cap_isOpenStream(ctx, stream)
}

//*****************************************
//     FRAME CAPTURING / INFO
//*****************************************/
//
///* this function copies the most recent RGB frame data
//    to the given buffer.
//
fn C.Cap_captureFrame(ctx CapContext, stream CapStream, rgb_buffer_ptr voidptr, rgb_buffer_bytes u32) CapResult

pub fn cap_capture_frame(ctx CapContext, stream CapStream, rgb_buffer_ptr voidptr, rgb_buffer_bytes u32) CapResult {
	return C.Cap_captureFrame(ctx, stream, rgb_buffer_ptr, rgb_buffer_bytes)
}

//*returns 1 if a new frame has been captured, 0 otherwise 
fn C.Cap_hasNewFrame(ctx CapContext, stream CapStream) u32

pub fn cap_has_new_frame(ctx CapContext, stream CapStream) u32 {
	return C.Cap_hasNewFrame(ctx, stream)
}

//*returns the number of frames captured during the lifetime of the stream. 
//    For debugging purposes 
fn C.Cap_getStreamFrameCount(ctx CapContext, stream CapStream) u32

pub fn cap_get_stream_frame_count(ctx CapContext, stream CapStream) u32 {
	return C.Cap_getStreamFrameCount(ctx, stream)
}

//*****************************************
//     NEW CAMERA CONTROL API FUNCTIONS
//*****************************************/
//
///* get the min/max limits and default value of a camera/stream property (e.g. zoom, exposure etc) 
//
//    returns: CAPRESULT_OK if all is well.
//             CAPRESULT_PROPERTYNOTSUPPORTED if property not available.
//             CAPRESULT_ERR if context, stream are invalid.
//
fn C.Cap_getPropertyLimits(ctx CapContext, stream CapStream, prop_id CapPropertyID, min &int, max &int, d_value &int) CapResult

pub fn cap_get_property_limits(ctx CapContext, stream CapStream, prop_id CapPropertyID, min &int, max &int, d_value &int) CapResult {
	return C.Cap_getPropertyLimits(ctx, stream, prop_id, min, max, d_value)
}

//*set the value of a camera/stream property (e.g. zoom, exposure etc) 
//
//    returns: CAPRESULT_OK if all is well.
//             CAPRESULT_PROPERTYNOTSUPPORTED if property not available.
//             CAPRESULT_ERR if context, stream are invalid.
//
fn C.Cap_setProperty(ctx CapContext, stream CapStream, prop_id CapPropertyID, value int) CapResult

pub fn cap_set_property(ctx CapContext, stream CapStream, prop_id CapPropertyID, value int) CapResult {
	return C.Cap_setProperty(ctx, stream, prop_id, value)
}

//*set the automatic flag of a camera/stream property (e.g. zoom, focus etc) 
//
//    returns: CAPRESULT_OK if all is well.
//             CAPRESULT_PROPERTYNOTSUPPORTED if property not available.
//             CAPRESULT_ERR if context, stream are invalid.
//
fn C.Cap_setAutoProperty(ctx CapContext, stream CapStream, prop_id CapPropertyID, b_on_off u32) CapResult

pub fn cap_set_auto_property(ctx CapContext, stream CapStream, prop_id CapPropertyID, b_on_off u32) CapResult {
	return C.Cap_setAutoProperty(ctx, stream, prop_id, b_on_off)
}

//*get the value of a camera/stream property (e.g. zoom, exposure etc) 
//
//    returns: CAPRESULT_OK if all is well.
//             CAPRESULT_PROPERTYNOTSUPPORTED if property not available.
//             CAPRESULT_ERR if context, stream are invalid or outValue == NULL.
//
fn C.Cap_getProperty(ctx CapContext, stream CapStream, prop_id CapPropertyID, out_value &int) CapResult

pub fn cap_get_property(ctx CapContext, stream CapStream, prop_id CapPropertyID, out_value &int) CapResult {
	return C.Cap_getProperty(ctx, stream, prop_id, out_value)
}

//*get the automatic flag of a camera/stream property (e.g. zoom, focus etc) 
//
//    returns: CAPRESULT_OK if all is well.
//             CAPRESULT_PROPERTYNOTSUPPORTED if property not available.
//             CAPRESULT_ERR if context, stream are invalid.
//
fn C.Cap_getAutoProperty(ctx CapContext, stream CapStream, prop_id CapPropertyID, out_value &u32) CapResult

pub fn cap_get_auto_property(ctx CapContext, stream CapStream, prop_id CapPropertyID, out_value &u32) CapResult {
	return C.Cap_getAutoProperty(ctx, stream, prop_id, out_value)
}

//*****************************************
//     DEBUGGING
//*****************************************/
//
///*
//    Set the logging level.
//
//    LOG LEVEL ID  | LEVEL 
//    ------------- | -------------
//    LOG_EMERG     | 0
//    LOG_ALERT     | 1
//    LOG_CRIT      | 2
//    LOG_ERR       | 3
//    LOG_WARNING   | 4
//    LOG_NOTICE    | 5
//    LOG_INFO      | 6    
//    LOG_DEBUG     | 7
//    LOG_VERBOSE   | 8
//
//
fn C.Cap_setLogLevel(level u32)

pub fn cap_set_log_level(level u32) {
	C.Cap_setLogLevel(level)
}

type CapCustomLogFunc = fn (u32, &i8)
//*install a custom callback for a logging function.
//
//    the callback function must have the following 
//    structure:
//
//        void func(uint32_t level, const char *tring);
//
fn C.Cap_installCustomLogFunction(log_func CapCustomLogFunc)

pub fn cap_install_custom_log_function(log_func CapCustomLogFunc) {
	C.Cap_installCustomLogFunction(log_func)
}

//*Return the version of the library as a string.
//    In addition to a version number, this should 
//    contain information on the platform,
//    e.g. Win32/Win64/Linux32/Linux64/OSX etc,
//    wether or not it is a release or debug
//    build and the build date.
//
//    When building the library, please set the 
//    following defines in the build environment:
//
//    __LIBVER__
//    __PLATFORM__
//    __BUILDTYPE__
//    
//
fn C.Cap_getLibraryVersion() &i8

pub fn cap_get_library_version() &i8 {
	return C.Cap_getLibraryVersion()
}

