//
//  AvoidDuplicationVC.swift
//  RxSwift-Test
//
//  Created by 양수빈 on 2022/04/17.
//

import UIKit

import RxSwift
import RxCocoa

class AvoidDuplicationVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var throttleButton: UIButton!
    @IBOutlet weak var debounceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        testThrottle()
        testDebounce()
    }
    
    /// 3초 동안 여러번 버튼을 눌러도 딱 한 번만 next 이벤트 발생하도록
    private func testThrottle() {
        throttleButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print("🧱🧱🧱🧱🧱")
            })
            .disposed(by: disposeBag)
    }
    
    /// 이벤트 발생 3초 후 next 이벤트 실행
    private func testDebounce() {
        debounceButton.rx.tap
            .debounce(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print("디바운스바운스 두군대 들킬가바 겁나")
            })
            .disposed(by: disposeBag)
    }
}
