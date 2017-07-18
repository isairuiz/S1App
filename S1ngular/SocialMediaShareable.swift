//
//  SocialMediaShareable.swift
//  S1ngular
//
//  Created by Ruiz Aguila on 13/07/17.
//  Copyright © 2017 Akira Redwolf. All rights reserved.
//

import Social
import UIKit

public protocol SocialMediaShareable {
    func image() -> UIImage?
    func url() -> URL?
    func text() -> String?
}

public class SocialMediaSharingManager {
    public static func shareOnFacebook(object: SocialMediaShareable, from presentingVC: UIViewController) {
        share(object: object, for: SLServiceTypeFacebook, from: presentingVC)
    }
    public static func shareOnTwitter(object: SocialMediaShareable, from presentingVC: UIViewController) {
        share(object: object, for: SLServiceTypeTwitter, from: presentingVC)
    }
    private static func share(object: SocialMediaShareable, for serviceType: String, from presentingVC: UIViewController) {
        if let composeVC = SLComposeViewController(forServiceType:serviceType) {
            composeVC.add(object.image())
            composeVC.add(object.url())
            composeVC.setInitialText(object.text())
            presentingVC.present(composeVC, animated: true, completion: nil)
        }
    }
}
