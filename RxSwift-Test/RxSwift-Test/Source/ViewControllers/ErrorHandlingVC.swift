//
//  ErrorHandlingVC.swift
//  RxSwift-Test
//
//  Created by 양수빈 on 2021/11/29.
//

import UIKit

import RxSwift

class ErrorHandlingVC: UIViewController {
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

//        catchError()
//        catchErrorJustReturn()
//        retry()
//        retryLimit()
//        retryWhen()
        materialize()
    }
    

    func catchError() {
        let observable = Observable<String>
            .create { observer -> Disposable in
                observer.onNext("자료구조")
                observer.onNext("재미")
                observer.onNext("있다")
                observer.onError(NSError(domain: "에러", code: 100, userInfo: nil))
                observer.onError(NSError(domain: "틀렸지요", code: 200, userInfo: nil))
                observer.onNext("없다")
                return Disposables.create { }
        }

        observable
            .catch { .just(($0 as NSError).domain) }
            .subscribe { print($0) }
            .disposed(by: disposeBag)
    }
    
    func catchErrorJustReturn() {
        let observable = Observable<String>
            .create { observer -> Disposable in
                observer.onNext("데이터베이스")
                observer.onNext("재미없다")
                observer.onNext("어쩌지?")
                observer.onError(NSError(domain: "", code: 100, userInfo: nil))
                observer.onNext("그냥 다녀")
                return Disposables.create { }
        }

        observable
            .catchAndReturn("자퇴")
            .subscribe { print($0) }
            .disposed(by: disposeBag)
    }
    
    func retry() {
        let observable = Observable<String>
            .create { observer -> Disposable in
                observer.onNext("회전목마")
                observer.onNext("롤러코스터")
                observer.onNext("범퍼카")
                observer.onError(NSError(domain: "", code: 100, userInfo: nil))
                observer.onNext("집에 갈래")
                return Disposables.create { }
        }

        observable
            .retry()
            .subscribe { print($0) }
            .disposed(by: disposeBag)
    }

    func retryLimit() {
        let observable = Observable<String>
            .create { observer -> Disposable in
                observer.onNext("회전목마")
                observer.onNext("롤러코스터")
                observer.onNext("범퍼카")
                observer.onError(NSError(domain: "집에 못간다", code: 100, userInfo: nil))
                observer.onNext("집에 갈래")
                return Disposables.create { }
        }

        observable
            .retry(3)
            .subscribe { print($0) }
            .disposed(by: disposeBag)
    }
    
    func retryWhen() {
        let observable = Observable<String>
            .create { observer -> Disposable in
                observer.onNext("회전목마")
                observer.onNext("롤러코스터")
                observer.onNext("범퍼카")
                observer.onError(NSError(domain: "집에 못간다", code: 100, userInfo: nil))
                observer.onNext("집에 갈래")
                return Disposables.create { }
        }

        observable
            .retry { err -> Observable<Int> in
                return .timer(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
            }
            .subscribe { print($0) }
            .disposed(by: disposeBag)
    }
    
    func materialize() {
        let observable = Observable<Int>
            .create { observer -> Disposable in
                observer.onNext(1)
                observer.onNext(2)
                observer.onNext(3)
                observer.onError(NSError(domain: "", code: 100, userInfo: nil))
                observer.onError(NSError(domain: "", code: 200, userInfo: nil))
                return Disposables.create { }
        }

        observable
            .materialize()
            .map { event -> Event<Int> in
                switch event {
                case .error:
                    return .next(999)
                default:
                    return event
                }
            }
            .dematerialize()
            .subscribe { event in
                print(event)
            }
            .disposed(by: disposeBag)
    }
}
