import Foundation
import UIKit

public struct Comment: Codable {
	let id: Int
	let body: String
	let likesUrl: URL
	let likesCount: Int
	let created_at: Date
	let user: User
	
	private enum CodingKeys: String, CodingKey {
		case id, body, created_at, user
		case likesUrl = "likes_url"
		case likesCount = "likes_count"
//		case body = "body_text"
	}
	
	var bodyHeight: CGFloat {
		let font = UIFont.systemFont(ofSize: 16)
		return NSString(string: body).boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 74, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
	}
}

public struct CommentsRequest: Request {
	public typealias Response = [Comment]
	public let path: String
//	public var header: [String : String]? {
//		return ["Accept": "application/vnd.dribbble.v1.text+json"]
//	}
	init(shotId: Int) {
		self.path = "/v1/shots/\(shotId)/comments"
	}
}

public struct LikesForCommentRequest: Request {
	public typealias Response = [Comment]
	public let path: String
	
	init(shotId: Int, commentId: Int) {
		self.path = "/v1/shots/\(shotId)/comments/\(commentId)/likes"
	}
}

public struct PostCommentRequest: Request {
	public typealias Response = Comment
	public let method: HTTPMethod = .POST
	public let query: [String : Any]
	public let path: String
	
	init(shotId: Int, body: String) {
		self.query = ["body": body]
		self.path = "/v1/shots/\(shotId)/comments"
	}
}

public struct UpdateCommentRequest: Request {
	public typealias Response = Comment
	public let method: HTTPMethod = .PUT
	public let path: String
	
	init(shotId: Int, commentId: Int) {
		self.path = "/v1/shots/\(shotId)/comments/\(commentId)"
	}
}

