//
//  Checklist.swift
//  Checklists
//
//  Created by Christos Tzimas on 22/2/22.
//

import UIKit

class Checklist: NSObject, Codable {

	var name = ""
	var iconName = "Chores"
	var items = [ChecklistItem]()

	init(name: String, iconName: String = "Chores") {
		self.name = name
		self.iconName = iconName
		super.init()
	}

	func countUncheckedItems() -> Int {
		return items.reduce(0) {
			cnt, item in cnt + (item.checked ? 0 : 1)
		}
	}
}
