import Foundation

public struct ShotLike: Codable {
	let id: Int
	let created_at: Date
	let shot: Shot
}

public struct UserShotLikesRequest: Request {
	public typealias Response = [ShotLike]
	public let path: String
	
	/// shotLikes for authenticated user
	init() {
		self.path = "/v1/user/likes"
	}
	
	init(userId: Int) {
		self.path = "/v1/users/\(userId)/likes"
	}
}
