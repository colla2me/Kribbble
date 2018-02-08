import AsyncDisplayKit

class CommentTableNodeCell: ASCellNode {

	let avatarImageNode: YYWebImageNode = {
		let imageNode = YYWebImageNode()
		imageNode.defaultImage = UIImage(named: "avatar-default_Normal")
		imageNode.contentMode = .scaleAspectFit
		imageNode.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
		return imageNode
	}()
	
	let usernameLabel = ASTextNode()
	let bodyLabel = ASTextNode()
	let timeLabel = ASTextNode()
	let likeLabel = ASTextNode()
	let likeImageNode: ASImageNode = {
		let imageNode = ASImageNode()
		imageNode.image = UIImage(named: "comment-likes_Normal")
		return imageNode
	}()
	let likeButton: ASButtonNode = {
		let buttonNode = ASButtonNode()
		buttonNode.setTitle("Like?", with: UIFont.regularFont14, with: UIColor.lightGray, for: .normal)
		return buttonNode
	}()
	
	init(comment: Comment) {
		super.init()
		self.selectionStyle = .none
		self.automaticallyManagesSubnodes = true
		self.avatarImageNode.url = comment.user.avatarUrl
		self.bodyLabel.delegate = self
		self.bodyLabel.isUserInteractionEnabled = true
		
		self.usernameLabel.attributedText = NSAttributedString(string: comment.user.name, attributes: [NSAttributedStringKey.font: UIFont.semiboldFont16, NSAttributedStringKey.foregroundColor: UIColor.darkGray])
		
		self.bodyLabel.attributedText = comment
			.body
			.trimmingCharacters(in: .whitespacesAndNewlines)
			.toHTMLDocument(color: UIColor.commentGray, font: UIFont.mediumFont16)
		
		self.timeLabel.attributedText = NSAttributedString(string: "21 mins ago", attributes: [NSAttributedStringKey.font: UIFont.regularFont14, NSAttributedStringKey.foregroundColor: UIColor.lightGray])
		
		self.likeLabel.attributedText = NSAttributedString(string: String(comment.likesCount), attributes: [NSAttributedStringKey.font: UIFont.regularFont13, NSAttributedStringKey.foregroundColor: UIColor.lightGray])
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		avatarImageNode.style.preferredSize = CGSize(width: 42, height: 42)
		
		let likeSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 5, justifyContent: .start, alignItems: .center, children: [likeImageNode, likeLabel])
		
		let timeSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 5, justifyContent: .start, alignItems: .center, children: [timeLabel, likeButton])
		
		let footerSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .center, children: [timeSpec, likeSpec])
	
		let contentSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .stretch, children: [usernameLabel, bodyLabel])
		contentSpec.style.flexShrink = 1
		
		let mainSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .start, children: [avatarImageNode, contentSpec])
		
		timeSpec.style.spacingBefore = 52
		let finalSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .stretch, children: [mainSpec, footerSpec])
		
		return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 10), child: finalSpec)
	}
}

extension CommentTableNodeCell: ASTextNodeDelegate {
	
	func textNode(_ textNode: ASTextNode, shouldHighlightLinkAttribute attribute: String, value: Any, at point: CGPoint) -> Bool {
		return true
	}
	
	func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
		
		print("tappedLinkAttribute: \(attribute)")
		print("value: \(value)")
		print("point: \(point)")
		print("textRange: \(textRange)")
	}
}
