import Foundation
import AsyncDisplayKit

final class YYWebImageNode: ASNetworkImageNode {
	
	override init(cache: ASImageCacheProtocol?, downloader: ASImageDownloaderProtocol) {
		let manager = YYWebImageManager.shared()
		super.init(cache: manager, downloader: manager)
	}
}

