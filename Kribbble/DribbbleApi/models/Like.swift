import Foundation

public struct Like: Codable {
	let id: Int
	let created_at: Date
}

public struct LikeCommentRequest: Request {
	public typealias Response = Empty
	public let method: HTTPMethod = .POST
	public let path: String
	
	init(shotId: Int, commentId: Int) {
		self.path = "/v1/shots/\(shotId)/comments/\(commentId)/like"
	}
}

public struct UnLikeCommentRequest: Request {
	public typealias Response = Empty
	public let method: HTTPMethod = .DELETE
	public let path: String
	
	init(shotId: Int, commentId: Int) {
		self.path = "/v1/shots/\(shotId)/comments/\(commentId)/like"
	}
}

public struct CheckLikeCommentRequest: Request {
	public typealias Response = Empty
	public let path: String
	
	init(shotId: Int, commentId: Int) {
		self.path = "/v1/shots/\(shotId)/comments/\(commentId)/like"
	}
}
