//
//  TransitionModel.swift
//  RxMemo-Yangsubinn
//
//  Created by 양수빈 on 2021/10/05.
//

import Foundation

/// 전환방식의 열거형
enum TransitionStyle {
    case root
    case push
    case modal
}

/// 화면 전환시 문제가 발생했을 때 사용할 에러 형식
enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
