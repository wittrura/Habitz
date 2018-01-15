//
//  HabitsViewController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/13/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class HabitsTableViewController: UITableViewController {
    
    // MARK: - Properties
    var habits: [Habit] = []
    let habitsAPI = HabitsAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // get all habits to populate table
        habitsAPI.getAll { (allHabits) in
            self.habits = allHabits
            self.tableView.reloadData()
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "HabitTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HabitTableViewCell else {
            fatalError("The dequeued cell is not an instance of HabitTableViewCell.")
        }

        let habit = habits[indexPath.row]

        cell.completedStreakLabel.text = "(\(habit.completedStreak))"
        cell.nameLabel.text = habit.name
        
        if habit.isComplete {
            cell.isCompleteLabel.text = "(X)"
        } else {
            cell.isCompleteLabel.text = "(O)"
        }

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            let habitToDelete = habits[indexPath.row]
            habitToDelete.deleteEntry()
            
            habits.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        //TODO: TODO - mark as complete on swipe right
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
        case "createHabit":
            print("create a new habit")
        
        case "showHabitDetail":
            guard let habitDetailViewController = segue.destination as? HabitViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedHabitCell = sender as? HabitTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedHabitCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedHabit = habits[indexPath.row]
            habitDetailViewController.habit = selectedHabit
        
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
  
    
    //MARK: - Actions
    @IBAction func unwindToHabitlList(sender: UIStoryboardSegue) -> Void {
        
        if let sourceViewController = sender.source as? HabitViewController, let habit = sourceViewController.habit {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // updates an existing habit
                habits[selectedIndexPath.row] = habit
                habit.editEntry()
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            } else {
                // add a new habit to the database
                habitsAPI.create(habit: habit, completion: { (habit) in
                    // add a new habit to the habits array and update the view
                    let newIndexPath = IndexPath(row: self.habits.count, section: 0)
                    self.habits.append(habit)
                    self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                })
            }
        }
    }
    
}
