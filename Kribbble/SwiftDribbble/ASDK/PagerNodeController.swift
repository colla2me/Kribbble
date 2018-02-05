//
//  PagerNodeController.swift
//  SwiftDribbble
//

import AsyncDisplayKit

class PagerNodeController: UIViewController {
	var pageMenu: SPPageMenu!
	let pagerNode: ASPagerNode
	let menuItems: [String] = {
		return ["any", "animated", "attachments", "debuts", "playoffs", "rebounds", "teams"]
	}()
	let menuHeight: CGFloat = 40
	
	init() {
		self.pagerNode = ASPagerNode()
		super.init(nibName: nil, bundle: nil)
		self.automaticallyAdjustsScrollViewInsets = false
		pagerNode.backgroundColor = UIColor.primaryBackgroundColor
		pagerNode.setDelegate(self)
		pagerNode.setDataSource(self)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupLogo()
		setupPageMenu()
		self.view.addSubnode(pagerNode)
		self.view.bringSubview(toFront: pageMenu)
    }
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		let top = insetTop + menuHeight
		let bounds = view.bounds
		self.pagerNode.frame = CGRect(x: 0, y: top, width: bounds.width, height: bounds.height - top)
	}
	
	func setupPageMenu() {
		let width = UIScreen.main.bounds.width
		let pageMenu = SPPageMenu(
			frame: CGRect(x: 0, y: insetTop, width: width, height: menuHeight),
			trackerStyle: .lineAttachment
		)
		self.pageMenu = pageMenu
		pageMenu.delegate = self
		pageMenu.bridgeScrollView = self.pagerNode.view
		pageMenu.itemTitleFont = UIFont.mediumFont16
		pageMenu.unSelectedItemTitleColor = UIColor.darkBlue
		pageMenu.setItems(menuItems, selectedItemIndex: 0)
		self.view.addSubview(pageMenu)
	}
	
	func setupLogo() {
		self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo-dribbble-_Normal"))
	}
}

extension PagerNodeController: ASPagerDelegate, ASPagerDataSource {
	func pagerNode(_ pagerNode: ASPagerNode, nodeAt index: Int) -> ASCellNode {
		let title = menuItems[index]
		let node = PagerNodeCell(title: title) { self }
		return node
	}
	
	func numberOfPages(in pagerNode: ASPagerNode) -> Int {
		return menuItems.count
	}
}

extension PagerNodeController: SPPageMenuDelegate {
	func pageMenu(_ pageMenu: SPPageMenu, itemSelectedAt index: Int) {
		self.pagerNode.scrollToPage(at: index, animated: true)
	}
}
