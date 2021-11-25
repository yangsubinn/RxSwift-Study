//
//  MainVC.swift
//  Rx-CollectionView
//
//  Created by 양수빈 on 2021/11/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class MainVC: UIViewController {
    
    let lists = [1,2,3,4,5]
    let textLists = ["꼬깔", "지도", "스피커", "타겟", "선물"]
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let bottomLabel = UILabel()
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    
    var pupuBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        configUI()
        setupDelegate()
        setupCollectionView()
    }
    
    private func configUI() {
        titleLabel.text = "받고싶은 선물 골라골라"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        subTitleLabel.text = textLists[0]
        bottomLabel.text = "내가 pick한 선물은?"
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(bottomLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(140)
            make.leading.equalToSuperview().offset(20)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupDelegate() {
//        collectionView.delegate = self
//        collectionView.dataSource = self
    }

    private func setupCollectionView() {
        collectionView.register(MainCVC.self, forCellWithReuseIdentifier: "MainCVC")
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.scrollDirection = .horizontal
        
        let items = Observable.just(
            (1...5).map{"\($0)"}
        )

        items
            .bind(to: collectionView.rx.items(cellIdentifier: MainCVC.identifier, cellType: MainCVC.self)) { (row, element, cell) in
                cell.iconImageView.image = UIImage(named: "\(element)")
            }
            .disposed(by: pupuBag)
        
        collectionView.rx
            .itemSelected
            .subscribe(onNext: {
                print("\($0)")
//                self.bottomLabel.text = self.textLists[indexpath.row]
                self.bottomLabel.text = self.subTitleLabel.text
                
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "PresentVC") as? PresentVC else {return}
                
                nextVC.titleLabel.text = self.subTitleLabel.text
                self.present(nextVC, animated: true, completion: nil)
                
            })
            .disposed(by: pupuBag)
        
//        collectionView.rx
//            .modelSelected(String.self)
//            .subscribe(onNext: {
//                print("\($0)")
//            })
//            .disposed(by: pupuBag)
        
        collectionView.rx.setDelegate(self).disposed(by: pupuBag)
    }
}

extension MainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension MainVC: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / view.frame.width
        var roundedIndex = round(index)
        
        subTitleLabel.text = "\(textLists[Int(roundedIndex)])"
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        bottomLabel.text = subTitleLabel.text
//    }
}

//extension MainVC: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return lists.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCVC", for: indexPath) as? MainCVC else {return UICollectionViewCell()}
//
//        cell.iconImageView.image = UIImage(named: "\(lists[indexPath.item])")
//
//        return cell
//    }
//}
