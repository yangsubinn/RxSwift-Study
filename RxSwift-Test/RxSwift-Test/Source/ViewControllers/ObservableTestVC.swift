//
//  ObservableTestVC.swift
//  RxSwift-Test
//
//  Created by μμλΉ on 2021/09/29.
//

import UIKit

import RxSwift
import RxCocoa

class ObservableTestVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let disposeBag = DisposeBag()
        
        Observable.just(4)
            .subscribe { event in print(event) }
            .disposed(by: disposeBag)
        // next(4)
        // completed
        print("-------------------")
        
        Observable.just([1,4,5])
            .subscribe { event in print(event) }
            .disposed(by: disposeBag)
        // next([1, 4, 5])
        // completed
        print("-------------------")
        
        Observable.of(1, 4, 5)
            .subscribe { event in print(event) }
            .disposed(by: disposeBag)
        // next(1)
        // next(4)
        // next(5)
        // completed
        print("-------------------")
        
        Observable.from([8, 9, 10])
            .subscribe { element in print(element) }
            .disposed(by: disposeBag)
        // next(8)
        // next(9)
        // next(10)
        // completed
        print("-------------------")
        
        Observable<String>.create { observer in
            observer.onNext("A")
            observer.onCompleted()
            
            return Disposables.create()
        }.subscribe(
            onNext: { print($0) },
            onError: { print($0) },
            onCompleted: { print("Completed") },
            onDisposed: { print("Disposed") }
        ).disposed(by: disposeBag)
        // A
        // Completed
        // Disposed
        print("-------------------")
        
        
        
        // subscribe Observable
        let observable1 = Observable.from([0,8,65,2])
        let subscribeObservable = observable1.subscribe{ event in
            print("Event \(event)") /// next(0)
            if let element = event.element { /// event = next(_) , event.element = _
                print("Element is \(element)") /// 0
            }
        }
        print("-------------------")
        
        
        // PublishSubject
        let subject = PublishSubject<String>()
        subject.onNext("ν λλ§?~?")
        
        let subscriptionOne = subject.subscribe (onNext: { string in
                print(string)
            })
        subject.on(.next("1"))
        subject.onNext("2")
        
        let subscriptionTwo = subject.subscribe({ event in
            print("2)", event.element ?? event)
        })

        subject.onNext("3")

        subscriptionOne.dispose() /// subscriptionOneμ΄λΌλ κ΅¬λμ μ’λ£

        subject.onNext("4")

        subject.onCompleted() /// λ
        subject.onNext("5") /// 5λ λ°μλμ§ μμ

        subscriptionTwo.dispose()

        subject.subscribe { /// μ΄λ―Έ μ’λ£λ subjectμ΄μ§λ§ completed νΈμΆλ¨
            print("3)", $0.element ?? $0)
        }
        .disposed(by: disposeBag)

        subject.onNext("?")
        
        
        // BehaviorSubject
        enum MyError: Error{
            case anError
        }
        
        let subject2 = BehaviorSubject(value: "μ΄κΈ°κ°μ΄λ€ μ΄λλ€μ") /// μ΄κΈ°κ°
        subject2.onNext("X")
        subject2.subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
        
        subject2.onError(MyError.anError)
        
        subject2.subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
        
        
        // ReplaySubject
        let subject3 = ReplaySubject<String>.create(bufferSize: 2)
        
        subject3.onNext("νλ")
        subject3.onNext("λ")
        subject3.onNext("μ")
                        
        subject3.subscribe {
                print("νλ) ", $0)
            }
            .disposed(by: disposeBag)
        
        subject3.subscribe {
            print("λ) ", $0)
        }
        .disposed(by: disposeBag)
        
        print("---------------------------------")
        
        // AsyncSubject
        let subject4 = AsyncSubject<String>()
        subject4.onNext("κ°μ")
        subject4.onNext("κ³ κ΅¬λ§")
        subject4.onNext("κΉκΏ")
        
        subject4.subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
        
        subject4.onCompleted()
        
        print("--------------relay---------")
        
        // Relay
        // publishRelay
        let publishRelay = PublishRelay<Int>()
        publishRelay.subscribe { print($0) }
        publishRelay.accept(5)
        
        let publishRelay2 = PublishRelay<String>()
        publishRelay2.subscribe { print($0) }
        publishRelay2.accept("μΆλ ₯μ΄ λλμ?")
        
        // behaviorRelay
        let behaviorRelay = BehaviorRelay(value: 5)
        print(behaviorRelay.value)
        behaviorRelay.accept(6)
        behaviorRelay.subscribe { print($0) }
        behaviorRelay.accept(10)
        print(behaviorRelay.value) // 10 (μ½κΈ° μ μ©)
    }
}
