//
//  MailboxViewController.swift
//  10.10 Homework - Mailbox v.1
//
//  Created by Becker, Kathrine V on 10/10/16.
//  Copyright © 2016 Becker, Kathrine V. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var bgColorView: UIView!
    @IBOutlet weak var rescheduleIconView: UIImageView!
    @IBOutlet weak var listIconView: UIImageView!
    @IBOutlet weak var archiveIconView: UIImageView!
    @IBOutlet weak var deleteIconView: UIImageView!
    @IBOutlet weak var reschedulePageView: UIImageView!
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var listPageView: UIImageView!
    
    
    var messageOriginalCenter: CGPoint!
    var rescheduleIconOriginalCenter: CGPoint!
    var initialY: CGFloat!
    var offset: CGFloat!
    
    let grayColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
    let yellowColor = UIColor(red: 255/255.0, green: 195/255.0, blue: 0/255.0, alpha: 1.0)
    let greenColor = UIColor(red: 56/255.0, green: 142/255.0, blue: 60/255.0, alpha: 1.0)
    let redColor = UIColor(red: 198/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0)
    let brownColor = UIColor(red: 150/255.0, green: 100/255.0, blue: 10/255.0, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 375, height: 1700)
        reschedulePageView.alpha = 0
        listPageView.alpha = 0
        initialY = feedView.frame.origin.y
        offset = -94

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanMessage(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        print("translation = \(translation.x)")
        listIconView.alpha = 0
        deleteIconView.alpha = 0
        
        
        
// PANNING MESSAGE TO THE LEFT
        // BEGAN
        if sender.state == .began {
            print("Gesture began")
            messageOriginalCenter = messageView.center
            self.bgColorView.backgroundColor = self.grayColor
            
        // CHANGED
        } else if sender.state == .changed {
            print("Gesture is changing")
            messageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            
            // making reschedule icon semi-opaque, then fully opaque
            if translation.x > -30 {
                self.rescheduleIconView.alpha = 0.5
            } else if translation.x < -40  {
                self.rescheduleIconView.alpha = 1
            }
            
            
            if translation.x < -260 {
                self.bgColorView.backgroundColor = self.brownColor
                rescheduleIconView.alpha = 0
                print("reschedule icon view alpha = 0")
                listIconView.alpha = 1
            
            } else if translation.x < -60 {
                self.bgColorView.backgroundColor = self.yellowColor
                rescheduleIconView.center.x = messageView.frame.origin.x + messageView.frame.size.width + 35
                
            
// PANNING MESSAGE TO THE RIGHT
            } else if translation.x > 260 {
                self.bgColorView.backgroundColor = self.redColor
                archiveIconView.alpha = 0
                rescheduleIconView.alpha = 0
                deleteIconView.alpha = 1
            } else if translation.x > 60 {
                self.rescheduleIconView.alpha = 0
                self.bgColorView.backgroundColor = self.greenColor
                archiveIconView.center.x = messageView.frame.origin.x - 40
            }
            
            // making archive icon semi-opaque, then fully opaque
            if translation.x < 40 {
                self.archiveIconView.alpha = 0.5
            } else if translation.x < 50 {
                self.archiveIconView.alpha = 1
            }
            
        // ENDED
        } else if sender.state == .ended {
            print("Gesture ended")
            let velocity = sender.velocity(in: view)
            self.rescheduleIconView.alpha = 0
            self.archiveIconView.alpha = 0
            self.listIconView.alpha = 0
            self.deleteIconView.alpha = 0
            
            if translation.x < -260 {
                // message disappears, background stays BROWN, 'list' page appears
                messageView.alpha = 0
                listPageView.alpha = 1
                
            } else if translation.x < -60 {
                // message disappears, background stays YELLOW, 'reschedule' page appears
                messageView.alpha = 0
                reschedulePageView.alpha = 1
             
                // MESSAGE BEING DELETED
            } else if translation.x > 260 {
                messageView.alpha = 0
                UIView.animate(withDuration: 0.7, animations: { self.feedView.frame.origin.y = self.initialY + self.offset
            })
                
               // MESSAGE BEING ARCHIVED
            } else if translation.x > 60 {
                messageView.alpha = 0
                UIView.animate(withDuration: 0.7, animations: { self.feedView.frame.origin.y = self.initialY + self.offset
                })
                
            //ANIMATE BACK
            } else if velocity.x < 0 {
                self.bgColorView.backgroundColor = self.grayColor
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                    self.messageView.center = self.messageOriginalCenter}, completion: nil)
                
            } else if velocity.x > 0 {
                self.bgColorView.backgroundColor = self.grayColor
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                    self.messageView.center = self.messageOriginalCenter}, completion: nil)
            }
        }
    }

    @IBAction func didTapReschedulePage(_ sender: UITapGestureRecognizer) {
        print("tapped the reschedule page to dismiss")
        self.reschedulePageView.alpha = 0
        
        UIView.animate(withDuration: 0.7, animations: { self.feedView.frame.origin.y = self.initialY + self.offset
        })
    }
    
    @IBAction func didTapListPage(_ sender: UITapGestureRecognizer) {
        print("tapped the TAP LIST page")
        self.listPageView.alpha = 0
        
        UIView.animate(withDuration: 0.7, animations: {
                self.feedView.frame.origin.y = self.initialY + self.offset
        })
    }
    
        
    @IBAction func didTapReset(_ sender: UITapGestureRecognizer) {
        print("did tap reset")
        self.feedView.frame.origin.y = self.initialY
        self.messageView.alpha = 1
        self.messageView.center = self.messageOriginalCenter
        //self.rescheduleIconView.alpha = 1
        //self.archiveIconView.alpha = 1
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
