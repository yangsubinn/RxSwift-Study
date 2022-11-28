//: [Previous](@previous)

import RxSwift

let strikes = PublishSubject<String>()
let disposeBag = DisposeBag()

// MARK: - ignoreElements
//strikes
//    .ignoreElements()
//    .subscribe { _ in
//        print("out ~~~~~~~~~")
//    }
//    .disposed(by: disposeBag)
//
//strikes.onNext("X")
//strikes.onNext("X")
//strikes.onNext("X")
//
//strikes.onCompleted()

// MARK: - elementAt
//strikes
//    .elementAt(2)
//    .subscribe(onNext: { s in
//        print(s)
//    })
//    .disposed(by: disposeBag)
//
//strikes.onNext("0번째")
//strikes.onNext("첫번째")
//strikes.onNext("두번째")

// MARK: - filter
//strikes
//    .filter({ $0 != "첫번째" })
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)
//
//strikes.onNext("0번째")
//strikes.onNext("첫번째")
//strikes.onNext("두번째")

//Observable.of(1,2,3,4,5,6,7,8,9)
//    .filter({ $0 % 2 == 0 })
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

// MARK: - skip
//Observable.of(1,2,3,4,5,6,7,8,9)
//    .skip(7)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)


// MARK: - skipWhile
//Observable.of(2,4,6,8,1,5,4,2,9)
//    .skipWhile({ $0 % 2 == 0 }) // true일 동안은 skip하고 false일때부터 방출
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)


// MARK: - skipUntil
//let subject = PublishSubject<String>()
//let trigger = PublishSubject<String>()
//
//subject
//    .skipUntil(trigger)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)
//
//subject.onNext("trigger 작동 전")
//
//trigger.onNext("trigger 시작")
//
//subject.onNext("trigger 작동 이후")

// MARK: - take
//Observable.of("A","b","C")
//    .take(2)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

// MARK: - takeWhile
//Observable.of(1,2,3,4,5)
//    .takeWhile({ $0 > 4 })
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

// MARK: - enumerated
//Observable.of("A","b","C")
//    .enumerated()
//    .take(2)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

// MARK: - takeUntil
//let subject = PublishSubject<String>()
//let trigger = PublishSubject<String>()
//
//subject
//    .takeUntil(trigger)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)
//
//subject.onNext("trigger 작동 전")
//
//trigger.onNext("trigger 시작")
//
//subject.onNext("trigger 작동 이후")


// MARK: - distinctUntilChanged
//Observable.of(1,2,2,2,4,5,4,6)
//    .distinctUntilChanged()
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

// MARK: - distinctUntilChanged(_:)
//// 1. 각각의 번호를 배출하는 NumberFormatter()
//let formatter = NumberFormatter()
//formatter.numberStyle = .spellOut
//
//// 2. formatter를 사용할때 int 변환할 필요 없도록, NSNumbers observable 생성
//Observable<NSNumber>.of(10, 110, 20, 200, 210, 310)
//    // 3. 각각의 sequence쌍을 받는 클로저
//    .distinctUntilChanged({ a, b in
//        //4. 값의 구성 요소를 조건부로 바인딩
//        guard let aWords = formatter.string(from: a)?.components(separatedBy: " "),
//              let bWords = formatter.string(from: b)?.components(separatedBy: " ") else { return false }
//        print(a, b, aWords, bWords)
//
//        var containsMatch = false
//
//        // 5. 각 쌍의 단어를 반복하며, 두 요소가 동일한 단어를 포함하는지 확인
//        for aWord in aWords {
//            for bWord in bWords {
//                if aWord == bWord {
//                    containsMatch = true
//                    break
//                }
//            }
//        }
//
//        return containsMatch
//    })
//    // 6
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)


// MARK: - Challenges
Observable.of(0,0,1,2,5,1,8,12,3,1,0,1)
    .skipWhile({ $0 == 0 })
    .filter({ $0 < 10 })
    .take(10)
    .toArray()
    .subscribe(onNext: {
        print($0)
        let phoneNumber = $0.map { String($0) }.joined()
        print(phoneNumber)
    })
    .disposed(by: disposeBag)

//: [Next](@next)

