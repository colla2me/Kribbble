import Foundation

public struct Follower: Codable {
	let id: Int
	let created_at: Date
	let follower: User
}

public struct UserFollowersRequest: Request {
	public typealias Response = [Follower]
	public let path: String
	
	/// followers for authenticated user
	init() {
		self.path = "/v1/user/followers"
	}
	
	init(userId: Int) {
		self.path = "/v1/users/\(userId)/followers"
	}
}
