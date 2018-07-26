//
//  MXSErrorController.swift
//  MXSErrorControl
//
//  Created by Maciej Necki on 14/6/18.
//  Copyright © 2018 MYX Systems. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

public class MXSErrorController {
    
    
    //////////////////////////////
    //MARK: Basic Error Info
    private let systemInformation: String = UIDevice.current.systemName +
                                            UIDevice.current.systemVersion +
                                            UIDevice.current.localizedModel +
                                            UIDevice.current.model +
                                            String(describing: UIDevice.current.orientation)
    private let applicationName: String
    
    
    //////////////////////////////
    //MARK: Custom Error Info
    public var userVisibleTitle: String
    public var userVisibleInformation: String
    public var reportEmail: String
    public var customErrorInformation: String = ""
    
    
    //////////////////////////////
    //Initialisers
    public init(userVisibleTitle: String, userVisibleInformation: String, reportEmail: String, applicationName: String) {
        self.userVisibleTitle = userVisibleTitle
        self.userVisibleInformation = userVisibleInformation
        self.reportEmail = reportEmail
        self.applicationName = applicationName
    }
    
    //////////////////////////////
    //MARK: Error Package
    private let newLine = "\n"
    private var fullErrorDescription: String {
        return systemInformation + newLine + customErrorInformation
    }
    
    
    //////////////////////////////
    //MARK: Error Presentation
    
    
    ///Creates a View Controller embedded in a vindow which sits on top of everything in the app.
    ///- Note: This can be used to present alerts, etc, regardless of the view hierarchy.
    func createSurfaceViewController() -> UIViewController {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        window.rootViewController = viewController
        window.windowLevel = UIWindowLevelAlert + 1
        window.makeKeyAndVisible()

        return viewController
    }
    
    
    public func presentAlert() {
        
        let alertController = UIAlertController(title: userVisibleTitle, message: userVisibleInformation, preferredStyle: .alert)
        
        //Check if mail services are available
        if MFMailComposeViewController.canSendMail() {
            
            //If user wants to report the bug, give an option to send it via email
            alertController.addAction(UIAlertAction(title: "Tell Us", style: .default, handler: { (_) in
                let presentationView = self.createSurfaceViewController()
                
                let emailTitle = "Bug Report for \(self.applicationName)"
                let messageBody = self.fullErrorDescription
                let toRecipents = [self.reportEmail]
                let mailComposerView: MFMailComposeViewController = MFMailComposeViewController()
                mailComposerView.mailComposeDelegate = presentationView as? MFMailComposeViewControllerDelegate
                mailComposerView.setSubject(emailTitle)
                mailComposerView.setMessageBody(messageBody, isHTML: false)
                mailComposerView.setToRecipients(toRecipents)
                
                presentationView.present(mailComposerView, animated: true, completion: nil)
            }))
        }
        
        //Just dismiss the alert
        alertController.addAction(UIAlertAction(title: "Carry On", style: .default, handler: nil))
        
        createSurfaceViewController().present(alertController, animated: true)
    }
}

