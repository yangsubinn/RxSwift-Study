//
//  MemoComposeViewController.swift
//  RxMemo-Yangsubinn
//
//  Created by 양수빈 on 2021/10/05.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var contentTextView: UITextView!
    
    var viewModel: MemoComposeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)
        
        /// 버튼 액션과 뷰모델 바인딩
        cancelButton.rx.action = viewModel.cancelAction
        
        /// 더블탭 막기 위해 throttle 연산자 사용
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs) /// viewModel의 saveAction과 바인딩
            .disposed(by: rx.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTextView.becomeFirstResponder() /// 키보드 입력이 바로 활성화되도록
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        /// 이전 씬으로 돌아가기 전에 키보드 입력 해제
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
}
