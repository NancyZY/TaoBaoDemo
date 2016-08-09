//
//  ViewController.swift
//  TaoBaoExer
//
//  Created by Nancy's MacbookPro on 8/3/16.
//  Copyright © 2016 Nancy's MacbookPro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, ScancodeDelegate {
    @IBOutlet weak var galleryScrollView: UIScrollView!
    @IBOutlet weak var galleryPageControl: UIPageControl!
    @IBOutlet weak var hotTopContainerView: UIView!
    
    @IBOutlet weak var scrollViewHegihtConstraint: NSLayoutConstraint!
    
    var timer:NSTimer!
    var currentPage = 0
    
    
    var hotTopicView1: BannerView!
    var hotTopicView2: BannerView!
    var hotTopicViews = [BannerView]()
    
    
    let upOrigin = CGPointMake(0, 0)
    let downOrigin = CGPointMake(0, 60)
    
    /// 好物
    var goodSomethingBtn = UIButton()
    /// 搜索
    var searchBtn = UIButton()
    /// 种草
    var plantGrassBtn = UIButton()
    /// 签到
    var signInBtn = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pictureGallery()
        addTimer()
        
        initBanner()
        self.createFourButton()
    }
    
    func initBanner(){
        hotTopicView1 = NSBundle.mainBundle().loadNibNamed("BannerView", owner: nil, options: nil).first as! BannerView
        hotTopicView1.frame.origin = upOrigin
        hotTopicView1.content1Label.text = "1.学生收无效毕业证"
        hotTopicView1.content2Label.text = "2.中国游客被扔石头"
        
        hotTopicView2 = NSBundle.mainBundle().loadNibNamed("BannerView", owner: nil, options: nil).first as! BannerView
        hotTopicView2.frame.origin = downOrigin
        hotTopicView2.content1Label.text = "3.吴秀波娇妻曝光"
        hotTopicView2.content2Label.text = "4.澳洲记者抹黑孙杨"
        
        hotTopContainerView.addSubview(hotTopicView1)
        hotTopContainerView.addSubview(hotTopicView2)
        
        hotTopicViews.append(hotTopicView1)
        hotTopicViews.append(hotTopicView2)
        scrollHotTopics()
    }
    
    func scrollHotTopics() {
        UIView.animateWithDuration(2.0, animations: {
            self.hotTopicViews[0].frame.origin = CGPointMake(0, -60)
            self.hotTopicViews[1].frame.origin = CGPointMake(0, 0)
        }) { (_) in
            self.hotTopicViews.append(self.hotTopicViews[0])
            self.hotTopicViews[2].frame.origin = CGPointMake(0, 60)
            self.hotTopicViews.removeAtIndex(0)
            
            self.scrollHotTopics()
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addTimer(){   //图片轮播的定时器；
         // 构造一个定时器,每隔5秒调用.这个操作会重复执行
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "nextImage:", userInfo: nil, repeats: true);
    }
    
    func removeTimer() {
        // 让定时器不可用
        timer.invalidate()
    }
    
    
    // 4. 实现UIScrollView的代理方法
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / self.view.frame.width)
        galleryPageControl.currentPage = currentPage
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }

    
    
    func pictureGallery(){   //实现图片滚动播放；
        let width = self.view.frame.width
        let height = width / 32.0 * 13
        
        galleryScrollView.delegate = self;
        scrollViewHegihtConstraint.constant = height
        
         for index in 1...3 {
            let imageView = UIImageView(frame: CGRectMake(width * CGFloat(index-1), 0, width, height))
            imageView.image = UIImage(named: "gallery\(index)");
            galleryScrollView.addSubview(imageView)
        }
    }
    
    //呈现下一个广告
    func nextImage(sender:AnyObject!){
        var page:Int = self.galleryPageControl.currentPage;
        if(page == 2){   //循环；
            page = 0;
        }else{
            page += 1;
        }
        
        galleryPageControl.currentPage = page
        let x:CGFloat = CGFloat(page) * self.galleryScrollView.frame.size.width;
        self.galleryScrollView.contentOffset = CGPointMake(x, 0);//注意：contentOffset就是设置ScrollView的偏移；
    }
    
    
    func createFourButton()
    {

        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the destination view controller
        if segue.identifier == "scanSegue"{
            let barcodeViewController = segue.destinationViewController as! ScanViewController
//            barcodeViewController.delegate = self
        }
        
    }
    
    
    func barcodeReaded(barcode: String) {
        print("Barcode leido: \(barcode)")
    }
}

