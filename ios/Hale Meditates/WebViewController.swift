
//
//  WebViewController.swift
//
//  Created by Ryan Pillsbury on 7/5/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import UIKit
import MediaPlayer

class WebViewController: UIViewController, UIWebViewDelegate, UIGestureRecognizerDelegate, UINavigationBarDelegate, ScrollViewListener {
    
    var url: NSURL?
    var request: NSURLRequest?
    

    @IBOutlet weak var webView: WebView!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self;
        self.webView.scrollViewDelegate = self;
        if (url != nil) {
            request = NSURLRequest(URL: url!);
            webView.loadRequest(request!);
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapGesture.delegate = self;
        
        self.webView.addGestureRecognizer(tapGesture);
        let navitem = UINavigationItem();
        let _ = UIButton(type: UIButtonType.Custom)
        navBar.pushNavigationItem(navitem, animated: false);
        
        self.navigationItem.title = "";
        navBar.pushNavigationItem(self.navigationItem, animated: false);
        navBar.tintColor = UIColor.blackColor();
        navBar.delegate = self;
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        timer?.invalidate();
        showNavBar();
        scheduleNavigationBarToHide();
    }
    
    func scrolled() {
        self.hideNavBar();
    }
    
    func navigationBar(navigationBar: UINavigationBar, shouldPopItem item: UINavigationItem) -> Bool {
        self.dismissViewControllerAnimated(true, completion: nil);
        return false;
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (otherGestureRecognizer is UITapGestureRecognizer) {
            let tapRecognizer = (otherGestureRecognizer as! UITapGestureRecognizer)
        }
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.loaderView.stopAnimating();
        scheduleNavigationBarToHide();
    }
    
    func scheduleNavigationBarToHide() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "hideNavBar:", userInfo: nil, repeats: false);
    }
    
    func hideNavBar(timer: NSTimer) {
        self.hideNavBar();
    }
    
    func showNavBar() {
        if (self.navBar.frame.origin.y < 0 ) {
            UIView.animateWithDuration(0.4, animations: ({
                self.navBar.frame = CGRectMake(0, 0, self.navBar.frame.width, self.navBar.frame.height)
            }));
        }
    }
    
    func hideNavBar() {
        if (self.navBar.frame.origin.y >= 0 ) {
            UIView.animateWithDuration(0.4, animations: ({
                self.navBar.frame = CGRectMake(0, -self.navBar.frame.height, self.navBar.frame.width, self.navBar.frame.height)
            }));
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        loaderView.startAnimating();
    }
    
    
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

protocol ScrollViewListener {
    //    func startedScrolling(to: CGFloat, from: CGFloat);
    func scrolled()
}

class WebView: UIWebView {
    var lastOffSetY: CGFloat = 0;
    var scrollViewDelegate: ScrollViewListener?
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView);
        self.scrollViewDelegate?.scrolled();
    }
}