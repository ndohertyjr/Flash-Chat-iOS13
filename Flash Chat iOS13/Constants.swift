//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Neil Doherty on 7/27/22.
//  Copyright © 2022 Angela Yu. All rights reserved.
//


struct Constants {
    static let appName = "⚡️FlashChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    //Alerts
    static let registrationFailureTitle = "Registration Error"
    static let registrationFailureMessage = "Please enter an email and password."
    static let alertAction = "OK"
    static let loginFailureTitle = "Failed Login"
    static let loginFailureMessage = "Login Failure. Try again."
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
