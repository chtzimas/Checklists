//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Christos Tzimas on 30/3/22.
//

import UIKit

protocol IconPickerViewControllerDelegate: AnyObject {
	func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
	let icons = ["Chores", "Appointments", "Birthdays", "Trips", "No Icon"]
	weak var delegate: IconPickerViewControllerDelegate?

	// MARK: - Table View Delegates

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return icons.count
	}

	override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
		let iconName = icons[indexPath.row]
		cell.textLabel!.text = iconName
		cell.imageView!.image = UIImage(named: iconName)
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let delegate = delegate {
			let iconName = icons[indexPath.row]
			delegate.iconPicker(self, didPick: iconName)
		}
	}
}
