import Foundation

public struct Bucket: Codable {
	let id: Int
	let name: String
	let description: String
	let shotsCount: Int
	let created_at: Date
	let user: User?

	private enum CodingKeys: String, CodingKey {
		case id, name, description, created_at, user
		case shotsCount = "shots_count"
	}
}

public struct UserBucketsRequest: Request {
	public typealias Response = [Bucket]
	public let path: String
	
	/// buckets for authenticated user
	init() {
		self.path = "/v1/user/buckets"
	}
	
	init(userId: Int) {
		self.path = "/v1/users/\(userId)/buckets"
	}
}

public struct BucketRequest: Request {
	public typealias Response = Bucket
	public let path: String
	
	init(_ bucketId: Int) {
		self.path = "/v1/buckets/\(bucketId)"
	}
}

public struct PostBucketRequest: Request {
	public typealias Response = Bucket
	public let method: HTTPMethod = .POST
	public let path: String
	public let query: [String : Any]
	
	init(name: String, description: String) {
		self.path = "/v1/buckets"
		self.query = ["name": name, "description": description]
	}
}

public struct ShotsInBucketRequest: Request {
	public typealias Response = [Shot]
	public let path: String
	
	init(_ bucketId: Int) {
		self.path = "/v1/buckets/\(bucketId)"
	}
}

public struct AddShotToBucketRequest: Request {
	public typealias Response = [Shot]
	public let method: HTTPMethod = .PUT
	public let path: String
	public let query: [String : Any]
	
	init(bucketId: Int, shotId: Int) {
		self.path = "/v1/buckets/\(bucketId)/shots"
		self.query = ["shot_id": shotId]
	}
}

public struct RemoveShotFromBucketRequest: Request {
	public typealias Response = [Shot]
	public let method: HTTPMethod = .DELETE
	public let path: String
	public let query: [String : Any]
	
	init(bucketId: Int, shotId: Int) {
		self.path = "/v1/buckets/\(bucketId)/shots"
		self.query = ["shot_id": shotId]
	}
}
