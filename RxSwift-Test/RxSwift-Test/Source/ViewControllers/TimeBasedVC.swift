//
//  TimeBasedVC.swift
//  RxSwift-Test
//
//  Created by 양수빈 on 2021/11/08.
//

import UIKit

import RxSwift

class TimeBasedVC: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

//        shareTest()
//        delaySubscription()
//        delay()
//        interval()
        timer()
    }
    
    func shareTest() {
        let result = Observable.of("캐", "치", "미").share()
        
        result.subscribe(onNext: {
            print("result1")
            print($0)
        }).disposed(by: disposeBag)
        
        result.subscribe(onNext: {
            print("result2")
            print("\($0)-짱")
        }).disposed(by: disposeBag)
    }
    
    func shareRelayTest() {
        
    }
    
    func delaySubscription() {
        print(Date())
        let student = ["지각1", "지각2", "지각3", "지각4", "지각5"]
        
        Observable.from(student)
            .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext:{
                print(Date())
                print($0)
            }).disposed(by: disposeBag)
    }
    
    func delay() {
        print(Date())
        let student = ["지각1", "지각2", "지각3", "지각4", "지각5"]
        
        Observable.from(student)
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext:{
                print(Date())
                print($0)
            }).disposed(by: disposeBag)
    }
    
    func interval() {
        let observable = Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
            })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { observable.dispose() }
    }
    
    func timer() {
        /// period X
//        print(Date())
//        let noperiod = Observable<Int>
//            .timer(.seconds(2), scheduler: MainScheduler.instance)
//            .subscribe(onNext: {
//                print($0)
//                print(Date())
//            }).disposed(by: disposeBag)
        
        /// period O
        print(Date())
        let period = Observable<Int>
            .timer(.seconds(2), period: .seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
                print(Date())
            }) ///.disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6 ){ period.dispose() }
    }
    
    func timeout() {
        
    }
}
