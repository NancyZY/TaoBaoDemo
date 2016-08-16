//
//  MarkDown.swift
//  TaoBaoExer
//
//  Created by Nancy's MacbookPro on 8/11/16.
//  Copyright © 2016 Nancy's MacbookPro. All rights reserved.
//

import UIKit
import SwiftyDown
import RichEditorView

class MarkDown: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var markText: UITextView!
    @IBOutlet weak var originText: UITextView!
    
    
    var trashItem : UIBarButtonItem!
    
    var flexableSpaceItem : UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    }
    
    var doneSpaceItem : UIBarButtonItem!
    
    var secondFlexableSpaceItem : UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    }
    
    var geishaItem : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originText.text = "enter something..."
        originText.delegate = self
        
        trashItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "clickCenter:")
        
        doneSpaceItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "clickCenter:")
        
        geishaItem = UIBarButtonItem(image:UIImage(named:"geisha"), style: .Done, target: self, action: "clickCenter:")
        
        trashItem.tag = 101
        doneSpaceItem.tag = 102
        geishaItem.tag = 103
        
        configToolBar()
    }
    
   //MARK UITextViewDelegate
     func textViewDidChange(textView: UITextView){
        let str = originText.text
        let m = MarkdownParser()
        
        markText.attributedText = m.convert(str)

    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if textView.text == "enter something..."{
            textView.text = "";
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.characters.count < 1{
            textView.text = "enter something..."
        }
    }
    
    func configToolBar(){
//        self.navigationController?.toolbarHidden = false
//        let items = [
//            trashItem        ]
//       self.navigationController?.toolbar.setItems(items, animated: true)
        
        let numberToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        numberToolbar.barStyle = UIBarStyle.Default
        numberToolbar.items = [
            trashItem,
            flexableSpaceItem,
            doneSpaceItem,
            secondFlexableSpaceItem,
            geishaItem
            ]
        numberToolbar.sizeToFit()
        originText.inputAccessoryView = numberToolbar
    }
    
    func clickCenter(barItem: UIBarButtonItem)
    {
        print (barItem.tag)
        switch barItem.tag {
        case 1:
            print ("GoodSomeThingClickType")
            break
        case 2:
           print("搜索")
            break
        case 3:
            print("种草")
            break
        case 4:
            print("签到")
            break
        default :
            break
        }
    }
}