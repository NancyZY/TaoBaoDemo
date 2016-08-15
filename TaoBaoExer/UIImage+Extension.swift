//
//  UIImage+Extension.swift
//  TaoBaoExer
//
//  Created by Nancy's MacbookPro on 8/11/16.
//  Copyright © 2016 Nancy's MacbookPro. All rights reserved.
//

import UIKit

extension UIImage {
    
    public func resizeImage(maxHeight:CGFloat, maxWidth:CGFloat, compression:CGFloat)->NSData? {
        
        var actualHeight = self.size.height
        var actualWidth = self.size.width
        var imgRatio = actualWidth/actualHeight
        let maxRatio = maxWidth/maxHeight
        
        if actualHeight > maxHeight || actualWidth > maxWidth
        {
            if imgRatio < maxRatio
            {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if(imgRatio > maxRatio)
            {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else
            {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let rect = CGRectMake(0, 0, actualWidth, actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.drawInRect(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(image, compression)
        UIGraphicsEndImageContext()
        
        return imageData! as NSData
        
    }
    
    
}