import Foundation
import UIKit

public struct ShotParam {
	let list: ListType
	let timeframe: TimeFrame
	let sort: SortType
	let date: String?
	
	init(list: ListType = .any,
		 timeframe: TimeFrame = .now,
		 sort: SortType = .popularity,
		 date: String? = nil) {
		self.list = list
		self.timeframe = timeframe
		self.sort = sort
		self.date = date
	}
	
	enum ListType: String {
		case any = "any"
		case animated = "animated"
		case attachments = "attachments"
		case debuts = "debuts"
		case playoffs = "playoffs"
		case rebounds = "rebounds"
		case teams = "teams"
	}
	
	enum TimeFrame: String {
		case now = "now"
		case week = "week"
		case year = "year"
		case ever = "ever"
	}
	
	enum SortType: String {
		case popularity = "popularity"
		case comments = "comments"
		case recent = "recent"
		case views = "views"
	}
}

public struct UploadShotParam {
	let title: String
	let file: URL
	let description: String?
	let tags: [String]?
	let teamId: Int?
	let reboundSourceId: Int?
	let lowProfile: Bool?
	
	init(title: String,
		 file: URL,
		 description: String? = nil,
		 tags: [String]? = nil,
		 teamId: Int? = nil,
		 reboundSourceId: Int? = nil,
		 lowProfile: Bool? = nil) {
		
		self.title = title
		self.file = file
		self.description = description
		self.tags = tags
		self.teamId = teamId
		self.reboundSourceId = reboundSourceId
		self.lowProfile = lowProfile
	}
}

public struct Shot: Codable {
	let id: Int
	let title: String
	let description: String?
	let width: Int
	let height: Int
	let images: Shot.ImageType
	let viewsCount: Int
	let likesCount: Int
	let commentsCount: Int
	let attachmentsCount: Int
	let reboundsCount: Int
	let bucketsCount: Int
	let animated: Bool
	let tags: [String]?
	let user: User
	let team: Team?
	
	public struct ImageType: Codable {
		let hidpi: URL?
		let normal: URL
		let teaser: URL
	}
	
	private enum CodingKeys: String, CodingKey {
		case id, title, width, height, images, description, animated, tags, user, team
		case viewsCount = "views_count"
		case likesCount = "likes_count"
		case commentsCount = "comments_count"
		case attachmentsCount = "attachments_count"
		case reboundsCount = "rebounds_count"
		case bucketsCount = "buckets_count"
//		case description = "description_text"
	}
}

/// MARK: Request

public struct UserShotsRequest: Request {
	public typealias Response = [Shot]
	public let path: String
	
	/// shots for authenticated user
	init() {
		self.path = "/v1/user/shots"
	}
	
	init(userId: Int) {
		self.path = "/v1/users/\(userId)/shots"
	}
}

public struct ShotsRequest: Request {	
	public typealias Response = [Shot]
	public var query: [String : Any] = [:]
	public let path: String = "/v1/shots"
//	public var header: [String : String]? {
//		return ["Accept": "application/vnd.dribbble.v1.text+json"]
//	}
	
	init(sortBy param: ShotParam? = nil, page: Int?) {

		if let param = param {
			self.query["list"] = param.list
			self.query["timeframe"] = param.timeframe
			self.query["sort"] = param.sort
			self.query["date"] = param.date
		}
		
		self.query["page"] = page

		print("ShotsParam: \(self.query)")
	}
}

public struct SingleShotRequest: Request {
	public typealias Response = Shot
	public let path: String
	
	init(shotId: Int) {
		self.path = "/v1/shots/\(shotId)"
	}
}

public struct UserFollowedShotsRequest: Request {
	public typealias Response = [Shot]
	public let path: String
	
	/// shots for authenticated user
	init() {
		self.path = "/v1/user/following/shots"
	}
}

public struct PostShotRequest: Request {
	public typealias Response = Shot
	public var query: [String : Any] = [:]
	public let file: (name: String, url: URL)?
	public var path: String {
		return "/v1/shots"
	}
	
	init(uploading draft: UploadShotParam) {
		self.file = (name: "image", url: draft.file)
		self.query["title"] = draft.title
		if let desc = draft.description {
			self.query["title"] = desc
		}
		if let tags = draft.tags {
			self.query["tags"] = tags
		}
		if let teamId = draft.teamId {
			self.query["team_id"] = teamId
		}
		if let reboundSourceId = draft.reboundSourceId {
			self.query["rebound_source_id"] = reboundSourceId
		}
		if let lowProfile = draft.lowProfile {
			self.query["low_profile"] = lowProfile
		}
	}
}

