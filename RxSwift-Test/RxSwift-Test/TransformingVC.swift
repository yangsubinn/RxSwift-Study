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
        
        let john = Student(score: BehaviorSubject(value: 75))
        let mary = Student(score: BehaviorSubject(value: 95))
        
        let student = PublishSubject<Student>()
        
        student.asObservable()
            .debug("debug")
            .flatMap { $0.score.asObservable() }
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
        student.onNext(john)
        john.score.onNext(100)
        student.onNext(mary)
        john.score.onNext(90)
    }
    
    func flatMapLatestTest() {
        struct Student {
            var score: BehaviorSubject<Int>
        }
        
        let laura = Student(score: BehaviorSubject(value: 80))
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
        
        student.onNext(laura) // print : 80
        laura.score.onNext(85) // print : 85
        student.onNext(charlotte) // print : 90
        
        laura.score.onNext(95) // print : none
        charlotte.score.onNext(100) // print : 100
    }
    
    func materializeTest() {
        enum MyError: Error {
            case anError
        }
        
        struct Student {
            var score: BehaviorSubject<Int>
        }
        
        let laura = Student(score: BehaviorSubject(value: 80))
        let charlotte = Student(score: BehaviorSubject(value: 90))
        
        let student = PublishSubject<Student>()
        
        let studentScore = student
            .flatMapLatest {
                $0.score.materialize()
            }
        
        studentScore
              .subscribe(onNext: {
                print($0) // print : 80
              })
              .disposed(by: disposeBag)
        
        student.onNext(laura) // print : 80
        laura.score.onNext(85) // print : 85
        student.onNext(charlotte) // print : 90
        
        laura.score.onNext(95) // print : none
        charlotte.score.onNext(100) // print : 100
    }
}
