import Foundation

public enum ResponseError: Error {
	/// Indicates the session adapter returned `URLResponse` that fails to down-cast to `HTTPURLResponse`.
	case nonHTTPURLResponse(URLResponse?)
	
	/// Indicates `HTTPURLResponse.statusCode` is not acceptable.
	/// In most cases, *acceptable* means the value is in `200..<300`.
	case unacceptableStatusCode(Int)
	
	/// Indicates `Any` that represents the response is unexpected.
	case unexpectedObject(Any)
	
	/// Indicates here is no NSCachedURLResponse stored with the given request
	case nonCachedURLResponse(Any)
}

public enum RequestError: Error {
	/// Indicates `baseURL` of a type that conforms `Request` is invalid.
	case invalidBaseURL(URL)
	
	/// Indicates `URLRequest` built by `Request.buildURLRequest` is unexpected.
	case unexpectedURLRequest(URLRequest)
}

public enum SessionTaskError: Error {
	/// Error of `URLSession`.
	case connectionError(Error)
	
	/// Error while creating `URLRequest` from `Request`.
	case requestError(Error)
	
	/// Error while creating `Request.Response` from `(Data, URLResponse)`.
	case responseError(Error)
}

//public struct ErrorEnvelope {
//	public let errorMessages: [String]
//	public let drbCode: DrbCode?
//	public let httpCode: Int
//	public let exception: Exception?
//
//	public init(errorMessages: [String], drbCode: DrbCode?, httpCode: Int, exception: Exception?) {
//		self.errorMessages = errorMessages
//		self.drbCode = drbCode
//		self.httpCode = httpCode
//		self.exception = exception
//	}
//
//	public enum DrbCode: String {
//		// Codes defined by the server
//		case AccessTokenInvalid = "access_token_invalid"
//		case InvalidOauthLogin = "invalid_Oauth_login"
//		// Catch all code for when server sends code we don't know about yet
//		case UnknownCode = "__internal_unknown_code"
//
//		// Codes defined by the client
//		case JSONParsingFailed = "json_parsing_failed"
//		case ErrorEnvelopeJSONParsingFailed = "error_json_parsing_failed"
//		case DecodingJSONFailed = "decoding_json_failed"
//		case InvalidPaginationUrl = "invalid_pagination_url"
//	}
//
//	public struct Exception {
//		public let backtrace: [String]?
//		public let message: String?
//	}
//
//	internal static let couldNotParseErrorEnvelopeJSON = ErrorEnvelope(
//		errorMessages: [],
//		drbCode: .ErrorEnvelopeJSONParsingFailed,
//		httpCode: 400,
//		exception: nil
//	)
//
//}

