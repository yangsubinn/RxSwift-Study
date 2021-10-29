//
//  MemoComposeViewModel.swift
//  RxMemo-Yangsubinn
//
//  Created by 양수빈 on 2021/10/05.
//

import Foundation
import RxSwift
import RxCocoa
import Action

/// composeScene에서는 저장과 취소 두가지 액션이 가능

class MemoComposeViewModel: CommonViewModel {
    /// 표시할 메모를 저장하는 속성
    /// 새로운 메모를 추가할 때는 nil 저장, 메모를 편집할 떄는 편집할 메모 저장
    private let content: String?
    
    /// 뷰에 바인딩할 수 있도록
    var initialText: Driver<String?> {
        return Observable.just(content).asDriver(onErrorJustReturn: nil)
    }
    
    /// action을 저장하는 속성
    /// 나중에 버튼을 추가하고 아래의 두 액션과 바인딩
    let saveAction: Action<String, Void>
    let cancelAction: CocoaAction
    
    /// 생성자 구현
    init(title: String, content: String? = nil, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType, saveAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {
        self.content = content
        
        /// action으로 한 번 더 랩핑
        self.saveAction = Action<String, Void> { input in
            /// 액션이 전달되면 실행하고 화면 닫
            if let action = saveAction {
                action.execute(input)
            }
            
            /// 액션이 전달되지 않았다면 그냥 화면 닫고 끝
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
