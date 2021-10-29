//
//  MemoListViewController.swift
//  RxMemo-Yangsubinn
//
//  Created by 양수빈 on 2021/10/05.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {
    /// 뷰컨에서 프로토콜 채용
    
    var viewModel: MemoListViewModel!

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        /// 뷰모델과 뷰 바인딩
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag) /// ㅇ왜 에러야
        
        viewModel.memoList
            .bind(to: listTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: rx.disposeBag)
//            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { row, memo, cell in
//                cell.textLabel?.text = memo.content
//            }
        
        /// addButton bindind
        addButton.rx.action = viewModel.makeCreateAction()
        
        /// 테이블뷰에서 메모를 선택하면 뷰 모델을 통해서 디테일 액션을 전달하고 선택한 셀은 선택해제
        Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected)
            .do(onNext: { [unowned self] (_, indexPath) in
                self.listTableView.deselectRow(at: indexPath, animated: true)
            })
                .map { $0.0 } /// 선택상태를 처리했기 때문에 이후에는 indexPath 필요없고, 데이터만 방출하도록
                .bind(to: viewModel.detailAction.inputs)
                .disposed(by: rx.disposeBag)
        
        /// controlEvent return
        /// 메모를 삭제할 때마다 next이벤트 방출
        /// 스와이프 삭제 액션
        listTableView.rx.modelDeleted(Memo.self)
            .bind(to: viewModel.deleteAction.inputs)
            .disposed(by: rx.disposeBag)
         
//        var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
//        viewModel.title
//            .drive(backButton.rx.title)
//            .disposed(by: rx.disposeBag)
//        backButton.rx.action = viewModel.popAction
//
//        navigationItem.hidesBackButton = true
//        navigationItem.leftBarButtonItem = backButton /// 기존의 뒤로가기 버튼은 삭제하고 새로 생성해서 연결
////        navigationItem.backBarButtonItem = backButton /// 기존의 기본 뒤로가기 버튼과 새로 생성한 backButton 속성 연결
    }

}
