import UIKit
import Foundation

extension String {
	/// convert `string` to `NSAttributedString.DocumentType.html`
	func toHTMLDocument(color: UIColor, font: UIFont) -> NSAttributedString? {
		
		guard let data = self.data(using: String.Encoding.utf8), data.count > 0 else { return nil }
		do {
			let html = try NSMutableAttributedString(data: data, options: [
				.documentType: NSAttributedString.DocumentType.html,
				.characterEncoding: String.Encoding.utf8.rawValue,
				], documentAttributes: nil)
			
			let paragraphStle = NSMutableParagraphStyle()
			paragraphStle.lineSpacing = 5
			
			html.beginEditing()
			html.addAttributes([NSAttributedStringKey.font: font], range: NSMakeRange(0, html.length))
			html.addAttributes([NSAttributedStringKey.foregroundColor: color], range: NSMakeRange(0, html.length))
			html.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStle], range: NSMakeRange(0, html.length))
			html.enumerateAttribute(NSAttributedStringKey.link, in: NSMakeRange(0, html.length), options: .init(rawValue: 0), using: { (value, range, stop) in
				if let link = value as? NSURL {
					html.addAttribute(.link, value: link, range: range)
					html.addAttribute(.foregroundColor, value: UIColor.linkBlue, range: range)
					html.addAttribute(.underlineColor, value: UIColor.clear, range: range)
				}
			})
			html.endEditing()
			return html
		} catch {
			print("error: ", error)
		}
		return nil
	}
	
	func htmlAttributed(font: UIFont, textColor: UIColor, linkColor: UIColor) -> NSAttributedString? {
		
		do {
			let CSSText = "<style>" +
			"p" +
			"{" +
			"font-size: \(font.pointSize)pt !important;" +
			"color: #\(textColor.htmlRGBColor) !important;" +
			"font-family: \(font.familyName), Helvetica !important;" +
			"}" +
			"a" +
			"{" +
			"text-decoration: none !important;" +
			"color: #\(linkColor.htmlRGBColor) !important;" +
			"} </style> \(self)"
			
			guard let data = CSSText.data(using: String.Encoding.utf8) else {
				return nil
			}
			
			return try NSAttributedString(data: data,
										  options: [.documentType: NSAttributedString.DocumentType.html,
													.characterEncoding: String.Encoding.utf8.rawValue],
										  documentAttributes: nil)
			
		} catch {
			print("error: ", error)
		}
		return nil
	}
	
	var htmlAttributed: (NSAttributedString?, NSDictionary?) {
		do {
			guard let data = data(using: String.Encoding.utf8) else {
				return (nil, nil)
			}
			
			var dict:NSDictionary?
			dict = NSMutableDictionary()
			
			return try (NSAttributedString(data: data,
										   options: [.documentType: NSAttributedString.DocumentType.html,
													 .characterEncoding: String.Encoding.utf8.rawValue],
										   documentAttributes: &dict), dict)
		} catch {
			print("error: ", error)
			return (nil, nil)
		}
	}
}
