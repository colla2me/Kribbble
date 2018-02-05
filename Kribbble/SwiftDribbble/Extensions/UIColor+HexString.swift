import UIKit

extension UIColor {
	
	func colorFromHex(rgbValue: UInt32) -> UIColor{
		let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 256.0
		let green = CGFloat((rgbValue & 0xFF00) >> 8) / 256.0
		let blue = CGFloat(rgbValue & 0xFF) / 256.0
		
		return UIColor(red:red, green:green, blue:blue, alpha:1.0)
	}
	
	var rgbComponents:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0
		if getRed(&r, green: &g, blue: &b, alpha: &a) {
			return (r,g,b,a)
		}
		return (0,0,0,0)
	}
	
	
	// hue, saturation, brightness and alpha components from UIColor**
	var hsbComponents:(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
		var hue: CGFloat = 0
		var saturation: CGFloat = 0
		var brightness: CGFloat = 0
		var alpha: CGFloat = 0
		if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha){
			return (hue,saturation,brightness,alpha)
		}
		return (0,0,0,0)
	}
	
	var htmlRGBColor: String {
		return String(format: "#%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255))
	}
	
	var htmlRGBaColor: String {
		return String(format: "#%02x%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255),Int(rgbComponents.alpha * 255) )
	}
}
