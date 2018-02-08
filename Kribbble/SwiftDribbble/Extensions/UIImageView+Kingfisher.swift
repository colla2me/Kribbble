import Foundation
import Kingfisher

typealias ImageOptions = KingfisherOptionsInfo
typealias DownloadResourceBlock = ((ImageResult) -> Void)

enum ImageResult {
	case success(UIImage)
	case failure(Error)
	
	var image: UIImage? {
		switch self {
		case .success(let image):
			return image
		default:
			return nil
		}
	}
	
	var error: Error? {
		switch self {
		case .failure(let error):
			return error
		default:
			return nil
		}
	}
}

extension UIImageView {
	@discardableResult
	func setImage(
		with resource: Resource?,
		placeholder: UIImage? = nil,
		options: ImageOptions? = nil,
		progress: DownloadProgressBlock? = nil,
		completion: DownloadResourceBlock? = nil
		) -> RetrieveImageTask {
		
		var options = options ?? []
		if self is AnimatedImageView == false {
			options.append(.onlyLoadFirstFrame)
		}
		
		let completionHandler: CompletionHandler = { image, error, _, _ in
			if let image = image {
				completion?(.success(image))
			} else if let error = error {
				completion?(.failure(error))
			}
		}
		
		self.kf.indicatorType = .activity
		return self.kf.setImage(
			with: resource,
			placeholder: placeholder,
			options: options,
			progressBlock: progress,
			completionHandler: completionHandler
		)
	}
}
