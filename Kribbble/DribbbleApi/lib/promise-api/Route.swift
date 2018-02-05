import Foundation

public enum Route {
	case shots
	case shot(shotId: Int)
	case shotLikes(shotId: Int)
	case shotBuckets(shotId: Int)
	case shotComments(shotId: Int)
	case shotAttachments(shotId: Int)
	case shotRebounds(shotId: Int)
	case shotProjects(shotId: Int)
	case shotCommentLikes(shotId: Int, commentId: Int)
	case teamMembers(teamId: Int)
	case teamShots(teamId: Int)
	case userProjects(userId: Int)
	case userBuckets(userId: Int)
	case userLikes(userId: Int)
	case userShots(userId: Int)
	case userTeams(userId: Int)
	case userFollowers(userId: Int)
	case userFollowings(userId: Int)
	case userFollowedShots
	case users(userId: Int)
	case user

	case updateShot(shotId: Int)
	case deleteShot(shotId: Int)
	case likeShot(shotId: Int)
	case unlikeShot(shotId: Int)
	case followUser(userId: Int)
	case unfollowUser(userId: Int)
	case postComment(shotId: Int, body: String)
	case updateComment(commentId: Int, shotId: Int)
	case deleteComment(commentId: Int, shotId: Int)
	case likeComment(commentId: Int, shotId: Int)
	case unlikeComment(commentId: Int, shotId: Int)
	
	public enum UploadParam: String {
		case image
	}
	
	/// TODO: Route combine with Primose will be work
	public var requestProperties: (method: HTTPMethod, path: String, query: [String: Any], file: (name: UploadParam, url: URL)?) {
		switch self {
		case .shots:
			return (.GET, "/v1/shots", [:], nil)
		case let .shot(shotId):
			return (.GET, "/v1/shots/\(shotId)", [:], nil)
		case let .shotLikes(shotId):
			return (.GET, "/v1/shots/\(shotId)/likes", [:], nil)
		case let .shotBuckets(shotId):
			return (.GET, "/v1/shots/\(shotId)/buckets", [:], nil)
		case let .shotComments(shotId):
			return (.GET, "/v1/shots/\(shotId)/comments", [:], nil)
		case let .shotCommentLikes(shotId, commentId):
			return (.GET, "/v1/shots/\(shotId)/comments/\(commentId)/likes", [:], nil)
		case let .shotAttachments(shotId):
			return (.GET, "/v1/shots/\(shotId)/attachments", [:], nil)
		case let .shotRebounds(shotId):
			return (.GET, "/v1/shots/\(shotId)/rebounds", [:], nil)
		case let .shotProjects(shotId):
			return (.GET, "/v1/shots/\(shotId)/projects", [:], nil)
		case let .teamMembers(teamId):
			return (.GET, "/v1/teams/\(teamId)/members", [:], nil)
		case let .teamShots(teamId):
			return (.GET, "/v1/teams/\(teamId)/shots", [:], nil)
		case let .userProjects(userId):
			return (.GET, "/v1/users/\(userId)/projects", [:], nil)
		case let .userBuckets(userId):
			return (.GET, "/v1/users/\(userId)/buckets", [:], nil)
		case let .userLikes(userId):
			return (.GET, "/v1/users/\(userId)/likes", [:], nil)
		case let .userShots(userId):
			return (.GET, "/v1/users/\(userId)/shots", [:], nil)
		case let .userTeams(userId):
			return (.GET, "/v1/users/\(userId)/teams", [:], nil)
		case let .userFollowers(userId):
			return (.GET, "/v1/users/\(userId)/followers", [:], nil)
		case let .userFollowings(userId):
			return (.GET, "/v1/users/\(userId)/following", [:], nil)
		case .userFollowedShots:
			return (.GET, "/v1/user/following/shots", [:], nil)
		case let .users(userId):
			return (.GET, "/v1/users/\(userId)", [:], nil)
		case .user:
			return (.GET, "/v1/user", [:], nil)

		case let .updateShot(shotId):
			return (.PUT, "/v1/shots/\(shotId)", [:], nil)
		case let .deleteShot(shotId):
			return (.DELETE, "/v1/shots/\(shotId)", [:], nil)
		case let .followUser(userId):
			return (.PUT, "/v1/users/\(userId)/follow", [:], nil)
		case let .unfollowUser(userId):
			return (.DELETE, "/v1/users/\(userId)/follow", [:], nil)
		case let .likeShot(shotId):
			return (.POST, "/v1/shots/\(shotId)/like", [:], nil)
		case let .unlikeShot(shotId):
			return (.DELETE, "/v1/shots/\(shotId)/like", [:], nil)
		case let .postComment(shotId, body):
			let param: [String: Any] = ["body": body]
			return (.POST, "/v1/shots/\(shotId)/comments", param, nil)
		case let .updateComment(commentId, shotId):
			return (.PUT, "/v1/shots/\(shotId)/comments/\(commentId)", [:], nil)
		case let .deleteComment(commentId, shotId):
			return (.DELETE, "/v1/shots/\(shotId)/comments/\(commentId)", [:], nil)
		case let .likeComment(commentId, shotId):
			return (.POST, "/v1/shots/\(shotId)/comments/\(commentId)/like", [:], nil)
		case let .unlikeComment(commentId, shotId):
			return (.DELETE, "/v1/shots/\(shotId)/comments/\(commentId)/like", [:], nil)
		}
	}
}
