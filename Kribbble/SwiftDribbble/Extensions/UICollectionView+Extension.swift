import UIKit

extension UICollectionView {
	enum ReloadWay {
		case none
		case reloadData
		case insertItems([IndexPath])
		
		func performUpdate(with collectionView: UICollectionView) {
			switch self {
			case .none:
				break
			case .reloadData:
				collectionView.reloadData()
			case .insertItems(let indexPaths):
				collectionView.insertItems(at: indexPaths)
			}
		}
	}
}

extension UICollectionView {
	func reuseIdentifier<Cell: UICollectionViewCell>(_ cell: Cell.Type) -> String {
		return cell
				.description()
				.components(separatedBy: ".")
				.dropFirst()
				.joined(separator: "")
	}
	
	func registerClassOf<Cell: UICollectionViewCell>(cell: Cell.Type) {
		let identifier = reuseIdentifier(cell)
		register(cell, forCellWithReuseIdentifier: identifier)
	}
	
	func registerNibOf<Cell: UICollectionViewCell>(cell: Cell.Type) {
		let nibName: String = reuseIdentifier(cell)
		let nib = UINib(nibName: nibName, bundle: nil)
		register(nib, forCellWithReuseIdentifier: nibName)
	}
	
	func dequeueReusableCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
		let identifier = reuseIdentifier(Cell.self)
		guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
			fatalError("Could not dequeue cell with identifier: \(identifier)")
		}
		return cell
	}
}
