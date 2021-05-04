//
//  NotificationService.swift
//  ExampleNotificationServiceExtension
//
//  Created by Andy Keller on 4/20/21.
//  Copyright © 2021 theoremreach. All rights reserved.
//

import UserNotifications
import UserWiseSDK
import UIKit

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        if let bestAttemptContent = bestAttemptContent {
            let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
            
            let userWise = UserWise.sharedInstance
            userWise.debugMode = true
            userWise.hostOverride = URL(string: "https://staging.userwise.io")
            userWise.setApiKey("f1535363ad9ab340ebc9786337b0")
            
            dump(bestAttemptContent.userInfo)
            let imageId = bestAttemptContent.userInfo["imageId"] as? String

            if let imageId = imageId {
                let handler = ExampleMediaDelegate(semaphore: semaphore, withContentHandler: contentHandler, bestAttemptContent: bestAttemptContent)
                userWise.loadBitMapFrom(mediaId: imageId, ignoreCache: true, handler: handler)
                semaphore.wait()
                contentHandler(bestAttemptContent)
            }
            else {
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}


class ExampleMediaDelegate : UserWiseMediaRawDataHandler {
    var contentHandler: ((UNNotificationContent) -> Void)
    var bestAttemptContent: UNMutableNotificationContent
    var semaphore: DispatchSemaphore

    init(semaphore: DispatchSemaphore, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void, bestAttemptContent: UNMutableNotificationContent) {
        self.contentHandler = contentHandler
        self.bestAttemptContent = bestAttemptContent
        self.semaphore = semaphore
    }

    func onMediaDownloadSuccess(data: Data) {
            // Modify the notification content here...
        bestAttemptContent.title = "\(bestAttemptContent.title) [success]"
        
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let imageFileIdentifier = "temp.jpg"

            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            let image = UIImage(data: data)
            try? image?.pngData()?.write(to: fileURL)


            if let attachment = try? UNNotificationAttachment(identifier: "attachment", url: fileURL, options: nil) {
                bestAttemptContent.attachments = [ attachment ]
            }

        } catch {
            print("error " + error.localizedDescription)
        }
        
        semaphore.signal()
    }
    
    func onMediaDownloadFailure() {
            // Modify the notification content here...
        bestAttemptContent.title = "\(bestAttemptContent.title) [failure]"
        semaphore.signal()
    }
}
