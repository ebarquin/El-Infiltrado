//
//  AppDelegate.swift
//  El Infiltrado
//
//  Created by Eugenio Barquin on 27/11/25.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    // Esta función fuerza portrait en toda la app
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}
