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
    @IBOutlet weak var feedScrollView: UIScrollView!
    
    // Image Views
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var leftIconImageView: UIImageView!
    @IBOutlet weak var rightIconImageView: UIImageView!
    @IBOutlet weak var singleMessageImageView: UIImageView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    
    // Declare gestures
    var topViewTapGesture: UITapGestureRecognizer!
    var topViewPanGesture: UIPanGestureRecognizer!
    var messageViewPanGesture: UIPanGestureRecognizer!
    var edgePanGesture: UIScreenEdgePanGestureRecognizer!
    var listModalTapGesture: UITapGestureRecognizer!
    var rescheduleModalTapGesture: UITapGestureRecognizer!
    
    // Set up global vars
    var topViewPosition: CGFloat!
    var messagePosition: CGFloat!
    var edgeSwipeRecogniser: UIScreenEdgePanGestureRecognizer!
    
    // Message state variable
    // 0 = Default
    // 1 = Archive
    // 2 = Delete
    // 3 = Later
    // 4 = List
    var state = 0
    
    
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
        
        // Add edge pan gesture
        edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgeSwipeGesture:")
        edgePanGesture.edges = UIRectEdge.Left
        view.addGestureRecognizer(edgePanGesture)
        
        // Add topView tap gesture
        // This is enabled after the menu is displayed
        topViewTapGesture = UITapGestureRecognizer(target: self, action: "onMenuButtonPress:")
        topViewTapGesture.enabled = false
        topView.addGestureRecognizer(topViewTapGesture)
        
        // Add topView pan gesture
        // This is enabled after the menu is displayed
        topViewPanGesture = UIPanGestureRecognizer(target: self, action: "onTopViewPan:")
        topViewPanGesture.enabled = false
        topView.addGestureRecognizer(topViewPanGesture)
        
        // Add messageView pan gesture
        messageViewPanGesture = UIPanGestureRecognizer(target: self, action: "onMessagePan:")
        singleMessageView.addGestureRecognizer(messageViewPanGesture)
        
        listModalTapGesture = UITapGestureRecognizer(target: self, action: "onListModalTap")
        listImageView.addGestureRecognizer(listModalTapGesture)
        
        rescheduleModalTapGesture = UITapGestureRecognizer(target: self, action: "onRescheduleModalTap")
        rescheduleImageView.addGestureRecognizer(rescheduleModalTapGesture)
        
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
    @IBAction func onEdgeSwipeGesture(gesture: UIScreenEdgePanGestureRecognizer) {
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
        
        if gesture.state == UIGestureRecognizerState.Changed {
            
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
        var leftImage = self.leftIconImageView
        var rightImage = self.rightIconImageView
        
        if gesture.state == UIGestureRecognizerState.Changed {
            var color: UIColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
            state = 0
            
            self.singleMessageImageView.center.x = self.messagePosition + transform.x
            
            leftImage.alpha = (transform.x/75) - 0.1
            rightImage.alpha = (-transform.x/75) - 0.1
            
            // Capture color changes
            // Archive
            if self.singleMessageImageView.frame.origin.x > 75 {
                color = UIColor(red: 0.38, green: 0.85, blue: 0.38, alpha: 1)
                leftImage.image = UIImage(named: "archive_icon")
                rightImage.alpha = 0
                state = 1
            }
            
            // Delete
            if self.singleMessageImageView.frame.origin.x > 230 {
               color = UIColor(red: 0.93, green: 0.33, blue: 0.05, alpha: 1)
                leftImage.image = UIImage(named: "delete_icon")
                state = 2
            }
            
            // Defer
            if self.singleMessageImageView.frame.origin.x < -75 {
                color = UIColor(red: 1, green: 0.8, blue: 0, alpha: 1)
                rightImage.image = UIImage(named: "later_icon")
                leftImage.alpha = 0
                state = 3
            }
            
            // List
            if self.singleMessageImageView.frame.origin.x < -230 {
                color = UIColor(red: 0.84, green: 0.65, blue: 0.45, alpha: 1)
                rightImage.image = UIImage(named: "list_icon")
                state = 4
            }
            
            // Set the color
            self.singleMessageView.backgroundColor = color
            
            // Capture image transformations
            if transform.x > 75 {
                leftImage.frame.origin.x = (25 + transform.x) - 75
            } else {
                leftImage.frame.origin.x = 25
            }
            
            if transform.x < -75 {
                rightImage.frame.origin.x = (275 + transform.x) + 75
            } else {
                rightImage.frame.origin.x = 275
            }
            
        } else if gesture.state == UIGestureRecognizerState.Ended {
            switch state {
            case 1:
                println("Case 1")
                UIView.animateWithDuration(0.5,
                    animations: {
                        self.singleMessageImageView.frame.origin.x += 320
                        leftImage.frame.origin.x += 320
                        leftImage.alpha = 0
                    },
                    completion: { (finished: Bool) in
                        self.dismissMessage()
                })
                
            case 2:
                println("Case 2")
                UIView.animateWithDuration(0.5,
                    animations: {
                        self.singleMessageImageView.frame.origin.x += 320
                        leftImage.frame.origin.x += 320
                        leftImage.alpha = 0
                    },
                    completion: { (finished: Bool) in
                        self.dismissMessage()
                })
                
            case 3:
                println("Case 3")
                UIView.animateWithDuration(0.4,
                    animations: {
                        self.singleMessageImageView.frame.origin.x -= 320
                        rightImage.frame.origin.x -= 320
                        rightImage.alpha = 0
                    },
                    completion: { (finished: Bool) in
                        self.view.bringSubviewToFront(self.rescheduleImageView)
                        self.rescheduleImageView.hidden = false
                        UIView.animateWithDuration(0.3, animations: {
                            self.rescheduleImageView.alpha = 1.0
                            }, completion: nil)
                })
                
            case 4:
                println("Case 4")
                UIView.animateWithDuration(0.4,
                    animations: {
                        self.singleMessageImageView.frame.origin.x -= 320
                        rightImage.frame.origin.x -= 320
                        rightImage.alpha = 0
                    },
                    completion: { (finished: Bool) in
                        self.view.bringSubviewToFront(self.listImageView)
                        self.listImageView.hidden = false
                        UIView.animateWithDuration(0.3, animations: {
                            self.listImageView.alpha = 1.0
                            }, completion: nil)
                })
                
            default:
                println("Default case")
                UIView.animateWithDuration(0.4,
                    delay: 0,
                    usingSpringWithDamping: 0.6,
                    initialSpringVelocity: 12,
                    options: nil,
                    animations: {
                        self.singleMessageImageView.center.x = self.messagePosition
                    },
                    completion: { (finished: Bool) in
                        leftImage.image = UIImage(named: "archive_icon")
                        rightImage.image = UIImage(named: "later_icon")
                        
                        leftImage.alpha = 1
                        rightImage.alpha = 1
                })
            }
            
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
    
    // Dismiss message
    // This function animates the message out of the view and removes it from the super view
    func dismissMessage() {
        UIView.animateWithDuration(0.4, animations: {
            self.singleMessageView.frame.origin.y -= self.singleMessageView.frame.height
            self.singleMessageView.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
            self.feedImageView.frame.origin.y -= self.singleMessageView.frame.height
            self.feedScrollView.contentSize.height -= self.singleMessageView.frame.height
            }, completion: {(finished: Bool) in
                self.singleMessageView.removeFromSuperview()
        })
    }
    
    func onListModalTap() {
        UIView.animateWithDuration(0.3, animations: {
            self.listImageView.alpha = 0.0
        }) { (finished) -> Void in
            self.listImageView.hidden = true
            self.dismissMessage()
        }
    }
    
    func onRescheduleModalTap() {
        UIView.animateWithDuration(0.3, animations: {
            self.rescheduleImageView.alpha = 0.0
            }) { (finished) -> Void in
                self.rescheduleImageView.hidden = true
                self.dismissMessage()
        }
    }

}
