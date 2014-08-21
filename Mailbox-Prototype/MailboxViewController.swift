//
//  MailboxViewController.swift
//  Mailbox-Prototype
//
//  Created by Daniel Eden on 8/20/14.
//  Copyright (c) 2014 Daniel Eden. All rights reserved.
//

import UIKit

class MailboxViewController: ViewController {


    /*
    // MARK: - Variables
    */
    
    // Declare views
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var singleMessageView: UIView!
    
    // Image Views
    @IBOutlet weak var leftIconImageView: UIImageView!
    @IBOutlet weak var rightIconImageView: UIImageView!
    @IBOutlet weak var singleMessageImageView: UIImageView!
    
    // Declare gestures
    @IBOutlet var topViewTapGesture: UITapGestureRecognizer!
    @IBOutlet var topViewPanGesture: UIPanGestureRecognizer!
    @IBOutlet var messageViewPanGesture: UIPanGestureRecognizer!
    
    // Set up global vars
    var topViewPosition: CGFloat!
    var messagePosition: CGFloat!
    var edgeSwipeRecogniser: UIScreenEdgePanGestureRecognizer!
    
    
    /*
    // MARK: - Initialisation
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        topViewPosition = topView.frame.origin.x
        messagePosition = singleMessageImageView.center.x
        
        // Set a shadow for our topView
        topView.layer.shadowOffset = CGSizeMake(0, 0)
        topView.layer.shadowRadius = 10
        topView.layer.shadowOpacity = 0.75
        
        // Set up our edge swipe gesture recogniser
        var edgeSwipeRecogniser = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgeSwipeGesture:")
        edgeSwipeRecogniser.edges = UIRectEdge.Left
        view.addGestureRecognizer(edgeSwipeRecogniser)
        
        var messagePanRecogniser = UIPanGestureRecognizer(target: self, action: "onMessagePan:")
        view.addGestureRecognizer(messagePanRecogniser)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Buttons
    */
    
    // Toggle the menu when tapping the menu button
    @IBAction func onMenuButtonPress(sender: AnyObject) {
        if(topView.frame.origin.x == topViewPosition) {
            UIView.animateWithDuration(0.3, animations: {
                self.topView.frame.origin.x += 284
            })
            topViewTapGesture.enabled = true
            topViewPanGesture.enabled = true
        } else {
            var gesture = UIGestureRecognizer()
            onTopViewTap(gesture)
        }
    }

    
    /*
    // MARK: - Gestures
    */
    
    // Reveal menu when swiping entire view from screen edge
    // This gesture is disabled when menu is opened
    func onEdgeSwipeGesture(gesture: UIScreenEdgePanGestureRecognizer) {
        var point = gesture.locationInView(view)
        
        if gesture.state == UIGestureRecognizerState.Began {
            
            
        } else if gesture.state == UIGestureRecognizerState.Changed {
            
            self.topView.frame.origin.x = self.topViewPosition + point.x
            
        } else if gesture.state == UIGestureRecognizerState.Ended {

            if(point.x > 100) {
                UIView.animateWithDuration(0.3, animations: {
                    self.topView.frame.origin.x = 284
                })
                topViewTapGesture.enabled = true
                topViewPanGesture.enabled = true
            } else {
                onTopViewTap(gesture)
            }
            
        }
    }

    // Close menu when panning the feed view
    // This gesture is disabled when the menu is closed
    @IBAction func onTopViewPan(gesture: UIPanGestureRecognizer) {
        var point = gesture.locationInView(view)
        var velocity = gesture.velocityInView(view)
        
        if gesture.state == UIGestureRecognizerState.Began {
            
            
        } else if gesture.state == UIGestureRecognizerState.Changed {
            
            self.topView.frame.origin.x = self.topViewPosition + point.x
            
        } else if gesture.state == UIGestureRecognizerState.Ended {
            
            UIView.animateWithDuration(0.3, animations: {
                self.topView.frame.origin.x = self.topViewPosition
            })
            topViewTapGesture.enabled = false
            topViewPanGesture.enabled = false
            
        }
    }
    
    // Message pan gesture
    @IBAction func onMessagePan(gesture: UIPanGestureRecognizer) {
        var point = gesture.locationInView(view)
        var transform = gesture.translationInView(view)
        
        if gesture.state == UIGestureRecognizerState.Began {
            
            
        } else if gesture.state == UIGestureRecognizerState.Changed {
            
            self.singleMessageImageView.center.x = self.messagePosition + transform.x
            
        } else if gesture.state == UIGestureRecognizerState.Ended {
            
            UIView.animateWithDuration(0.4,
                delay: 0,
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 15,
                options: nil,
                animations: {
                    self.singleMessageImageView.center.x = self.messagePosition
                },
                completion: nil)
            
        }
    }
    
    
    /*
    // MARK: - Global Functions
    */
    
    // Close menu when tapping on the feed view
    // This gesture is disabled when the menu is closed
    // This function is also called as a global menu "reset"
    @IBAction func onTopViewTap(sender: UIGestureRecognizer) {
        UIView.animateWithDuration(0.3, animations: {
            self.topView.frame.origin.x = self.topViewPosition
        })
        topViewTapGesture.enabled = false
        topViewPanGesture.enabled = false
    }

}
