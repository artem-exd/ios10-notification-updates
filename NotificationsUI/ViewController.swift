//
//  ViewController.swift
//  NotificationsUI
//
//  Created by Pranjal Satija on 9/12/16.
//  Copyright © 2016 Pranjal Satija. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var notification: Notification!
    
    override func viewDidLoad() {
        self.notification = Notification { granted, error in
            if !granted {
                print("Notification not granted!")
            }
        }
    }
    
    @IBAction func datePickerDidSelectNewDate(_ sender: UIDatePicker) {
        notification.scheduleNotificationAt(date: sender.date)
    }
}
