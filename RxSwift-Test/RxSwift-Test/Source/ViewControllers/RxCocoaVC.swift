//
//  RxCocoaVC.swift
//  RxSwift-Test
//
//  Created by 양수빈 on 2021/11/17.
//

import UIKit
import RxSwift
import RxCocoa

class RxCocoaVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
//    let items = ["하나", "둘", "셋", "넷", "다섯"]
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView.delegate = self
//        tableView.dataSource = self
        let items = Observable.just(
            (1...20).map { "\($0)" }
        )

        // 각 셀을 구성 -> cellForRowAt
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element)"
            }
            .disposed(by: disposeBag)

        // 셀을 클릭했을 때 데이터 값을 출력 -> didSelectRowAt
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext:  { item in
                print("\(item)")
            })
            .disposed(by: disposeBag)
    }
}

//extension RxCocoaVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.textLabel?.text = items[indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("\(items[indexPath.row])")
//    }
//}
