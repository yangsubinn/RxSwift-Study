//
//  ViewController.swift
//  RxSwift-Test
//
//  Created by 양수빈 on 2021/09/13.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var array = [1, 2, 3]
//        for number in array {
//            print(number)
//            array = [4, 5, 6]
//            /// loop 안에서는 array 변형되지 않음
//        }
//        print(array) /// [4, 5, 6]
        
        countLabel.text = "\(array[currentIndex])"
    }
    
    var array = [1, 2, 3]
    var currentIndex = 0
    
    @IBAction func printNext(_ sender: Any) {
        print(array[currentIndex])
        
        if currentIndex != array.count - 1 {
            currentIndex += 1
        }
        print(array)
        countLabel.text = "\(array[currentIndex])"
    }
    
}

