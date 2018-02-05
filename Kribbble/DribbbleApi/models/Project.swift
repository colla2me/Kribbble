import Foundation

public struct Project: Codable {
	let id: Int
	let name: String
	let description: String
	let shotsCount: Int
	let created_at: Date
	
	private enum CodingKeys: String, CodingKey {
		case id, name, description, created_at
		case shotsCount = "shots_count"
	}
}

public struct UserProjectsRequest: Request {
	public typealias Response = [Project]
	public let path: String
	
	/// projects for authenticated user
	init() {
		self.path = "/v1/user/projects"
	}
	
	init(userId: Int) {
		self.path = "/v1/users/\(userId)/projects"
	}
}
