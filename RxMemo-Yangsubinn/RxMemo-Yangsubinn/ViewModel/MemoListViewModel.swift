//
//  MemoListViewModel.swift
//  RxMemo-Yangsubinn
//
//  Created by 양수빈 on 2021/10/05.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import RxDataSources

typealias MemoSectionModel = AnimatableSectionModel<Int, Memo>

class MemoListViewModel: CommonViewModel {
    
    let dataSource: RxTableViewSectionedAnimatedDataSource<MemoSectionModel> = {
        let ds = RxTableViewSectionedAnimatedDataSource<MemoSectionModel>(configureCell: { (dataSource, tableView, indexPath, memo) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = memo.content
            return cell
        })
        
        ds.canEditRowAtIndexPath = {_, _ in return true}
        return ds
    }()
    /// 메모 리스트 화면에서 사용
    /// 의존성을 주입하는 생성자와 바인딩에 사용되는 속성과 메소드
    /// 화면전환과 메모 저장을 모두 처리 -> SceneCoordinator와  MemoStorage 활용 -> 뷰모델 생성 시점에 생성자를 통해 의존성을 주입해야 함
    
    /// 목록화면 상단에 플러스 버튼 있고, 클릭하면 모달방식으로 화면 전환하도록
    var memoList: Observable<[MemoSectionModel]> {
        return storage.memoList() /// 메모 배열을 그대로 리턴
    }
    
    /// 액션을 파라미터로 전달하는 메소드
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            return self.storage.update(memo: memo, content: input).map { _ in } /// observable이 방출하는 방식은 void
        }
    }
    
    /// cancel 액션을 리턴하는 메소드
    func performCancel(memo: Memo) -> CocoaAction {
        return Action {
            /// 생성된 메모를 삭제 <- creat에서 createMemo를 하면 실제 생성하고 방출되기 때문에 불필요한 메모가 이미 생겨버림
            return self.storage.delete(memo: memo).map {_ in}
        }
    }
    
    /// 새로운 메모 생성, 이 메모를 방출하는 observable 발생
    func makeCreateAction() -> CocoaAction {
        return CocoaAction { _ in
            return self.storage.createMemo(content: "")
            /// 클로저에서 화면전환 처리
                .flatMap { memo -> Observable<Void> in
                    let composeViewModel = MemoComposeViewModel(title: "새 메모", sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: memo), cancelAction: self.performCancel(memo: memo))
                    
                    /// composeScene을 생성하고 연관값으로 viewModel 저장
                    let composeScene = Scene.compose(composeViewModel)
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true).asObservable().map{_ in}
                    /// completable로 리턴하기 때문에 void형식으로 리턴할 수 있도록 asObservable 연산자를 통해 형변환
                }
        }
    }
    
    /// 메모리스트에서 보기로 넘어가는 화면전환 - 속성형태로 구현
    lazy var detailAction: Action<Memo, Void> = {
        return Action { memo in
            /// 뷰모델 생성, 씬 생성한 후 씬코디네이터에서 트랜지션 호출
            let detailViewModel = MemoDetailViewModel(memo: memo, title: "메모 보기", sceneCoordinator: self.sceneCoordinator, storage: self.storage)
            
            let detailScene = Scene.detail(detailViewModel)
            
            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true).asObservable().map { _ in }
        }
    }()
    
    lazy var deleteAction: Action<Memo, Swift.Never> = {
        return Action { memo in
            return self.storage.delete(memo: memo).ignoreElements()
        }
    }()
    
//    lazy var popAction = CocoaAction { [unowned self] in
//        return self.sceneCoordinator.close(animated: true).asObservable().map{ _ in }
//    }
}
