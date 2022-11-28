/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import RxSwift
import RxRelay

class MainViewController: UIViewController {

  @IBOutlet weak var imagePreview: UIImageView!
  @IBOutlet weak var buttonClear: UIButton!
  @IBOutlet weak var buttonSave: UIButton!
  @IBOutlet weak var itemAdd: UIBarButtonItem!
  
  private let disposeBag = DisposeBag()
//  private let images = BehaviorRelay<[UIImage]>(value: [])
  // TODO: - Variable을 BehaviorRelay로 수정하기
  private let images = Variable<[UIImage]>([])
  private var imageCache = [Int]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    images.asObservable()
    // 주어진 시간 내에 뒤따라오는 요소들을 필터링
    // 빠르게 여러개의 사진을 성공적으로 탭했더라도 구독은 새로운 콜라주를 일일히 만들어냄 -> 리소스 낭비
    // 어떤 사용자가 사진 하나를 선택하고 바로 다음 사진을 선택하는데 0.2초가 걸렸다면, throttle은 첫번째 요소를 필터하고 두번째 사진만 내뱉음 -> 첫번째 중간 콜라주를 작성하는 시간 절약
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] photos in
        guard let preview = self?.imagePreview else { return }
        preview.image = UIImage.collage(images: photos, size: preview.frame.size)
      })

    images.asObservable()
      .subscribe(onNext: { [weak self] photos in
        print("photos: \(photos)")
        self?.updateUI(photos: photos)
      })
      .disposed(by: disposeBag)
    
  }
  
  @IBAction func actionClear() {
    images.value = []
    imageCache = []
  }

  @IBAction func actionSave() {
    // preview에 있는 콜라주 이미지를 저장
    guard let image = imagePreview.image else {
      return }
    
    // 새로운 assetID를 한번만 방출하거나 에러를 방출함 -> Single
//    PhotoWriter.save(image)
//      .asSingle()
//      .subscribe(onSuccess: { [weak self] id in
//        self?.showMessage("Saved with id: \(id)")
//        self?.actionClear()
//      }, onError: { [weak self] error in
//        self?.showMessage("Error", description: error.localizedDescription)
//      })
//      .disposed(by: disposeBag)
    
    PhotoWriter.save(image)
      .subscribe(onSuccess: { [weak self] id in
        self?.showMessage("Saved with id: \(id)")
        self?.actionClear()
      }, onError: { [weak self] error in
        self?.showMessage("Error", description: error.localizedDescription)
      })
      .disposed(by: disposeBag)
  }

  @IBAction func actionAdd() {
    guard let photosVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotosViewController") as? PhotosViewController else { return }
    navigationController?.pushViewController(photosVC, animated: true)
    
    let newPhotos = photosVC.selectedPhotos.share()
    
//    photosVC.selectedPhotos
    newPhotos
      .takeWhile({ [weak self] image in
        // 6개까지만 사진을 추가할 수 있도록
        return (self?.images.value.count ?? 0) < 6
      })
      .filter({ new in
        return new.size.width > new.size.height // 세로로 긴 사진은 거절
      })
      .filter({ [weak self] new in
        // 새로운 이미지의 png 데이터 byte 수를 상수 len으로 저장
        // imageCache가 같은 값을 이미 갖고 있다면 중복 이미지라 판단하고 false 반환
//        let len = UIImagePNGRepresentation(newImage)?.count ?? 0
        let len = (new.pngData()! as NSData).count
//        print("len: ", len)
        guard self?.imageCache.contains(len) == false else { return false }
        self?.imageCache.append(len)
//        print("imageCache: ", self?.imageCache)
        return true
      })
      .subscribe(onNext: { [weak self] newImage in
        guard let images = self?.images else { return }
        print("newImage: \(newImage)")
        images.value.append(newImage)
      }, onDisposed: {
        // disposeBag을 사용하기 때문에
        // onCompleted event를 보내지 않으면,
        // MainViewController가 완전히 메모리에서 할당 해제되어야지 dispose 됨
        print("completed photo selection")
      })
      .disposed(by: disposeBag)
    
    // selectedPhotos를 가져와 네비게이션바 우측 상단 아이템에 추가
    newPhotos
      .ignoreElements()
      .subscribe(onCompleted: { [weak self] in
        self?.updateNavigationIcon()
      })
      .disposed(by: photosVC.disposeBag)
  }
  
  private func updateNavigationIcon() {
    let icon = imagePreview.image?
      .scaled(CGSize(width: 22, height: 22))
      .withRenderingMode(.alwaysOriginal)
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: icon, style: .done, target: nil, action: nil)
  }

  func showMessage(_ title: String, description: String? = nil) {
//    let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
//    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { [weak self] _ in self?.dismiss(animated: true, completion: nil)}))
//    present(alert, animated: true, completion: nil)
    alert(title: title, text: description)
      .subscribe()
      .disposed(by: disposeBag)
  }
  
  private func updateUI(photos: [UIImage]) {
    buttonSave.isEnabled = photos.count > 0 && photos.count % 2 == 0
    buttonClear.isEnabled = photos.count > 0
    itemAdd.isEnabled = photos.count < 6
    title = photos.count > 0 ? "\(photos.count) photos" : "Collage"
  }
}

// MARK: - Completable을 사용하여 alert 띄우기
extension UIViewController {
  func alert(title: String, text: String?) -> Completable {
    return Completable.create(subscribe: { [weak self] completable in
      let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
//        self?.dismiss(animated: true, completion: nil)
        completable(.completed)
      }))
      self?.present(alert, animated: true, completion: nil)
      
      return Disposables.create {
        self?.dismiss(animated: true)
      }
    })
  }
}
