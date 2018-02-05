import IGListKit

public class DRUser: Codable, ListDiffable {
	let id: Int
	let name: String
	let type: String
	let bio: String?
	let pro: Bool
	let avatarUrl: URL
	let username: String
	let location: String?
	let links: Links
	let canUploadShot: Bool
	let bucketsCount: Int
	let commentsReceivedCount: Int
	let followersCount: Int
	let followingsCount: Int
	let likesCount: Int
	let likesReceivedCount: Int
	let projectsCount: Int
	let reboundsReceivedCount: Int
	let shotsCount: Int
	let teamsCount: Int?
	
	private enum CodingKeys: String, CodingKey {
		case id, username, name, bio, type, pro, links, location
		case avatarUrl = "avatar_url"
		case canUploadShot = "can_upload_shot"
		case bucketsCount = "buckets_count"
		case followersCount = "followers_count"
		case followingsCount = "followings_count"
		case commentsReceivedCount = "comments_received_count"
		case likesCount = "likes_count"
		case likesReceivedCount = "likes_received_count"
		case projectsCount = "projects_count"
		case reboundsReceivedCount = "rebounds_received_count"
		case shotsCount = "shots_count"
		case teamsCount = "teams_count"
	}
	
	// MARK: ListDiffable
	
	public func diffIdentifier() -> NSObjectProtocol {
		return id as NSObjectProtocol
	}
	
	public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		guard self !== object else { return true }
		guard let object = object as? DRUser else { return false }
		return username == object.username && name == object.name
	}
}
