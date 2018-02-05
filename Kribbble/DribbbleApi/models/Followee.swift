import Foundation

public struct Followee: Codable {
	let id: Int
	let created_at: Date
	let followee: User
}

public struct UserFolloweesRequest: Request {
	public typealias Response = [Followee]
	public let path: String
	
	/// followee for authenticated user
	init() {
		self.path = "/v1/user/following"
	}
	
	init(userId: Int) {
		self.path = "/v1/users/\(userId)/following"
	}
}

