//
//  DribbbleCollectionView.swift
//  SwiftDribbble
//
//  Created by Samuel on 2017/10/22.
//  Copyright © 2017年 Samuel. All rights reserved.
//

import UIKit

final class DribbbleCollectionView: UICollectionView {

	override var contentInset: UIEdgeInsets {
		didSet {
			if isTracking {
				let diff = contentInset.top - oldValue.top
				var translation = panGestureRecognizer.translation(in: self)
				translation.y -= diff * 3 / 2
				panGestureRecognizer.setTranslation(translation, in: self)
			}
		}
	}

}
