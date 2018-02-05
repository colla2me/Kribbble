//
//  PagerNodeCell.swift
//  SwiftDribbble
//

import AsyncDisplayKit

class PagerNodeCell: ASCellNode {
	let pageTitle: String
	let viewModel: ShotViewModel
	let collectionNode: ASCollectionNode
	var activityIndicator: UIActivityIndicatorView!
	let viewControllerBlock: ASDisplayNodeViewControllerBlock
	
	init(title: String, viewControllerBlock: @escaping ASDisplayNodeViewControllerBlock) {
		self.pageTitle = title
		self.viewModel = ShotViewModel(
			listType: ShotParam.ListType(rawValue: title)!
		)
		self.viewControllerBlock = viewControllerBlock
		self.collectionNode = ASCollectionNode(collectionViewLayout: ShotsLayout())
		super.init()
		self.collectionNode.delegate = self
		self.collectionNode.dataSource = self
		let turningParameters = ASRangeTuningParameters(
			leadingBufferScreenfuls: 1.0,
			trailingBufferScreenfuls: 0.5
		)
		self.collectionNode.setTuningParameters(turningParameters, for: .display)
		
		self.addSubnode(collectionNode)
	}
	
	override func didLoad() {
		super.didLoad()
		collectionNode.backgroundColor = UIColor.primaryBackgroundColor
		setupActivityIndicator()
	}
	
	func setupActivityIndicator() {
		let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		self.activityIndicator = activityIndicator
		self.view.addSubview(activityIndicator)
	}
	
	func fetchNewBatchWithContext(_ context: ASBatchContext?) {
		DispatchQueue.main.async {
			self.activityIndicator.startAnimating()
		}
		
		viewModel.updateNewBatchOfShots() { additions in
			self.activityIndicator.stopAnimating()
			if additions > 0 {
				self.addItemsIntoCollectionNode(count: additions)
			}
			context?.completeBatchFetching(true)
		}
	}
	
	func addItemsIntoCollectionNode(count newShots: Int) {
		let indexRange = (viewModel.shots.count - newShots..<viewModel.shots.count)
		
		let indexPaths = indexRange.map { IndexPath(row: $0, section: 0) }
		collectionNode.insertItems(at: indexPaths)
	}
	
	override func layout() {
		super.layout()
		let bounds = self.bounds
		self.collectionNode.frame = bounds
		var refreshRect = activityIndicator.frame
		refreshRect.origin = CGPoint(x: (bounds.size.width - activityIndicator.frame.size.width) / 2.0, y: (bounds.size.height - activityIndicator.frame.size.height) / 2.0)
		activityIndicator.frame = refreshRect
	}
}

extension PagerNodeCell: ASCollectionDelegate, ASCollectionDataSource {
	
	func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
		return viewModel.numberOfShots
	}
	
	func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
		let shot = viewModel.shots[indexPath.item]
		return ShotCollectionNodeCell(shot: shot)
	}
	
	func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
		guard viewModel.numberOfShots > 0, indexPath.item < viewModel.numberOfShots else { return }
		let node = ShotTableNodeController(shot: viewModel.shots[indexPath.row])
		self.viewControllerBlock()
			.navigationController?
			.pushViewController(node, animated: true)
	}
	
	func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
		return true
	}
	
	func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
		fetchNewBatchWithContext(context)
	}
}
