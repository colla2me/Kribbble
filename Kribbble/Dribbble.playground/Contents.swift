//: Playground - noun: a place where people can play

import UIKit
import Foundation

Array(1..<3)

class UserCell: UICollectionViewCell {
}

UserCell
	.description()
	.components(separatedBy: ".")
	.dropFirst()
	.joined(separator: "")

//func generateState(with len: Int) -> String {
//	let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//	let length = UInt32(letters.count)
//
//	var randomString = ""
//	for _ in 0..<len {
//		let rand = arc4random_uniform(length)
//		let idx = letters.index(letters.startIndex, offsetBy: Int(rand))
//		let letter = letters[idx]
//		randomString += String(letter)
//	}
//	return randomString
//}
//
//generateState(with: 16)
