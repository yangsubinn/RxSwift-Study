//
//  Scene.swift
//  RxMemo-Yangsubinn
//
//  Created by 양수빈 on 2021/10/05.
//

import Foundation
import UIKit

/// scene과 연관된 뷰모델을 연관값으로 저장
enum Scene {
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
}

extension Scene {
    /// 스토리보드에 있는 씬은 생성하고 연관값에 저장된 뷰모델을 바인딩해서 리턴하는 메소드
    func instatiate (from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .list(let viewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else { fatalError() }
            
            guard var listVC = nav.viewControllers.first as? MemoListViewController else { fatalError() }
            
            listVC.bind(viewModel: viewModel) /// viewModel은 네비게이션컨트롤러에 임베디드되어있는 루트뷰컨트롤러에 바인딩하고 리턴할때는 네비게이션컨트롤러를 리턴
            return nav
            /// 여기여기
            
        case .detail(let viewModel):
            /// 이 씬은 항상 네비게이션 스택에 푸시되기 때문에 네비게이션컨트롤러를 고려할 필요 X
            guard var detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else { fatalError() }
            
            detailVC.bind(viewModel: viewModel)
            return detailVC /// 뷰컨을 리턴
            
        case .compose(let viewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else { fatalError() }
            
            guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else { fatalError() }
            
            composeVC.bind(viewModel: viewModel)
            return nav /// 실제 씬과 뷰모델을 바인딩하고 네비게이션컨트롤 리턴
        }
    }
}
