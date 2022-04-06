//
//  ChecklistsViewController.swift
//  Checklists
//
//  Created by Christos Tzimas on 9/1/22.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {

	let cellIdentifier = "ChecklistItemCell"

	var checklist: Checklist!
	var dataModel: DataModel!

	override func viewDidLoad() {
		super.viewDidLoad()
		title = checklist.name
	}

	// MARK: - Table View Data Source

	override func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int
	) -> Int {
		return checklist.items.count
	}

	override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		let cell: UITableViewCell!
		if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
			cell = tmp
		} else {
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
		}
		cell.accessoryType = .detailDisclosureButton

		let item = checklist.items[indexPath.row]
		configureText(for: cell, with: item)
		configureCheckmark(for: cell, with: item)
		return cell
	}

	override func tableView(
		_ tableView: UITableView,
		commit editingStyle: UITableViewCell.EditingStyle,
		forRowAt indexPath: IndexPath
	) {
		checklist.items.remove(at: indexPath.row)
		let indexPaths = [indexPath]
		tableView.deleteRows(at: indexPaths, with: .automatic)
	}

	// MARK: - Table View Delegate

	override func tableView(
		_ tableView: UITableView,
		didSelectRowAt indexPath: IndexPath
	){
		if let cell = tableView.cellForRow(at: indexPath) {
			let item = checklist.items[indexPath.row]
			item.checked.toggle()
			configureCheckmark(for: cell, with: item)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}

	override func tableView(
		_ tableView: UITableView,
		accessoryButtonTappedForRowWith indexPath: IndexPath
	) {
		let controller = storyboard!.instantiateViewController(
			withIdentifier: "ItemDetailViewController"
		) as! ItemDetailViewController
		controller.delegate = self
		let item = checklist.items[indexPath.row]
		controller.itemToEdit = item
		navigationController?.pushViewController(controller, animated: true)
	}

	func configureCheckmark(
		for cell: UITableViewCell,
		with item: ChecklistItem
	) {
		if item.checked {
			cell.imageView!.image = UIImage(named: "Item Checked")
		} else {
			cell.imageView!.image = UIImage(named: "No Icon")
		}
	}

	func configureText(
		for cell: UITableViewCell,
		with item: ChecklistItem
	){
		cell.textLabel?.text = item.text
		cell.detailTextLabel?.text = item.dueDate.formatted(date: .abbreviated, time: .shortened).description
	}

	// MARK: - Item Detail View Controller Delegate

	func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
		navigationController?.popViewController(animated: true)
	}

	func itemDetailViewController(
		_ controller: ItemDetailViewController,
		didFinishEditing item: ChecklistItem
	) {
		if let index = checklist.items.firstIndex(of: item) {
			let indexPath = IndexPath(row: index, section: 0)
			if let cell = tableView.cellForRow(at: indexPath) {
				configureText(for: cell, with: item)
			}
		}
		dataModel.sortItems(ofList: checklist)
		tableView.reloadData()
		navigationController?.popViewController(animated: true)
	}

	func itemDetailViewController(
		_ controller: ItemDetailViewController,
		didFinishAdding item: ChecklistItem
	) {
		let newRowIndex = checklist.items.count
		checklist.items.append(item)
		let indexPath = IndexPath(row: newRowIndex, section: 0)
		let indexPaths = [indexPath]
		tableView.insertRows(at: indexPaths, with: .automatic)
		dataModel.sortItems(ofList: checklist)
		tableView.reloadData()
		navigationController?.popViewController(animated:true)
	}

	// MARK: - Navigation

	override func prepare(
		for segue: UIStoryboardSegue,
		sender: Any?
	) {
		if segue.identifier == "AddItem" {
			let controller = segue.destination as! ItemDetailViewController
			controller.delegate = self
		} else if segue.identifier == "EditItem" {
			let controller  = segue.destination as! ItemDetailViewController
			controller.delegate = self
			if let indexPath = tableView.indexPath(
				for: sender as! UITableViewCell) {
				controller.itemToEdit = checklist.items[indexPath.row]
			}
		}
	}
}
