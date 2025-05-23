//
//  SceneDelegate.swift
//  MultithreadingL2
//
//  Created by brubru on 19.05.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(windowScene: windowScene)
        
        window?.rootViewController = ComplexRaceConditionViewController()
		window?.makeKeyAndVisible()
	}
}

