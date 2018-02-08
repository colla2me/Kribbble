import Foundation
import AsyncDisplayKit

extension UIImage {
	class func cachedImage(with url: URL) -> UIImage? {
		let manager = YYWebImageManager.shared()
		let cache = manager.cache
		return cache?.getImageForKey(manager.cacheKey(for: url), with: .all)
	}
}

