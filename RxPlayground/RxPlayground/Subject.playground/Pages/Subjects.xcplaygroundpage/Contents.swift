import RxSwift

//let subject = PublishSubject<String>()
//
//subject.onNext("zz")
//
//let subscriptioinOne = subject
//    .subscribe(onNext: { string in
//        print(string)
//    })
//
//subject.onNext("1")
//subject.onNext("2")
//
//let subscriptionTwo = subject
//    .subscribe({ event in
//        print("2)", event.element ?? event)
//    })
//subject.onNext("3")
//
//subscriptioinOne.dispose()
//subject.onNext("4")
//
//subject.onCompleted()
//subject.onNext("5")


// Variable
// ℹ️ [DEPRECATED] `Variable` is planned for future deprecation. Please consider `BehaviorRelay` as a replacement. Read more at: https://git.io/vNqvx
//let variable = Variable("initial value")
let disposeBag = DisposeBag()

//variable.value = "new one!"
//
//variable.asObservable()
//    .subscribe {
//        print("1)", $0)
//    }
//    .disposed(by: disposeBag)
