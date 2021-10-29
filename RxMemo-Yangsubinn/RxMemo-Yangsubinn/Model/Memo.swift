//
//  Memo.swift
//  RxMemo-Yangsubinn
//
//  Created by 양수빈 on 2021/10/04.
//

import Foundation
import RxDataSources

struct Memo: Equatable, IdentifiableType {
    var content: String
    var insertDate: Date
    var identity: String
    
    init(content: String, insertDate: Date = Date()) {
        self.content = content
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    // update된 내용으로 새로운 instance를 생성할 떄
    init(original: Memo, updatedContent: String) {
        self = original
        self.content = updatedContent
    }
}
