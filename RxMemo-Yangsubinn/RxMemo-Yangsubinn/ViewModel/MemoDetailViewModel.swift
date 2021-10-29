//
//  MemoDetailViewModel.swift
//  RxMemo-Yangsubinn
//
//  Created by 양수빈 on 2021/10/05.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoDetailViewModel: CommonViewModel {
    /// 메모 보기 화면에서 사용
    let memo: Memo /// 이전 씬에서 저장된 메모가 전달
    
    /// 날짜를 문자로 바꿀 때 사용
    private var formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "Ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()
    
    /// 메모를 편집한 후 다시 보기화면으로 왔을 때 편집한 내용이 반영되어야 함
    /// 새로운 문자열 배열을 방출해야 하기 때문에 behaviorsubject
    var contents: BehaviorSubject<[String]>
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.memo = memo
        
        contents = BehaviorSubject<[String]>(value: [
            memo.content,
            formatter.string(from: memo.insertDate)
        ])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: true).asObservable().map{ _ in }
    }
    
    /// composeviewmodel로 전달할 액션 리턴
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
//            return self.storage.update(memo: memo, content: input).map { _ in } /// observable이 방출하는 방식은 void
            self.storage.update(memo: memo, content: input)
                .subscribe(onNext: { updated in
                self.contents.onNext([
                    updated.content,
                    self.formatter.string(from: updated.insertDate)
                ])
            })
                .disposed(by: self.rx.disposeBag)
            
            return Observable.empty()
        }
    }
    
    /// 보기화면의 편집 버튼과 바인딩할 액션
    func makeEditAction() -> CocoaAction {
        return CocoaAction { _ in
            let composeViewModel = MemoComposeViewModel(title: "메모 편집", content: self.memo.content, sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: self.memo))
            
            let composeScene = Scene.compose(composeViewModel)
            
            return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true).asObservable().map { _ in }
        }
    }
    
    func makeDeleteAction() -> CocoaAction {
        return Action { input in
            self.storage.delete(memo: self.memo)
            return self.sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
    }
}
