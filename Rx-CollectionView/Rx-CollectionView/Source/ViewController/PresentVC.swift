//
//  PresentVC.swift
//  Rx-CollectionView
//
//  Created by 양수빈 on 2021/11/25.
//

import UIKit

class PresentVC: UIViewController {
    
    let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    func configUI() {
        titleLabel.text = "기본"
    }
    
    func setupLayout() {
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}
