//
//  ViewModelBindableType.swift
//  RxMemo-Yangsubinn
//
//  Created by 양수빈 on 2021/10/05.
//

import UIKit

/// MVVM에서는 뷰모델을 뷰의 속성으로 추가
/// 그 다음 뷰모델과 뷰를 바인딩할 때 필요한 요소

protocol ViewModelBindableType {
    /// 뷰모델의 타입은 뷰컨트롤러마다 달라지기 때문에
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

extension ViewModelBindableType where Self: UIViewController {
    /// 뷰컨에 추가된 뷰모델 속성의 실제 뷰모델을 저장하고 바인드 뷰 모델 메소드를 자동으로 호출하는 메소드 구현
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        bindViewModel()
        /// 개별 뷰컨에서 직접 bindViewModel 메소드를 직접 호출할 필요가 없어서 그만큼 코드가 단순해짐
    }
}
