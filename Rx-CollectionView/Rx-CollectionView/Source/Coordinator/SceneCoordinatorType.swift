//
//  SceneCoordinatorType.swift
//  Rx-CollectionView
//
//  Created by 양수빈 on 2021/11/25.
//

import RxSwift

protocol SceneCoordinatorType {
    /// 새로운 Scene를 표시
    @discardableResult
    func transition(to scene: SceneRegisterable, from storyboard: String, using style: TransitionStyle, animated: Bool) -> Completable
    
    /// 현재 씬 닫기
    @discardableResult
    func close(animated: Bool) -> Completable
}
