//
//  SceneRegisterable.swift
//  Rx-CollectionView
//
//  Created by μμλΉ on 2021/11/25.
//

import UIKit

protocol SceneRegisterable {
    func instantiate(from storyboard: String) -> UIViewController
}

extension SceneRegisterable where Self == MainScene {
    func instantiate(from storyboard: String) -> UIViewController {

        return UIViewController()
    }
}
