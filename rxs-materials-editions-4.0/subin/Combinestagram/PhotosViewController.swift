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
import Photos

import RxSwift

class PhotosViewController: UICollectionViewController {

  // MARK: public properties

  // MARK: private properties
  private lazy var photos = PhotosViewController.loadPhotos()
  private lazy var imageManager = PHCachingImageManager()
  let disposeBag = DisposeBag()
  
  private lazy var thumbnailSize: CGSize = {
    let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
    return CGSize(width: cellSize.width * UIScreen.main.scale,
                  height: cellSize.height * UIScreen.main.scale)
  }()
  
  /// 선택된 사진을 방출할 publishSubject
  private let selectedPhotosSubject = PublishSubject<UIImage>()
  /// subject의 observable을 방출할 프로퍼티
  var selectedPhotos: Observable<UIImage> {
    return selectedPhotosSubject.asObservable()
  }

  static func loadPhotos() -> PHFetchResult<PHAsset> {
    let allPhotosOptions = PHFetchOptions()
    allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
    return PHAsset.fetchAssets(with: allPhotosOptions)
  }

  // MARK: View Controller
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let authorized = PHPhotoLibrary.authorized.share()
    
    // 접근 허용되었을때 사진 reload
    authorized
      .skipWhile { $0 == false } // true가 나오기 전까지 false는 무시
      .take(1) // true가 나오면 하나만 받고 그 뒤는 무시
      .subscribe(onNext: { [weak self] _ in
        self?.photos = PhotosViewController.loadPhotos()
        
        // requeustAuthorization가 background 쓰레드에서 작동
        // onNext 이벤트도 background 쓰레드에서 방출
        // UI작업은 main 쓰레드에서만 돌려야 함으로 main으로 바꿔줌
        DispatchQueue.main.async {
          self?.collectionView.reloadData()
        }
      })
      .disposed(by: disposeBag)
    
    // 사용자가 접근 허용하지 않은 경우 에러메시지 표시
    authorized
      .skip(1) // 진입시 접근허용하지 않은 경우 1회 스킵
      .takeLast(1) // 마지막 요소(다시 한번 접근허용 물어봤을때 최근 답)
      .filter { $0 == false }
      .subscribe(onNext: { [weak self] _ in
        guard let errorMessage = self?.errorMessage else { return }
        DispatchQueue.main.async(execute: errorMessage)
      }).disposed(by: disposeBag)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    // 뷰가 사라질때 completed 해줘야 완전히 종료(dispose) 됨
    selectedPhotosSubject.onCompleted()
  }
  
  // MARK: - Custom Method
  
  private func errorMessage() {
    alert(title: "No access to Camera Roll", text: "You can grant access to Combinestagram from the Settings app")
      .asObservable()
      // 주어진 시간동안 소스 sequence에서 나온 요소를 갖고 있다가 시간이 지나면 결과 sequence가 완료
    // 5.0초 동안 alert를 보여줬다가 popViewController
      .take(5.0, scheduler: MainScheduler.instance)
      .subscribe(onCompleted: { [weak self] in
        self?.dismiss(animated: true, completion: nil)
        _ = self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }

  // MARK: UICollectionView

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let asset = photos.object(at: indexPath.item)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCell

    cell.representedAssetIdentifier = asset.localIdentifier
    imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
      if cell.representedAssetIdentifier == asset.localIdentifier {
        cell.imageView.image = image
      }
    })

    return cell
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let asset = photos.object(at: indexPath.item)

    if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
      cell.flash()
    }
    print("tapped", asset)

    imageManager.requestImage(for: asset, targetSize: view.frame.size, contentMode: .aspectFill, options: nil, resultHandler: { [weak self] image, info in
      guard let image = image, let info = info else { return }
      
      // info dictionary를 통해 이미지가 썸네일인지 원본인지 확인
      print("image:", image)
      print("info:", info)
      if let isThumbnail = info[PHImageResultIsDegradedKey as NSString] as? Bool, !isThumbnail {
        print("isThumbnail: \(isThumbnail)")
        self?.selectedPhotosSubject.onNext(image)
      }
    })
  }
}
