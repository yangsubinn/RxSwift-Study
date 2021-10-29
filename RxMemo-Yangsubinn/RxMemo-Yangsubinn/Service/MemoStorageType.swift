//
//  MemoStorageType.swift
//  RxMemo-Yangsubinn
//
//  Created by 양수빈 on 2021/10/04.
//

import Foundation
import RxSwift

protocol MemoStorageType {
    // CRUD 처리 함수
    @discardableResult /// 작업 결과가 필요없는 경우도 있을 수 있기 때문에
    func createMemo(content: String) -> Observable<Memo> /// 구독자가 작업 결과를 원하는 방식으로 처리할 수 있게 됨
    
    @discardableResult
    func memoList() -> Observable<[MemoSectionModel]>
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo>
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo>
}
