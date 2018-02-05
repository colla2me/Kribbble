import UIKit

enum InternetStatus {
	case connected
	case noConnection
}

final class ShotViewModel {
	public private(set) var shots: [Shot] = []
	private var ids: [Int] = []
	private var currentPage: Int = 0
	private var totalPages: Int = 10
	private var fetchPageInProgress: Bool = false
	private var refreshShotInProgress: Bool = false
	private let listType: ShotParam.ListType
	
	init(listType: ShotParam.ListType) {
		self.listType = listType
	}

	var numberOfShots: Int {
		return shots.count
	}
	
	func updateNewBatchOfShots(completion: @escaping (Int) -> ()) {
		
		guard !fetchPageInProgress else { return }
		
		fetchPageInProgress = true
		fetchNextPageOfShots(replaceData: false) { [unowned self] additions in
			self.fetchPageInProgress = false
			completion(additions)
		}
	}
	
	private func fetchNextPageOfShots(replaceData: Bool, completion: @escaping (Int) -> ()) {
		
		if currentPage == totalPages, currentPage != 0 {
			DispatchQueue.main.async {
				completion(0)
			}
			return
		}
		
		var newShots: [Shot] = []
		var newIDs: [Int] = []
		
		let pageToFetch = currentPage + 1
		let request = ShotsRequest(
			sortBy: ShotParam(list: listType),
			page: pageToFetch
		)
		
		Session.send(request) { (result) in
			switch result {
			case .success(let shots):
				self.currentPage = pageToFetch
				
				for shot in shots {
					if !replaceData || !self.ids.contains(shot.id) {
						newShots.append(shot)
						newIDs.append(shot.id)
					}
				}
				
				if replaceData {
					self.shots = newShots
					self.ids = newIDs
				} else {
					self.shots.append(contentsOf: newShots)
					self.ids.append(contentsOf: newIDs)
				}
				
				completion(newShots.count)
				
			case .failure(let fail):
				print(fail)
				completion(0)
			}
		}
	}
}
