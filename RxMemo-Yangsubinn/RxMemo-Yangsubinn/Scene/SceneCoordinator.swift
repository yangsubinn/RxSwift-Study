//
//  SceneCoordinator.swift
//  RxMemo-Yangsubinn
//
//  Created by 양수빈 on 2021/10/05.
//

import Foundation
import RxSwift
import RxCocoa

extension UIViewController {
    var sceneViewController: UIViewController {
        return self.children.first ?? self ///
    }
}

class SceneCoordinator: SceneCoordinatorType {
    private let bag = DisposeBag() /// resource 정리
    
    /// scenecoordinator은 화면전환을 담당해서 윈도우 인스턴스와 현재 화면에 표시되어있는 씬을 갖고 있어야 함
    private var window: UIWindow
    private var currentVC: UIViewController
    
    /// 위의 두 변수 초기화
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        
        /// 전환 결과를 방출할 subject 선언
        let subject = PublishSubject<Void>()
        
        let target = scene.instatiate()
        
        /// 전환방식에 따라 실제 전환 처리
        switch style {
        case .root:
            /// cuttentVC로 루트뷰컨을 바꿔줌
            currentVC = target.sceneViewController
            window.rootViewController = target
            subject.onCompleted()
        case .push:
            print(currentVC)
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            /// delegate 메소드가 호출되는 시점마다 next 이벤트를 방출하는 controlEvent
            /// 이 전과 같이 동일한 backButton 보여줌
            nav.rx.willShow
                .subscribe(onNext: { [unowned self] evt in
                    self.currentVC = evt.viewController.sceneViewController
                })
                .disposed(by: bag)
            
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
            
            subject.onCompleted()
            
        case .modal:
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            currentVC = target.sceneViewController
        }
        
        return subject.ignoreElements().asCompletable() /// ignoreElements 만 하면 에러발생
    }
    
    @discardableResult
    func close(animated: Bool) -> Completable {
        /// 뒤로가기 (메모보기) 했을 때 memoList 로 돌아옴!
        return Completable.create { [unowned self] completable in
            /// 뷰컨이 모달방식으로 표시되어있다면 현재 씬을 dismiss
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC.sceneViewController
                    completable(.completed)
                }
            } else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            } else {
                completable(.error(TransitionError.unknown))
            }
            
            return Disposables.create()
        }
    }
    
    
}
