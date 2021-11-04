//
//  CombiningVC.swift
//  RxSwift-Test
//
//  Created by 양수빈 on 2021/11/01.
//

import UIKit

import RxSwift

class CombiningVC: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

//        startWithTest()
//        concatTest()
        concatFlatTest()
//        mergeTest()
//        combineLatest()
//        zipTest()
//        withLatestFromTest()
//        sampleTest()
//        reduceTest()
//        scanTest()
//        switchLatestTest()
//        ambiguousTest()
    }
    
    func startWithTest() {
        let student = ["학생1", "학생2", "학생3", "학생4", "학생5"]
        
        Observable.from(student)
            .startWith("새치기하는 나")
            .startWith("새치기하는 줌보걸즈 대장", "그 뒤의 후릐언니")
            .subscribe(onNext: {
              print($0)
            })
            .disposed(by: disposeBag)
    }
    
    func concatTest() {
        let student = Observable.from(["학생1", "학생2", "학생3", "학생4", "학생5"])
        let scaryStudent = Observable.from(["양아치1", "양아치2", "양아치3", "양아치4"])
        
        Observable.concat(scaryStudent, student)
            .subscribe(onNext:{
                print($0)
            }).disposed(by: disposeBag)
    }
    
    /// 모르겠다..
    func concatFlatTest() {
//        struct Student {
//            var score: BehaviorSubject<Int>
//        }
//
//        let ryan = Student(score: BehaviorSubject(value: 80))
//        let charlotte = Student(score: BehaviorSubject(value: 90))
//
//        let student = PublishSubject<Student>()
//
//        student
//            .concatMap {
//                $0.score
//            }
//            .subscribe(onNext: {
//                print($0)
//            })
//            .disposed(by: disposeBag)
//
//        student.onNext(ryan) /// 80
//        ryan.score.onNext(85) /// 85
//
//        student.onNext(charlotte) /// 90
//        ryan.score.onNext(95) /// 95
//
//        charlotte.score.onNext(100)
        
        let sequences = [
            "Germany": Observable.of("Berlin", "Münich", "Frankfurt"),
            "Spain": Observable.of("Madrid", "Barcelona", "Valencia")
        ]
        
        let observable = Observable.of("Germany", "Spain")
        
        Observable.of("Germany", "Spain")
            .concatMap({ country in
//            print("--------")
            sequences[country] ?? .empty()
        }).subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
    
    func mergeTest() {
        let child = PublishSubject<String>()
        let adult = PublishSubject<String>()

        /// asObservable()
        /// : subject는 observer이랑 observable의 역할을 둘 다 하는데, 외부에서 observer에 접근하지 못하도록 설정 -> observable에만 접근할 수 있도록 나눠서 접근이 가능하도록
//        let source = Observable.of(child.asObservable(), adult.asObservable())
//        let observable = source.merge()
//        observable.subscribe(onNext: {
//                print($0)
//        }).disposed(by: disposeBag)
        
        Observable.of(child.asObserver(), adult.asObserver())
            .merge()
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)

        child.onNext("안녕하세요")
        child.onNext("몇살이세여?")
        adult.onNext("아 전 56살이요")
        adult.onNext("그쪽은요?")
        adult.onCompleted()
        child.onNext("아 전 1살이요")
    }
    
    func combineLatest() {
        let left = PublishSubject<Int>()
        let right = PublishSubject<Int>()
        
        Observable.combineLatest(left, right) {
            "\($0) : \($1)"
        }.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        left.onNext(1)
        left.onNext(2)
        
        right.onNext(3)
        right.onNext(4)
        
        left.onNext(99)
    }
    
    func zipTest() {
        let left = PublishSubject<Int>()
        let right = PublishSubject<Int>()
        
        Observable.zip(left, right) {
            "\($0) : \($1)"
        }.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        left.onNext(1)
        left.onNext(2)
        
        right.onNext(3)
        right.onNext(4)
        
        left.onNext(99)
    }

    func withLatestFromTest() {
        let button = PublishSubject<String>() /// trigger Observable
        let textField = PublishSubject<String>() /// data Observable
        
        let observable = button.withLatestFrom(textField)
        observable.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        textField.onNext("하하")
        textField.onNext("집가")
        textField.onNext("고싶")
        textField.onNext("다!!!!!!")
        button.onNext("tap")
        button.onNext("tap")
        
        textField.onNext("끝난 줄 알았지?")
        button.onNext("tap")
    }
    
    func sampleTest() {
        let button = PublishSubject<String>()
        let textField = PublishSubject<String>()
        
        let observable = textField.sample(button) /// textField에 적용
        observable.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        textField.onNext("하하")
        textField.onNext("집가")
        textField.onNext("고싶")
        textField.onNext("다!!!!!!")
        button.onNext("tap")
        button.onNext("tap")
        
        textField.onNext("끝난 줄 알았지?")
        button.onNext("tap")
    }
    
    func reduceTest() {
        let source = Observable.of(1,2,3)
        
        // 방식1
        source.reduce(1, accumulator: +)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)

        // 방식2
        source.reduce(0, accumulator: { summary, newValue in
            return summary + newValue
        }).subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        // Int 타입만
//        let sourceStr = Observable.of("아", "나", "바", "다")
//        sourceStr.reduce(0, accumulator: +)
//            .subscribe(onNext: {
//                print($0)
//            }).disposed(by: disposeBag)
    }
    
    func scanTest() {
        let source = Observable.of(1,2,3)
        
        source.scan(0, accumulator: +)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }
    
    func switchLatestTest() {
        let a = PublishSubject<String>()
        let b = PublishSubject<String>()
        
        let source = PublishSubject<Observable<String>>()
        
        source
            .switchLatest()
            .subscribe (onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        a.onNext("1")
        b.onNext("b")
        source.onNext(a)
        
        a.onNext("이")
        b.onNext("b")
        source.onNext(b)
        
        a.onNext("3")
        b.onNext("씨")
        a.onCompleted()
        b.onCompleted()
        
        source.onCompleted()
    }
    
    func ambiguousTest() {
        let congi = PublishSubject<String>()
        let subin = PublishSubject<String>()
        
        congi.amb(subin)
            .subscribe(onNext: {
            print($0)
        })
        
        congi.onNext("주인 밥줘")
        subin.onNext("나 졸려")
        congi.onNext("주인아 밥달라고")
        congi.onNext("주인아 산책가자고")
        subin.onNext("...")
        
        congi.onCompleted()
        subin.onCompleted()
    }
}
