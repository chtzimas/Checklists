//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Christos Tzimas on 14/2/22.
//

import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject {

	func itemDetailViewControllerDidCancel(
		_ controller: ItemDetailViewController
	)

	func itemDetailViewController(
		_ controller: ItemDetailViewController,
		didFinishAdding item: ChecklistItem
	)

	func itemDetailViewController(
		_ controller: ItemDetailViewController,
		didFinishEditing item: ChecklistItem
	)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

		if let itemToEdit = itemToEdit {
			title = "Edit Item"
			newItemTextField.text = itemToEdit.text
			doneBarButton.isEnabled = true
			shouldRemindSwitch.isOn = itemToEdit.shouldRemind
			datePicker.date = itemToEdit.dueDate
		}
    }

	weak var delegate: ItemDetailViewControllerDelegate?
	var itemToEdit: ChecklistItem?

	// MARK: - Outlets

	@IBOutlet weak var newItemTextField: UITextField!
	@IBOutlet weak var doneBarButton: UIBarButtonItem!
	@IBOutlet weak var shouldRemindSwitch: UISwitch!
	@IBOutlet weak var datePicker: UIDatePicker!

	// MARK: - Actions
	
	@IBAction func cancel() {
		delegate?.itemDetailViewControllerDidCancel(self)
	}

	@IBAction func done() {
		if let itemToEdit = itemToEdit {
			itemToEdit.text = newItemTextField.text!
			itemToEdit.shouldRemind = shouldRemindSwitch.isOn
			itemToEdit.dueDate = datePicker.date
			itemToEdit.scheduleNotification()
			delegate?.itemDetailViewController(self, didFinishEditing: itemToEdit)
		} else {
			let item = ChecklistItem(text: newItemTextField.text!)
			item.shouldRemind = shouldRemindSwitch.isOn
			item.dueDate = datePicker.date
			item.scheduleNotification()
			delegate?.itemDetailViewController(self, didFinishAdding: item)
		}
	}

	@IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
		newItemTextField.resignFirstResponder()
		if switchControl.isOn {
			let center = UNUserNotificationCenter.current()
			center.requestAuthorization(options: [.alert, .sound]) { _, _ in } }
	}

	// MARK: - UIViewController

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		newItemTextField.becomeFirstResponder()
	}

	// MARK: - Table View Delegates

	override func tableView(
		_ tableView: UITableView,
		willSelectRowAt indexPath: IndexPath
	) -> IndexPath? {
		return nil
	}

	// MARK: - Text Field Delegates

	func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		let oldText = textField.text!
		let stringRange = Range(range, in: oldText)!

		let newText = oldText.replacingCharacters(
			in: stringRange,
			with: string)
		doneBarButton.isEnabled = !newText.isEmpty

		return true
	}

	func textFieldShouldClear(_ textField: UITextField) -> Bool {
		doneBarButton.isEnabled = false
		return true
	}
}
