import AsyncDisplayKit

var shotTagsCache = [Int: UIImage?]()

class ContainerNode: ASDisplayNode {
	
	// MARK: - Variables
	
	private let contentNode: ASDisplayNode
	
	// MARK: - Object life cycle
	
	init(node: ASDisplayNode) {
		contentNode = node
		super.init()
		self.backgroundColor = UIColor.containerBackgroundColor
		self.addSubnode(self.contentNode)
	}
	
	// MARK: - Node life cycle
	
	override func didLoad() {
		super.didLoad()
		self.layer.masksToBounds = true
		self.layer.cornerRadius = 5.0
		self.layer.borderColor = UIColor.containerBorderColor.cgColor
		self.layer.borderWidth = 1.0
	}
	
	// MARK: - Layout
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		return ASInsetLayoutSpec(insets: .zero, child: self.contentNode)
	}
	
}

class ShotCollectionNodeCell: ASCellNode {
	
	private let containerNode: ContainerNode
	
	init(shot: Shot) {
		self.containerNode = ContainerNode(node: ShotContentNode(shot: shot))
		super.init()
		self.selectionStyle = .none
		self.addSubnode(self.containerNode)
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		return ASInsetLayoutSpec(insets: .zero, child: self.containerNode)
	}
}

class ShotContentNode: ASDisplayNode {
	
	let shotImageNode: ASNetworkImageNode = {
		let imageNode = ASNetworkImageNode()
		imageNode.backgroundColor = UIColor.primaryBackgroundColor
		return imageNode
	}()
	
	let avatarImageNode: ASNetworkImageNode = {
		let imageNode = ASNetworkImageNode()
		imageNode.defaultImage = UIImage(named: "avatar-default_Normal")
		imageNode.contentMode = .scaleAspectFit
		imageNode.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
		return imageNode
	}()
	
	let titleNode = ASTextNode()
	let subtitleNode = ASTextNode()
	let tagsImageNode: ASImageNode = {
		let imageNode = ASImageNode()
		imageNode.contentMode = .scaleAspectFit
		return imageNode
	}()
	
	init(shot: Shot) {
		super.init()
		self.automaticallyManagesSubnodes = true
		self.shotImageNode.url = shot.images.normal
		self.avatarImageNode.url = shot.user.avatarUrl
		self.titleNode.attributedText = NSAttributedString(string: shot.title, attributes: [NSAttributedStringKey.font: UIFont.semiboldFont14, NSAttributedStringKey.foregroundColor: UIColor.darkBlue])
		if let bio = shot.user.bio {
			self.subtitleNode.attributedText = NSAttributedString(string: bio.trimmingCharacters(in: .whitespacesAndNewlines), attributes: [NSAttributedStringKey.font: UIFont.regularFont12, NSAttributedStringKey.foregroundColor: UIColor.darkGray])
		}

		if let image = shotTagsCache[shot.id] {
			self.tagsImageNode.image = image
		} else {
			if let tags: [String] = shot.tags {
				DispatchQueue.global().async {
					let image = self.renderImage(with: tags)
					shotTagsCache[shot.id] = image
					DispatchQueue.main.async {
						self.tagsImageNode.image = image
					}
				}
			}
		}
	}
	
	private func renderImage(with tags: [String]) -> UIImage {
		let maxWidth: CGFloat = (UIScreen.main.bounds.width - 30) * 0.5
		let marginTop: CGFloat = 3.0
		let marginLeft: CGFloat = 6.0
		let lineSpacing: CGFloat = 5.0
		let labelMargin: CGFloat = 5.0
		var tagLabels = [CGRect]()
		
		UIGraphicsBeginImageContextWithOptions(CGSize(width: maxWidth, height: 50), false, UIScreen.main.scale)
		
		for (index, tag) in tags.enumerated() {
			var tagName = tag
			if index == 5 { break }
			
			if index == 4 {
				if tags.count > 4 && tags.count != 5 {
					tagName = "More..."
				}
			}
			
			let textRect = CGRect(x: 0, y: 0, width: 0, height: 14)
			let textContent = NSString(string: tagName)
			let textStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
			textStyle.alignment = .center
			
			let textFontAttributes: [NSAttributedStringKey: AnyObject] = {
				if index == 4 && tags.count != 5 {
					return [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor(red: 157/255.0, green: 157/255.0, blue: 157/255.0, alpha: 1.0), NSAttributedStringKey.paragraphStyle: textStyle]
				} else {
					return [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.paragraphStyle: textStyle]
				}
			}()
			
			let textWidth: CGFloat = textContent.boundingRect(with: CGSize(width: 0, height: 0), options: .usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size.width
			
			var rect =  CGRect(x: 0, y: marginTop, width: textWidth, height: textRect.height)
			
			var lastLabel: CGRect = rect
			
			if index > 0 {
				lastLabel = tagLabels[index - 1]
			}
			
			var x = lastLabel.origin.x + lastLabel.width + labelMargin * 2
			
			var y = lastLabel.origin.y
			
			if x + rect.width + marginLeft*2 > maxWidth {
				x = 0
				y = lastLabel.origin.y + lastLabel.height + lineSpacing + marginTop*2
			}
			
			if index == 0 {
				x = 0
				y = lastLabel.origin.y
			}
			
			rect = CGRect(x: x + marginLeft, y: y , width: rect.width, height: rect.height)
			
			let rectanglePath = UIBezierPath(roundedRect: CGRect(x: rect.origin.x - marginLeft, y: rect.origin.y - marginTop , width: textWidth + marginLeft * 2, height: textRect.height + marginTop*2), cornerRadius: (textRect.height + marginTop*2)*0.5)
			
			let fillColor: UIColor = {
				if index == 4 && tags.count != 5 {
					return UIColor(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 1.0)
				} else {
					return UIColor(red: 53/255.0, green: 53/255.0, blue: 53/255.0, alpha: 1.0)
				}
			}()
			
			fillColor.setFill()
			rectanglePath.fill()
			tagLabels.append(rect)
			textContent.draw(in: rect, withAttributes: textFontAttributes)
		}
		
		let tagImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return tagImage!
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		
		let shotRatioSpec = ASRatioLayoutSpec(ratio: 0.75, child: shotImageNode)
		avatarImageNode.style.preferredSize = CGSize(width: 18, height: 18)
		tagsImageNode.style.height = ASDimensionMake(50)
		titleNode.style.flexShrink = 1
		titleNode.maximumNumberOfLines = 1
		titleNode.truncationMode = .byTruncatingTail
		subtitleNode.maximumNumberOfLines = 1
		subtitleNode.truncationMode = .byTruncatingTail
		
		let spacer = ASLayoutSpec()
		spacer.style.flexGrow = 1
		
		let midSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .start, alignItems: .center, children: [titleNode, spacer, avatarImageNode])
		
		let footerSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .stretch, children: [midSpec, subtitleNode, tagsImageNode])
		
		let insetsSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 8, 10), child: footerSpec)
		
		let finalSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .stretch, children: [shotRatioSpec, insetsSpec])
		
		return finalSpec
	}
	
}
