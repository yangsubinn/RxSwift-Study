//
//  MainCVC.swift
//  Rx-CollectionView
//
//  Created by 양수빈 on 2021/11/24.
//

import UIKit

class MainCVC: UICollectionViewCell {
    
    static let identifier = "MainCVC"
    
    let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(300)
        }
    }
}
