//
//  HamburgerViewController.swift
//  twitter
//
//  Created by christopher ketant on 11/5/16.
//  Copyright © 2016 christopherketant. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    var originalLeftMargin: CGFloat!
    var menuViewController: UIViewController! {
        didSet {
            self.view.layoutIfNeeded()
            self.menuView.addSubview(self.menuViewController.view)
        }
    }
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            self.view.layoutIfNeeded()
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: self)
                oldContentViewController.removeFromParentViewController()
                oldContentViewController.didMove(toParentViewController: self)
            }
            self.contentViewController.willMove(toParentViewController: self)
            self.contentView.addSubview(self.contentViewController.view)
            self.contentViewController.didMove(toParentViewController: self)
            UIView.animate(withDuration: 0.3, animations: {
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let velocity = sender.velocity(in: self.view)
        
        if sender.state == UIGestureRecognizerState.began {
            self.originalLeftMargin = self.leftMarginConstraint.constant
        } else if sender.state == UIGestureRecognizerState.changed {
            self.leftMarginConstraint.constant = self.originalLeftMargin + translation.x
        } else if sender.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.3, animations: { 
                if velocity.x < 0 {
                    self.leftMarginConstraint.constant = 0
                }else{
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 50
                }
                self.view.layoutIfNeeded()
            })
        }
    }
}
