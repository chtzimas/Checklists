//
//  SceneDelegate.swift
//  Checklists
//
//  Created by Christos Tzimas on 9/1/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	let dataModel = DataModel()

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		let navigationController = window!.rootViewController as! UINavigationController
		let controller = navigationController.viewControllers[0] as! AllListsViewController
		controller.dataModel = dataModel
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		saveData()
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		saveData()
	}

	// MARK: - Helper Methods

	func saveData() {
		dataModel.saveChecklists()
	}
}
