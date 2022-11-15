import RxSwift

let one = 1
let two = 2
let three = 3

let disposeBag = DisposeBag()
let observable: Observable<Int> = Observable<Int>.just(one)
let observable2 = Observable.of(one, two, three)
let observable3 = Observable.of([one, two, three])
let observable4 = Observable.from([one, two, three])

/// 1. .subscribe()
observable2.subscribe({ event in
//    print(event)
    if let element = event.element {
        print(element)
    }
})

/// 2. .subscribe(onNext:)
observable2.subscribe(onNext: { element in
    print(element)
})

/// 3. .empty()
/// - 즉시 종료할 수 있는 Observable을 리턴하고 싶을 때
/// - 의도적으로 0개의 값을 가지는 Observable을 리턴하고 싶을 때
let observableEmpty = Observable<Void>.empty()
observableEmpty.subscribe(
    onNext: { element in
        print(element)
    }, onCompleted: {
        print("Completed")
    }
)

/// 4. .never()
/// completed도 X
let observableNever = Observable<Any>.never()
//observableNever
//    .subscribe(onNext: { element in
//        print(element)
//    }, onCompleted: {
//        print("Completed")
//    })

print("📍")
/// completed도 안나오는 never Observable을
/// onSubscribe 핸들러를 이용하여 프린트 해보기
observableNever
    .debug("never ㅋㅋ") // observable의 모든 이벤트를 프린트
    .do(onSubscribe: {
    print("Subscribed")
}).subscribe(onNext: { element in
    print(element)
}, onCompleted: {
    print("Completed")
}).disposed(by: disposeBag)


/// 5. .range()
let range = Observable<Int>.range(start: 1, count: 10)
range.subscribe(onNext: { i in
    let n = Double(i)
    let fibonacci = Int(((pow(1.61803, n)  - pow(0.61803, n)) / 2.23606).rounded())
    print(fibonacci)
})


/// observable factory
var flip = false

let factory: Observable<Int> = Observable.deferred {
    flip = !flip
    
    if flip {
        return Observable.of(1,2,3)
    } else {
        return Observable.of(4,5,6)
    }
}

for _ in 0...3 {
    // factory의 구독을 4번 반복한 값 출력
    // factory를 구독할 때마다, 두개의 Observable이 번갈아가며 출력
    factory.subscribe(onNext: {
        print($0, terminator: "")
    }).disposed(by: disposeBag)
    print()
}

// MARK: - Traits
enum FileReadError: Error {
    case fileNotFound, unreadable, encodingFailed
}



