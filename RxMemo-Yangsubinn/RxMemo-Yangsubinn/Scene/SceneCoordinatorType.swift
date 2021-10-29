//
//  SceneCoordinatorType.swift
//  RxMemo-Yangsubinn
//
//  Created by 양수빈 on 2021/10/05.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    /// 새로운 씬 표시
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    
    @discardableResult
    func close(animated: Bool) -> Completable
    
    /// Completable 여기에 구독자를 추가하고 화면전환이 마무리된 후 원하는 작업을 할 수 있음 discardableResult를 써서 return하지 않아도 문제 안생김
}
