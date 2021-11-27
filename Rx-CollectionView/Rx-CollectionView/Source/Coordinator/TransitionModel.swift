//
//  TransitionModel.swift
//  Rx-CollectionView
//
//  Created by 양수빈 on 2021/11/25.
//

import Foundation

enum TransitionStyle {
    case push
    case modal
}

enum TransitionError: Error {
    case cannotPop
    case unknown
}
