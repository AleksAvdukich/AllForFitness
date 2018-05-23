//
//  UserNotificationManager.swift
//  AllForFitness
//
//  Created by Aleksandr Avdukich on 23.05.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit
import UserNotifications

class UserNotificationManager {
    
    static let shared = UserNotificationManager()
    
    func registerNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            //handle error
        }
    }
    
    //MARK: - Add Default Notification
    func addNotificationWithTimeIntervalTrigger() {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = "Body"
        //content.badge = 1
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7, repeats: false)
        let request = UNNotificationRequest(identifier: "timeInterval", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            //handle error
        }
    }
    
}


