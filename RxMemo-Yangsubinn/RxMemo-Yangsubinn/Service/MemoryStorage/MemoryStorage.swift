//
//  MemoryStorage.swift
//  RxMemo-Yangsubinn
//
//  Created by 양수빈 on 2021/10/04.
//

import Foundation
import RxSwift

class MemoryStorage: MemoStorageType {
    
    /// 클래스 외부에서 배열에 직접 접근할 일이 없기 때문에 private
    /// 배열은 observable을 통해 외부로 공개
    /// 배열의 상태가 update되면 새로운 next 이벤트 방출
    /// 그냥 observable은 안되서.. subject로 만들어야 함
    ///
    private var list = [
        // dummydata
        Memo(content: "Hello, RxSwift", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "안녕돼지", insertDate: Date().addingTimeInterval(-20))
    ]
    
    private lazy var sectionModel = MemoSectionModel(model: 0, items: list)
    
    /// 기본값을 list로 넣어주기 위해서 lazy로 선언
    /// 외부에서 직접 접근할 일이 없기 때문에 private로 선언
    private lazy var store = BehaviorSubject<[MemoSectionModel]>(value: [sectionModel])
    
    
    /// 배열 변경 -> next 이벤트에서 변경한 배열 방출
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        let memo = Memo(content: content)
        sectionModel.items.insert(memo, at: 0)
        
        store.onNext([sectionModel]) /// next 이벤트 방출
        
        return Observable.just(memo) /// 새로 만든 메모를 방출하는 observable return
    }
    
    @discardableResult
    func memoList() -> Observable<[MemoSectionModel]> {
        return store
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        let updated = Memo(original: memo, updatedContent: content)
        
        /// 배열에 저장된 원본 인스턴스를 새로운 인스턴스로 교체
        if let index = sectionModel.items.firstIndex(where: {$0 == memo}) {
            sectionModel.items.remove(at: index)
            sectionModel.items.insert(updated, at: index)
        }
        
        store.onNext([sectionModel]) /// next 이벤트 방출
        
        return Observable.just(updated) /// 업데이트된 observable return
    }
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        if let index = sectionModel.items.firstIndex(where: { $0 == memo }) {
            sectionModel.items.remove(at: index)
        }
        
        store.onNext([sectionModel])
        
        return Observable.just(memo) /// 삭제된 oservable 방출
    }
}
