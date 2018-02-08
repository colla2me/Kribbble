import Foundation
import AsyncDisplayKit

extension YYWebImageManager: ASImageCacheProtocol, ASImageDownloaderProtocol {
	public func downloadImage(
		with URL: URL,
		callbackQueue: DispatchQueue,
		downloadProgress: ASImageDownloaderProgress?,
		completion: @escaping ASImageDownloaderCompletion) -> Any? {
		
		weak var operation: YYWebImageOperation?
		
		operation = requestImage(
			with: URL,
			options: .setImageWithFadeAnimation,
			progress: { (received, expected) -> Void in
				callbackQueue.async {
					let progress = expected == 0 ? 0 : received / expected
					downloadProgress?(CGFloat(progress))
				}
			}, transform: nil, completion: { (image, url, from, state, error) in
			completion(image, error, operation)
		})
		
		return operation
	}
	
	public func cancelImageDownload(forIdentifier downloadIdentifier: Any) {
		guard let operation = downloadIdentifier as? YYWebImageOperation else {
			return
		}
		operation.cancel()
	}
	
	public func cachedImage(
		with URL: URL,
		callbackQueue: DispatchQueue,
		completion: @escaping ASImageCacherCompletion) {
		cache?.getImageForKey(cacheKey(for: URL), with: .all, with: { (image, cacheType) in
			callbackQueue.async {
				completion(image)
			}
		})
	}
}


