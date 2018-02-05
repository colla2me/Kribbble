import AsyncDisplayKit

class ShotCollectionNodeController: ASViewController<ASCollectionNode> {

	var activityIndicator: UIActivityIndicatorView!
	let viewModel: ShotViewModel = ShotViewModel(listType: ShotParam.ListType(rawValue: "any")!)
	
	private var collectionNode: ASCollectionNode {
		return node
	}
	
	init() {
		super.init(node: ASCollectionNode(collectionViewLayout: ShotsLayout()))
		collectionNode.delegate = self
		collectionNode.dataSource = self
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		title = "Shots"
		collectionNode.backgroundColor = UIColor.primaryBackgroundColor
		setupActivityIndicator()
    }
	
	func setupActivityIndicator() {
		let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		self.activityIndicator = activityIndicator
		let bounds = self.node.frame
		var refreshRect = activityIndicator.frame
		refreshRect.origin = CGPoint(x: (bounds.size.width - activityIndicator.frame.size.width) / 2.0, y: (bounds.size.height - activityIndicator.frame.size.height) / 2.0)
		activityIndicator.frame = refreshRect
		self.node.view.addSubview(activityIndicator)
	}
	
	var screenSizeForWidth: CGSize = {
		let screenRect = UIScreen.main.bounds
		let screenScale = UIScreen.main.scale
		return CGSize(width: screenRect.size.width * screenScale, height: screenRect.size.width * screenScale)
	}()
	
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
}

extension ShotCollectionNodeController: ASCollectionDelegate, ASCollectionDataSource {
	
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
		self.navigationController?.pushViewController(node, animated: true)
	}
	
	func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
		return true
	}
	
	func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
		fetchNewBatchWithContext(context)
	}
}









