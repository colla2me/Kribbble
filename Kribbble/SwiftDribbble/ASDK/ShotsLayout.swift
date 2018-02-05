import UIKit

class ShotsLayout: UICollectionViewFlowLayout {

	let numberOfColumns: CGFloat = 2
	
	// MARK: - Object life cycle
	
	override init() {
		super.init()
		self.setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupLayout()
	}
	
	// MARK: - Layout
	
	private func setupLayout() {
		self.minimumInteritemSpacing = 10
		self.minimumLineSpacing = 10
		self.scrollDirection = .vertical
		self.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
	}
	
	func itemWidth() -> CGFloat {
		let spacing = self.minimumInteritemSpacing + self.sectionInset.left * 2
		return ((collectionView!.frame.width - spacing) / numberOfColumns)
	}
	
	func itemHeight() -> CGFloat {
		return itemWidth() * 0.75 + 110
	}
	
	override var itemSize: CGSize {
		set {
			self.itemSize = CGSize(width: itemWidth(), height: itemHeight())
		}
		get {
			return CGSize(width: itemWidth(), height: itemHeight())
		}
	}
	
	override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
		return self.collectionView!.contentOffset
	}
}
