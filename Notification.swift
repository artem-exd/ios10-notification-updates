//
//  Notification.swift
//  NotificationsUI
//
//  Created by Artem Sherbachuk (UKRAINE) on 10/23/16.
//  Copyright © 2016 Pranjal Satija. All rights reserved.
//

import UserNotifications

class Notification: NSObject {
    
    private let center = UNUserNotificationCenter.current()

    init(authorizationCompletion: @escaping (Bool, Error?) -> Void) {
        super.init()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            authorizationCompletion(granted, error)
        }
        
        let action = UNNotificationAction(identifier: "remindLater", title: "Remind Later",
                                          options: [])
        let category = UNNotificationCategory(identifier: "myCategory", actions: [action],
                                              intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
        center.delegate = self
    }
    
    func scheduleNotificationAt(date: Date) {
        let calendar = Calendar(identifier: .gregorian)
        let dateComponent = calendar.dateComponents(in: .current, from: date)
        let newComponent = DateComponents(calendar: calendar, timeZone: .current, month: dateComponent.month, day: dateComponent.day, hour: dateComponent.hour, minute: dateComponent.minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponent, repeats: true)
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Notification Content"
        notificationContent.body = "This is notification content form class UNMutableNotificationContent"
        notificationContent.sound = UNNotificationSound.default()
        notificationContent.categoryIdentifier = "myCategory"
        
        if let path = Bundle.main.path(forResource: "logo", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
                notificationContent.attachments = [attachment]
            } catch {
                print("The attachment was not loaded.")
            }
        }
        
        let request = UNNotificationRequest(identifier: "demoNotification",
                                            content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                fatalError("UNUserNotificationCenter.current().add(request) error: \(error)")
            }
        }
    }
}

extension Notification: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "remindLater" {
            let newDate = Date(timeInterval: 900, since: Date())
            scheduleNotificationAt(date: newDate)
        }
    }
}
