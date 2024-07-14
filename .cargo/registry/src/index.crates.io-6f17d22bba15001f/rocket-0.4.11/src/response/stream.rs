use std::io::Read;
use std::fmt::{self, Debug};

use request::Request;
use response::{Response, Responder, DEFAULT_CHUNK_SIZE};
use http::Status;

/// Streams a response to a client from an arbitrary `Read`er type.
///
/// The client is sent a "chunked" response, where the chunk size is at most
/// 4KiB. This means that at most 4KiB are stored in memory while the response
/// is being sent. This type should be used when sending responses that are
/// arbitrarily large in size, such as when streaming from a local socket.
pub struct Stream<T: Read>(T, u64);

impl<T: Read> Stream<T> {
    /// Create a new stream from the given `reader` and sets the chunk size for
    /// each streamed chunk to `chunk_size` bytes.
    ///
    /// # Example
    ///
    /// Stream a response from whatever is in `stdin` with a chunk size of 10
    /// bytes. Note: you probably shouldn't do this.
    ///
    /// ```rust
    /// use std::io;
    /// use rocket::response::Stream;
    ///
    /// # #[allow(unused_variables)]
    /// let response = Stream::chunked(io::stdin(), 10);
    /// ```
    ///
    /// # Buffering and blocking
    ///
    /// Normally, data will be buffered and sent only in complete `chunk_size`
    /// chunks.
    ///
    /// With the feature `sse` enabled, the `Read`er may signal that data sent
    /// so far should be transmitted in a timely fashion (e.g. it is responding
    /// to a Server-Side Events (JavaScript `EventSource`) request. To do this
    /// it should return an [io::Error](std::io::Error) of kind `WouldBlock`
    /// (which should not normally occur), after returning a collection of data.
    /// This will cause a flush of data seen so far, rather than being treated
    /// as an error.
    ///
    /// Note that long-running responses may easily exhaust Rocket's thread
    /// pool, so consider increasing the number of threads. If doing SSE, also
    /// note the 'maximum open connections' browser limitation which is
    /// described in the [EventSource
    /// documentation](https://developer.mozilla.org/en-US/docs/Web/API/EventSource)
    /// on the Mozilla Developer Network.
    ///
    /// Without the `sse` feature, a `WouldBlock` error is treated as an actual
    /// error.
    pub fn chunked(reader: T, chunk_size: u64) -> Stream<T> {
        Stream(reader, chunk_size)
    }
}

impl<T: Read + Debug> Debug for Stream<T> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        f.debug_tuple("Stream").field(&self.0).finish()
    }
}

/// Create a new stream from the given `reader`.
///
/// # Example
///
/// Stream a response from whatever is in `stdin`. Note: you probably
/// shouldn't do this.
///
/// ```rust
/// use std::io;
/// use rocket::response::Stream;
///
/// # #[allow(unused_variables)]
/// let response = Stream::from(io::stdin());
/// ```
impl<T: Read> From<T> for Stream<T> {
    fn from(reader: T) -> Self {
        Stream(reader, DEFAULT_CHUNK_SIZE)
    }
}

/// Sends a response to the client using the "Chunked" transfer encoding. The
/// maximum chunk size is 4KiB.
///
/// # Failure
///
/// If reading from the input stream fails at any point during the response, the
/// response is abandoned, and the response ends abruptly. An error is printed
/// to the console with an indication of what went wrong.
impl<'r, T: Read + 'r> Responder<'r> for Stream<T> {
    fn respond_to(self, _: &Request) -> Result<Response<'r>, Status> {
        Response::build().chunked_body(self.0, self.1).ok()
    }
}
