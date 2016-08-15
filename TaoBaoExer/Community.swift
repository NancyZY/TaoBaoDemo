//
//  Community.swift
//  TaoBaoExer
//
//  Created by Nancy's MacbookPro on 8/10/16.
//  Copyright © 2016 Nancy's MacbookPro. All rights reserved.
//

import UIKit
import RichEditorView

class Communtiry: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var editorView: RichEditorView!
//    @IBOutlet var htmlTextView: UITextView!
    
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorOptions.all()
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editorView.setPlaceholderText("Enter Text")
        editorView.delegate = self
        editorView.inputAccessoryView = toolbar
        
        toolbar.delegate = self
        toolbar.editor = editorView
        
        imagePicker.delegate = self
        
        // We will create a custom action that clears all the input text when it is pressed
        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar?.editor?.setHTML("")
        }
        
        var options = toolbar.options
        options.append(item)
        toolbar.options = options
    }
    
}

extension Communtiry: RichEditorDelegate {
    
    func richEditor(editor: RichEditorView, heightDidChange height: Int) { }
    
    func richEditor(editor: RichEditorView, contentDidChange content: String) {
//        if content.isEmpty {
//            htmlTextView.text = "HTML Preview"
//        } else {
//            htmlTextView.text = content
//        }
    }
    
    func richEditorTookFocus(editor: RichEditorView) { }
    
    func richEditorLostFocus(editor: RichEditorView) { }
    
    func richEditorDidLoad(editor: RichEditorView) { }
    
    func richEditor(editor: RichEditorView, shouldInteractWithURL url: NSURL) -> Bool { return true }
    
    func richEditor(editor: RichEditorView, handleCustomAction content: String) { }
    
}

extension UIImage{
    class func resizeImage(image: UIImage, imageLength: CGFloat) -> CGSize {
        
        var newWidth:CGFloat = 0.0
        var newHeight:CGFloat = 0.0
        let width = image.size.width
        let height = image.size.height
        
        if (width > imageLength || height > imageLength){
            
            if (width > height) {
                
                newWidth = imageLength;
                newHeight = newWidth * height / width;
                
            }else if(height > width){
                
                newHeight = imageLength;
                newWidth = newHeight * width / height;
                
            }else{
                
                newWidth = imageLength;
                newHeight = imageLength;
            }
            
        }
        return CGSize(width: newWidth, height: newHeight)
    }
}

extension Communtiry: RichEditorToolbarDelegate {
    
    private func randomColor() -> UIColor {
        let colors = [
            UIColor.redColor(),
            UIColor.orangeColor(),
            UIColor.yellowColor(),
            UIColor.greenColor(),
            UIColor.blueColor(),
            UIColor.purpleColor()
        ]
        
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }
    
    func richEditorToolbarChangeTextColor(toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }
    
    func richEditorToolbarChangeBackgroundColor(toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }
    
    func richEditorToolbarInsertImage(toolbar: RichEditorToolbar) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func richEditorToolbarInsertLink(toolbar: RichEditorToolbar) {
        // Can only add links to selected text, so make sure there is a range selection first
        if let hasSelection = toolbar.editor?.rangeSelectionExists() where hasSelection {
            toolbar.editor?.insertLink("http://github.com/cjwirth/RichEditorView", title: "Github Link")
        }
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("first if....")
            if let imageData = pickedImage.resizeImage(200.0, maxWidth:300.0, compression:0.7) {
                print("second if....")
                let filename = NSUUID().UUIDString + ".jpg"
                let path = getDocumentsURL()
                let fileURL = path.URLByAppendingPathComponent(filename)
                do {
                    try imageData.writeToURL(fileURL, options: NSDataWritingOptions.DataWritingAtomic)
                }
                catch let error as NSError  {
                    print(error)
                }
                self.toolbar.editor?.insertImage(fileURL.absoluteString, alt: "new image")
                dismissViewControllerAnimated(true, completion: {
                    print("file url abs string \(fileURL.absoluteString)")
                })
            }
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    
}