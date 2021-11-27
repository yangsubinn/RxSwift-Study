//
//  MainScene.swift
//  Rx-CollectionView
//
//  Created by 양수빈 on 2021/11/25.
//

import UIKit

enum MainScene {
    case present
}

extension MainScene: SceneRegisterable {
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .present:
            guard let nextVC = storyboard.instantiateViewController(withIdentifier: "PresentVC") as? PresentVC else { fatalError() }
            
//            nextVC.titleLabel.text = self.subTitleLabel.text
//            self.present(nextVC, animated: true, completion: nil)
            return nextVC
        }
        
    }
}
