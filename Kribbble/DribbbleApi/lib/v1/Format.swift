import Foundation

public enum Format {
	case percentage
	case currency
	case number
	case date
	
	/// refs: https://stackoverflow.com/questions/28016578/swift-how-to-create-a-date-time-stamp-and-format-as-iso-8601-rfc-3339-utc-tim
	static let iso8601: DateFormatter = {
		return dateFormatter(with: "YYYY-MM-dd'T'HH:mm:ssZ")
	}()
	
	/// refs: https://stackoverflow.com/questions/44682626/swifts-jsondecoder-with-multiple-date-formats-in-a-json-string
	static func iso8601Decoder(decoder: Decoder) throws -> Date {
		let container = try decoder.singleValueContainer()
		let dateStr = try container.decode(String.self)
		guard let date = Format.iso8601.date(from: dateStr) else {
			throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
		}
		return date
	}
	
	static func dateFormatter(with format: String, locale: Locale = Locale(identifier: "en_US_POSIX")) -> DateFormatter {
		let key: NSString = "\(format)|\(locale.identifier)" as NSString
		guard let fmt = Dribbble.cache.object(forKey: key) as? DateFormatter else {
			let formatter = DateFormatter()
			formatter.calendar = Calendar(identifier: .iso8601)
			formatter.timeZone = TimeZone(secondsFromGMT: 0)
			formatter.locale = locale
			formatter.dateFormat = format
			Dribbble.cache.setObject(formatter, forKey: key)
			return formatter
		}
		
		return fmt
	}
}

extension Date {
	var stringFromDate: String {
		return Format.iso8601.string(from: self)
	}
}

extension String {
	var dateFromString: Date? {
		return Format.iso8601.date(from: self)
	}
}
