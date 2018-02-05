import Foundation

public struct Team: Codable {
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
	let likesCount: Int
	let likesReceivedCount: Int
	let shotsCount: Int
	let bucketsCount: Int
	let projectsCount: Int
	let reboundsReceivedCount: Int
	let commentsReceivedCount: Int
	let followersCount: Int
	let followingsCount: Int
	
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
	}
}

public struct UserTeamsRequest: Request {
	public typealias Response = [Team]
	public let path: String
	
	/// teams for authenticated user
	init() {
		self.path = "/v1/user/teams"
	}
	
	init(userId: Int) {
		self.path = "/v1/users/\(userId)/teams"
	}
}
