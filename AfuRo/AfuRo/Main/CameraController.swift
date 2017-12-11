//
//  CameraController.swift
//  AfuRo
//
//  Created by 赤堀　貴一 on 2017/12/08.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation

class CameraController:UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    let errorController = ErrorController()
    
    

    
    func savePicture(_ image : UIImage) {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)),
                                           nil)
    }
    
    @objc func image(_ image: UIImage,
                     didFinishSavingWithError error: NSError!,
                     contextInfo: UnsafeMutableRawPointer) {
        
        if error != nil {
            print(error.code)
            errorController.imageSaveFailed()
        }
    }
    
}
