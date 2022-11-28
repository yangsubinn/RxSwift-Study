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

import Foundation
import UIKit
import Photos

import RxSwift

class PhotoWriter {
  enum Errors: Error {
    case couldNotSavePhoto
  }
  
  // MARK: - Custom Observable
  // 사진 저장 후 생성된 하나의 요소를 방출
//  static func save(_ image: UIImage) -> Observable<String> {
//    print("PhotoWriter.save")
//    return Observable.create { observer in
//      var savedAssetId: String?
//      PHPhotoLibrary.shared().performChanges ({
//        let request = PHAssetChangeRequest.creationRequestForAsset(from: image) // asset으로 만들어달라는 요청에 따라 image를 생성
//        // 생성한 이미지 에셋 기기에 저장
//        savedAssetId = request.placeholderForCreatedAsset?.localIdentifier
//      }, completionHandler: { success, error in
//        DispatchQueue.main.async {
//          // 저장에 성공한 경우 id 값을 넘겨주고 complete
//          if success, let id = savedAssetId {
//            observer.onNext(id)
//            observer.onCompleted()
//          } else {
//            observer.onError(error ?? Errors.couldNotSavePhoto)
//          }
//        }
//      })
//
//      // create의 리턴 값으로 Disposable이 리턴되도록
//      return Disposables.create()
//    }
//  }
  
  // MARK: - Single
  static func save(_ image: UIImage) -> Single<String> {
    return Single.create { observer in
      var savedAssetId: String?
      PHPhotoLibrary.shared().performChanges ({
        let request = PHAssetChangeRequest.creationRequestForAsset(from: image) // asset으로 만들어달라는 요청에 따라 image를 생성
        // 생성한 이미지 에셋 기기에 저장
        savedAssetId = request.placeholderForCreatedAsset?.localIdentifier
      }, completionHandler: { success, error in
        DispatchQueue.main.async {
          // 저장에 성공한 경우 id 값을 넘겨주고 complete
          if success, let id = savedAssetId {
//            observer.onNext(id)
//            observer.onCompleted()
            observer(.success(id))
          } else {
//            observer.onError(error ?? Errors.couldNotSavePhoto)
            observer(.error(error ?? Errors.couldNotSavePhoto))
          }
        }
      })
      
      // create의 리턴 값으로 Disposable이 리턴되도록
      return Disposables.create()
    }
  }

}
