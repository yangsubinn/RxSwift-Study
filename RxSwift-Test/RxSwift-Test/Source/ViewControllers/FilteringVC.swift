//
//  FilteringVC.swift
//  RxSwift-Test
//
//  Created by 양수빈 on 2021/10/10.
//

import UIKit

import RxSwift

class FilteringVC: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        ignoreElementTest()
//        elementAtTest()
//        filterTest()
//        skipTest()
//        skipWhileTest()
//        skipUntilTest()
//        takeTest()
//        takeWhileTest()
//        emueratedTest()
//        takeUntilTest()
        distinctUntilChangedTest()
    }
    
    func ignoreElementTest() {
        print("---------ignoreElement는 next 이벤트를 싫어해---------")
        let heyhey = PublishSubject<String>()
        
        heyhey
            .ignoreElements()
            .subscribe(
                onNext: { event in
                    print(event)
                },
                onCompleted: {
                    print("안녕 이번 생은 여기까지인가바... Completed")
                })
            .disposed(by: disposeBag)
        
        heyhey.onNext("스우파")
        heyhey.onNext("다들")
        heyhey.onNext("안봐?")
        heyhey.onCompleted()
    }
    
    func elementAtTest() {
        print("---------element(at: )은 특정 이벤트만 좋아해---------")
        let forest = PublishSubject<String>()
        
        forest
            .element(at: 2)
            .subscribe(
                onNext: { event in
                    print(event)},
                onCompleted: {
                    print("elementAt 손배야 편애는 안돼... Completed")
                })
            .disposed(by: disposeBag)
        
        forest.onNext("나는 인덱스 0번")
        forest.onNext("나는 인덱스 1번")
        forest.onNext("나는 인덱스 2번")
        forest.onCompleted()
    }
    
    func filterTest() {
        print("filter을 사용해서 조건에 맞는 값만 가져와보도록 해요~")
        Observable.of(1,2,3,4,5,6,7,8)
            .filter { (int) -> Bool in
                int <= 5 && int % 2 == 0
            }
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        Observable.of("안녕", "하세요", "졸려요", "배째")
            .filter { (string) -> Bool in
                string.count == 2
            }
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
    func skipTest() {
        print("skip을 써서 몇개는 건너뛰어버릴테야.")
        Observable.of("뭐", "보", "고", "있", "니", "?")
            .skip(2)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
    func skipWhileTest() {
        print("조건이 true면 skip하고 false일 때 방출해요~ 근데 잘 모르겠어요 이거~")
        Observable.of(1,2,3,4,5)
            .skip(while: {$0 == 2} )
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
            
    }
    
    func skipUntilTest() {
        print("skipUntil은 다름 Observable이 next이벤트를 할 때까지는 스킵하고 이후부터 방출을 해여")
        
        let subject = PublishSubject<String>()
        let triggerSubject = PublishSubject<String>()
        
        subject
            .skip(until: triggerSubject)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        subject.onNext("안녕하세요?")
        subject.onNext("제가 보이시나요?")
        
        triggerSubject.onNext("방아쇠를 당겨 빵야빵야빵야")
        
        subject.onNext("방아쇠 당기고 왔다")
    }
    
    func takeTest() {
        print("몇개가 갖고 싶니? 3개요! 하면 take 할머니가 3개를 주실거에요")
        Observable.of("우산 달고나", "세모 달고나", "동그라미 달고나", "별 달고나", "하트 달고나")
            .take(3)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
    func takeWhileTest() {
        print("takeWhile은 skipWhile과 성격이 정반대인 친구에요")
        Observable.of(1,2,3,4,5)
            .take(while: {$0 > 3})
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
    func emueratedTest() {
        print("emuerated 머시기")
        Observable.of("정답", "땡", "땡", "정답", "땡")
            .enumerated()
            .take(while: {index, value in
                value.count == 1 && index < 3
            })
//            .map()
            .subscribe(onNext : {
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
    func takeUntilTest() {
        print("takeUntil은 다른 Observable이 next이벤트를 할 때까지만 방출")
        
        let subject = PublishSubject<String>()
        let anotherObservable = PublishSubject<String>()
        
        subject
            .take(until: anotherObservable)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        subject.onNext("안녕하세요?")
        subject.onNext("제가 보이시나요?")
        
        anotherObservable.onNext("진정진정")
        
        subject.onNext("나는 이제 진정 안보여")
    }
    
    func distinctUntilChangedTest() {
        Observable.of("하나", "둘", "둘", "둘", "하나")
            .distinctUntilChanged()
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
    public func example(of description: String,
                        action: () -> Void) {
        print("\n— Example of:", description, "—")
        action() /// example 함수 안의 action
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
