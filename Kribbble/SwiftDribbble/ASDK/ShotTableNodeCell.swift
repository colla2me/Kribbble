import Foundation
import AsyncDisplayKit

class ShotTableNodeCell: ASCellNode {
	let avatarImageNode: ASNetworkImageNode = {
		let imageNode = ASNetworkImageNode()
		imageNode.defaultImage = UIImage(named: "avatar-default_Normal")
		imageNode.contentMode = .scaleAspectFit
		imageNode.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
		return imageNode
	}()
	
	let titleLabel = ASTextNode()
	let byLabel = ASTextNode()
	let usernameLabel = ASTextNode()
	let dateLabel = ASTextNode()
	let descriptionLabel = ASTextNode()
	
	let likeButton: ASButtonNode = {
		let buttonNode = ASButtonNode()
		buttonNode.setImage(UIImage(named: "icon-like-_Normal"), for: .normal)
		return buttonNode
	}()
	
	let viewButton: ASButtonNode = {
		let buttonNode = ASButtonNode()
		buttonNode.setImage(UIImage(named: "icon-views-_Normal"), for: .normal)
		return buttonNode
	}()
	
	let commentButton: ASButtonNode = {
		let buttonNode = ASButtonNode()
		buttonNode.setImage(UIImage(named: "icon-comments-_Normal"), for: .normal)
		return buttonNode
	}()
	
	let photoImageNode: ASNetworkImageNode = {
		let imageNode = ASNetworkImageNode()
		imageNode.defaultImage = UIImage(named: "photo")
		return imageNode
	}()
	
	
	init(shot: Shot) {
		super.init()
		self.selectionStyle = .none
		self.automaticallyManagesSubnodes = true

		self.titleLabel.attributedText = NSAttributedString(string: shot.title, attributes: [NSAttributedStringKey.font: UIFont.boldFont15, NSAttributedStringKey.foregroundColor: UIColor.darkGray])
		
		self.byLabel.attributedText = NSAttributedString(string: "by", attributes: [NSAttributedStringKey.font: UIFont.mediumFont13, NSAttributedStringKey.foregroundColor: UIColor.lightGray])
		
		self.usernameLabel.attributedText = NSAttributedString(string: shot.user.name, attributes: [NSAttributedStringKey.font: UIFont.semiboldFont14, NSAttributedStringKey.foregroundColor: UIColor.darkBlue])
		
		self.dateLabel.attributedText = NSAttributedString(string: "on Jan 28,2018", attributes: [NSAttributedStringKey.font: UIFont.semiboldFont13, NSAttributedStringKey.foregroundColor: UIColor.lightGray])
		
		let attributes = [NSAttributedStringKey.font: UIFont.lightFont16, NSAttributedStringKey.foregroundColor: UIColor.darkGray]
		self.likeButton.setAttributedTitle(NSAttributedString(string: String(shot.likesCount), attributes: attributes), for: .normal)
		self.viewButton.setAttributedTitle(NSAttributedString(string: String(shot.viewsCount), attributes: attributes), for: .normal)
		self.commentButton.setAttributedTitle(NSAttributedString(string: String(shot.commentsCount), attributes: attributes), for: .normal)
		
		self.avatarImageNode.url = shot.user.avatarUrl
		self.photoImageNode.url = shot.images.normal
		if let text = shot.description {
			self.descriptionLabel.delegate = self
			self.descriptionLabel.isUserInteractionEnabled = true
			self.descriptionLabel.attributedText = text
				.trimmingCharacters(in: .whitespacesAndNewlines)
				.toHTMLDocument(color: UIColor.textGray, font: UIFont.mediumFont14)
		}
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		
		let headerInset = UIEdgeInsetsMake(10, 10, 10, 10)
		let descInset = UIEdgeInsetsMake(8, 10, 8, 10)
		avatarImageNode.style.preferredSize = CGSize(width: 40, height: 40)
		titleLabel.maximumNumberOfLines = 1
		titleLabel.truncationMode = .byTruncatingTail
		
		let usernameStack = ASStackLayoutSpec(direction: .horizontal, spacing: 5, justifyContent: .start, alignItems: .center, children: [byLabel, usernameLabel, dateLabel])
		
		let userInfoStack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .stretch, children: [titleLabel, usernameStack])
		userInfoStack.style.flexShrink = 1
		
		let headerStack = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .center, children: [avatarImageNode, userInfoStack])
		
		let interactiveStack = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .center, children: [likeButton, viewButton, commentButton])
		
		let verticalStack = ASStackLayoutSpec.vertical()
		verticalStack.children = [
			ASInsetLayoutSpec(insets: headerInset, child: headerStack),
			ASRatioLayoutSpec(ratio: 0.75, child: photoImageNode),
			ASInsetLayoutSpec(insets: headerInset, child: interactiveStack),
			ASInsetLayoutSpec(insets: descInset, child: descriptionLabel)
		]
		
		return verticalStack
	}
}

extension ShotTableNodeCell: ASTextNodeDelegate {
	
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

