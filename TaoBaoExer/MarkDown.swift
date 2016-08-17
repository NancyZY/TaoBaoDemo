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
    
    
    var undoItem : UIBarButtonItem!
    
    var flexableSpaceItem : UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    }
    
    var redoItem : UIBarButtonItem!
    
    var secondFlexableSpaceItem : UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    }
    
    var geishaItem : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originText.text = "enter something..."
        originText.delegate = self
        
        undoItem = UIBarButtonItem(image:UIImage(named:"undo"), style: .Done, target: self, action: "clickCenter:")
        
        redoItem = UIBarButtonItem(image:UIImage(named:"redo"), style: UIBarButtonItemStyle.Plain, target: self, action: "clickCenter:")
        
        geishaItem = UIBarButtonItem(image:UIImage(named:"geisha"), style: .Done, target: self, action: "clickCenter:")
        
        undoItem.tag = 101
        redoItem.tag = 102
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
            undoItem,
            flexableSpaceItem,
            redoItem,
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
        case 101:
            // 加粗
            originText.typingAttributes[NSObliquenessAttributeName] = (originText.typingAttributes[NSObliquenessAttributeName] as? NSNumber) == 0 ? 0.5 : 0
            break
        case 102:
            // 加下划线
           originText.typingAttributes[NSUnderlineStyleAttributeName] =  (NSUnderlineStyle.StyleSingle.hashValue ) == 0 ? 1 : NSUnderlineStyle.StyleSingle.hashValue
            break
        case 103:
            // 弹出 UIMenuController
            quickJumpClicked(barItem)
            break
        case 4:
            print("签到")
            break
        default :
            break
        }
    }
    
    func quickJumpClicked(sender: AnyObject){
        // 1. 成为第一响应者
        self.becomeFirstResponder()
        
        // 2. 获取菜单
        let menu = UIMenuController.sharedMenuController()
        
        // 3. 设置自定义菜单
        menu.menuItems = [ UIMenuItem.init(title: "呵呵哒", action: Selector.init("heHeDa:")) ]
        
        // 4. 菜单显示位置
        menu.setTargetRect(sender.view!.bounds, inView: self.view)
        
        // 5. 显示菜单
        menu.setMenuVisible(true, animated: true)
    }
    
    func heHeDa(menu :UIMenuController )
    {
        print("测试方法而已, 呵呵哒")
    }
    
    //MARK: 让Lable具备成为第一响应者的资格
    override func canBecomeFirstResponder() -> Bool
    {
        return true
    }
    
    //MARK: 返回悬浮菜单中可以显示的选项
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool
    {
        // 判断 action 中包含的各个事件的方法名称, 对比上了才能显示
        if (action == Selector.init("copy:") || action == Selector.init("heHeDa:"))
        {
            return true
        }
        return false
    }
}