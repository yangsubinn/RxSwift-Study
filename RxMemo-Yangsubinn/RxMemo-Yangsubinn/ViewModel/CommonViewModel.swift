//
//  CommonViewModel.swift
//  RxMemo-Yangsubinn
//
//  Created by 양수빈 on 2021/10/05.
//

import Foundation
import RxSwift
import RxCocoa

class CommonViewModel: NSObject {
    /// 앱을 구성하는 모든 씬은 네비게이션 타이틀이 필요함 . 네비게이션컨트롤러에 imbeded되기 떄문?
    /// driver로 title을 바인딩해ㅈ겠다
    
    let title: Driver<String>
    let sceneCoordinator: SceneCoordinatorType /// protocol로 선언하면 나중에 의존성을 쉽게 수정 가능
    let storage: MemoStorageType
    
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
