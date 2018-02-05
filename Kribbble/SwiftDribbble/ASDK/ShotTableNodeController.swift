import AsyncDisplayKit

class ShotTableNodeController: ASViewController<ASTableNode> {

	let shot: Shot
	lazy var comments = [Comment]()
	var activityIndicator: UIActivityIndicatorView!
	
	init(shot: Shot) {
		self.shot = shot
		super.init(node: ASTableNode())
		self.navigationController?.title = "ASDK"
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupActivityIndicator()
		node.allowsSelection = true
		node.view.separatorStyle = .singleLine
		node.leadingScreensForBatching = 2.5
		node.dataSource = self
		node.delegate = self
    }
	
	func setupActivityIndicator() {
		let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		self.activityIndicator = activityIndicator
		let bounds = self.node.frame
		var refreshRect = activityIndicator.frame
		refreshRect.origin = CGPoint(x: (bounds.width - activityIndicator.frame.width) / 2.0, y: (bounds.height - activityIndicator.frame.height) / 2.0)
		activityIndicator.frame = refreshRect
		self.node.view.addSubview(activityIndicator)
	}
	
	func fetchNewBatchWithContext(_ context: ASBatchContext?) {
		DispatchQueue.main.async {
			self.activityIndicator.startAnimating()
		}
		
		Session.send(CommentsRequest(shotId: shot.id)) { [weak self] result in
			
			guard let strongSelf = self else { return }
			strongSelf.activityIndicator.stopAnimating()
			switch result {
			case .success(let comments):
				let startCount: Int = strongSelf.comments.count
				strongSelf.comments.append(contentsOf: comments)
				let endCount: Int = strongSelf.comments.count
				let indexRange = (startCount..<endCount)
				let indexPaths = indexRange.map({ IndexPath(item: $0, section: 1) })
				strongSelf.node.insertRows(at: indexPaths, with: .none)
				context?.completeBatchFetching(true)
				
			case .failure(let error):
				context?.completeBatchFetching(true)
				print(error)
			}
		}
	}
}

extension ShotTableNodeController: ASTableDelegate, ASTableDataSource {
	
	func numberOfSections(in tableNode: ASTableNode) -> Int {
		return 2
	}
	
	func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 1:
			return comments.count			
		default:
			return 1
		}
	}
	
	func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
		let section = indexPath.section
		let row = indexPath.row
		let nodeBlock: ASCellNodeBlock
		switch section {
		case 0:
			nodeBlock = {
				return ShotTableNodeCell(shot: self.shot)
			}
		default:
			let comment = comments[row]
			nodeBlock = {
				return CommentTableNodeCell(comment: comment)
			}
		}
		return nodeBlock
	}
	
	func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
		return comments.count < self.shot.commentsCount
	}

	func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
		fetchNewBatchWithContext(context)
	}
}
