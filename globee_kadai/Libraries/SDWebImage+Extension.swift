//
//  SDWebImage+Extension.swift
//
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
    
    typealias Completion = (Result<CompletionSuccess, Error>) -> Void
    struct CompletionSuccess {
        let image: UIImage
        let cacheType: SDImageCacheType
        let url: URL
    }
    
    /**
     # SDWebImage のラッパーメソッド
     
     ## 次の条件を一つでも満たす場合は .image には nil が入る.
     - URL文字列が無効
     - URLが無効
     - エラー発生
     
     - parameter url: URL文字列
     */
    func sd_setImageWithFadeIn(url: String?, completion: Completion? = nil) {
        guard let urlString = url else {
            image = nil
            return
        }
        guard let url = URL(string: urlString) else {
            image = nil
            return
        }
        
        let options: SDWebImageOptions = [.retryFailed, .lowPriority]
        sd_setImage(with: url, placeholderImage: nil, options: options) { [weak self] (image, error, cacheType, _) in
            guard let self = self else { return }
            
            let result: Result<CompletionSuccess, Error>
            
            if let error = error {
                self.image = nil
                result = .failure(error)
                
            } else {
                result = .success(.init(image: image!, cacheType: cacheType, url: url))
            }
            
            if cacheType != .memory {
                let options: UIView.AnimationOptions = [
                    .transitionCrossDissolve,
                    .curveLinear,
                    .allowUserInteraction
                ]
                UIView.transition(with: self, duration: 0.28, options: options, animations: nil, completion: nil)
            }
            
            completion?(result)
        }
    }
}
