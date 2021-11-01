//
//  TransformingVC.swift
//  RxSwift-Test
//
//  Created by 양수빈 on 2021/10/24.
//

import UIKit

import RxSwift

class TransformingVC: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var arr : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

//        toArrayTest()
//        mapTest()
//        flatMapTest()
//        flatMapLatestTest()
        materializeTest()
    }
    
    func toArrayTest() {
        Observable.of("캐", "치", "미")
            .toArray()
            .subscribe(onSuccess: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
    func mapTest() {
        Observable.of(1,2,3,4,5)
            .map {
                return $0 * 4
            }.subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }
    
    func flatMapTest() {
        struct Student {
            var score: BehaviorSubject<Int>
        }
//
//        let john = Student(score: BehaviorSubject(value: 75))
//        let mary = Student(score: BehaviorSubject(value: 95))
//
//        let student = PublishSubject<Student>()
//
//        student.asObservable()
////            .debug("debug")
//            .flatMap { $0.score.asObservable() }
//            .subscribe(onNext: {
//                print($0)
//            }).disposed(by: disposeBag)
//
//        student.onNext(john) /// 75
//        john.score.onNext(100) /// 100
//
//        student.onNext(mary) /// 95
//        john.score.onNext(90) /// 90
        
        // 1 Student 타입 변수 2개 생성
        let ryan = Student(score: BehaviorSubject(value: 80))
        let charlotte = Student(score: BehaviorSubject(value: 90))
        
        // 2 Student 타입의 subject 생성 (위에서 선언한 변수 ryan과 charlotte가 element로 들어갈 subject)
        let student = PublishSubject<Student>()
        
        // 3
        student
            .flatMap {
                $0.score /// Student 타입의 시퀸스인 student를 Student 내에 있는 score로 tranform
            }
        // 4 student 시퀀스에서 transform 된 score를 구독
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        // 5
        student.onNext(ryan) /// student subject(시퀀스)에 ryan을 넣으면, ryan의 score로 transform 되서 80 출력됨
        ryan.score.onNext(85) /// 80이었던 ryan의 score을 85로 변경해서 출력 -> ryan의 score에 대한 시퀀스가 하나 더 생성됨
        
        student.onNext(charlotte)
        ryan.score.onNext(95)
        
        charlotte.score.onNext(100)
        
//        let sequenceInt = Observable.of(1, 2, 3)
//        let sequenceString = Observable.of("A", "B", "C") ///, "D"
        
//        sequenceInt
//            .flatMap { (x: Int) -> Observable<String> in
//                print("------------------------")
//                print("Emit Int Item : \(x)")
//                return sequenceString
//            }
//            .subscribe(onNext: {
//                print("Emit String Item : \($0)")
//            })
//            .disposed(by: disposeBag)
        
//        sequenceInt
//            .flatMap { (x: Int) -> Observable<String> in
//                print("--------------------------")
//                print("Emit Int Item : \(x)")
////                return sequenceString.map{ "\(x):\($0)"}
//                return sequenceString
//            }
//            .subscribe(onNext: {
////                self.arr.append($0)
//                print("Emit String Item : \($0)")
//            })
//
////        print(arr)
    }
    
    func flatMapLatestTest() {
        struct Student {
            var score: BehaviorSubject<Int>
        }
        
        let ryan = Student(score: BehaviorSubject(value: 80))
        let charlotte = Student(score: BehaviorSubject(value: 90))
        
        let student = PublishSubject<Student>()
        
        student
            .flatMapLatest {
                $0.score
            }
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        student.onNext(ryan) /// 80
        ryan.score.onNext(85) /// 85
        
        // 1
        student.onNext(charlotte) /// 90
        
        // 2
        ryan.score.onNext(95) /// 95로 변형됐지만, charlotte라는 녀석이 구독되었기 때문에 이 시퀀스에서 변화는 더이상 놉
        charlotte.score.onNext(100)
        
        ryan.score.onNext(1000)
        charlotte.score.onNext(0)
//
//        let laura = Student(score: BehaviorSubject(value: 80))
//        let charlotte = Student(score: BehaviorSubject(value: 90))
//
//        let student = PublishSubject<Student>()
//
//        student
//            .flatMapLatest {
//                $0.score
//            }
//            .subscribe(onNext: {
//                print($0)
//            })
//            .disposed(by: disposeBag)
//
//        student.onNext(laura) // print : 80
//        laura.score.onNext(85) // print : 85
//        student.onNext(charlotte) // print : 90
//
//        laura.score.onNext(95) // print : none
//        charlotte.score.onNext(100) // print : 100
        
//        let sequenceInt = Observable.of(1, 2, 3)
//        let sequenceString = Observable.of("A", "B", "C", "D")
        
//        sequenceInt
//            .flatMapFirst {
//                (x: Int) -> Observable<String> in
//                print("Emit Int Item : \(x)")
//                return sequenceString.map{ "\(x):\($0)"}
//            }
//            .subscribe(onNext: {
//                self.arr.append($0)
//            })
        
//        sequenceInt
//            .flatMapLatest {
//                (x: Int) -> Observable<String> in
//                print("Emit Int Item : \(x)")
//                return sequenceString.map{ "\(x):\($0)"}
//            }
//            .subscribe(onNext: {
//                self.arr.append($0)
//            })
//
//        print(arr)
    }
    
    func materializeTest() {
//        enum MyError: Error {
//            case anError
//        }
        
        struct Student {
            var score: BehaviorSubject<Int>
        }
        
//        let laura = Student(score: BehaviorSubject(value: 80))
//        let charlotte = Student(score: BehaviorSubject(value: 90))
//
//        let student = PublishSubject<Student>()
//
//        let studentScore = student
//            .flatMapLatest {
//                $0.score.materialize()
//            }
//
//        studentScore
//              .subscribe(onNext: {
//                print($0) // print : 80
//              })
//              .disposed(by: disposeBag)
//
//        student.onNext(laura) // print : 80
//        laura.score.onNext(85) // print : 85
//        student.onNext(charlotte) // print : 90
//
//        laura.score.onNext(95) // print : none
//        charlotte.score.onNext(100) // print : 100
        
        // 1
        enum MyError: Error {
            case anError
        }
        
        // 2
        let ryan = Student(score: BehaviorSubject(value: 80))
        let charlotte = Student(score: BehaviorSubject(value: 100))
        
        let student = BehaviorSubject(value: ryan)
        
        // 3
        let studentScore = student
            .flatMapLatest{
                $0.score.materialize() /// materialize()
            }
        
        // 4
        studentScore
            .filter {
                guard $0.error == nil else {
                    print($0.error!)
                    return false
                }
                return true
            }
            .dematerialize()
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        // 5
        ryan.score.onNext(85)
        ryan.score.onError(MyError.anError)
        ryan.score.onNext(90)
        
        // 6
        student.onNext(charlotte)
    }
}
