import Foundation
import RxSwift

// 구독 공유하기
var start = 0
func getStartNumber() -> Int {
    start += 1
    return start
}

let numbers = Observable<Int>.create { observer in
    let start = getStartNumber()
    observer.onNext(start) // 1
    observer.onNext(start+1) // 2
    observer.onNext(start+2) // 3
    observer.onCompleted()
    return Disposables.create()
}

numbers.subscribe(onNext: {
    print("element [\($0)]") // 1-2-3
}, onCompleted: {
    print("-----------------")
})

// subscribe 호출할 때마다 구독을 위한 새로운 observable 생성
// 각각의 복사본(observable)이 이전 결과와 같다는걸 보장하지 않음
// -> 불필요한 행위를 방지하고 구독을 공유하기 위해서(같은 결과값 보장) share() 연산자 사용
// Rx 코드의 일반적인 패턴은 하나의 소스 observable의 각 결과 값에서 나오는 요소들을 필터링해 여러 개의 sequence들을 생성하는 것
numbers.subscribe(onNext: {
    print("element [\($0)]") // 2-3-4
}, onCompleted: {
    print("-----------------")
})

numbers.subscribe(onNext: {
    print("element [\($0)]") // 3-4-5
}, onCompleted: {
    print("-----------------")
})
