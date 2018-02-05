import IGListKit

public class DRShot: Codable, ListDiffable {
	
	let id: Int
	let title: String
	let description: String?
	let width: Int
	let height: Int
	let images: Images
	let viewsCount: Int
	let likesCount: Int
	let commentsCount: Int
	let attachmentsCount: Int
	let reboundsCount: Int
	let bucketsCount: Int
	let animated: Bool
	let tags: [String]?
	let user: DRUser
//	let team: Team?
	
	struct Images: Codable {
		let hidpi: URL?
		let normal: URL
		let teaser: URL
	}
	
	private enum CodingKeys: String, CodingKey {
		case id, title, width, height, images, description, animated, tags, user
		case viewsCount = "views_count"
		case likesCount = "likes_count"
		case commentsCount = "comments_count"
		case attachmentsCount = "attachments_count"
		case reboundsCount = "rebounds_count"
		case bucketsCount = "buckets_count"
	}
	
	// MARK: ListDiffable
	
	public func diffIdentifier() -> NSObjectProtocol {
		return id as NSObjectProtocol
	}
	
	public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		guard self !== object else { return true }
		guard let object = object as? DRShot else { return false }
		return user.isEqual(toDiffableObject: object.user)
	}
}

public class DRShotsRequest: Request {
	public typealias Response = [DRShot]
	public var query: [String : Any] = [:]
	public let path: String = "/v1/shots"
	
	init(page: Int?) {
		self.query["page"] = page.flatMap { $0 }
	}
}
