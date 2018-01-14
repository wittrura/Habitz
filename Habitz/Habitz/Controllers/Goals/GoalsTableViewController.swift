//
//  GoalsTableViewController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/13/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class GoalsTableViewController: UITableViewController {
    
    // MARK: - Properties
    var goals: [Goal] = []
    
    let goalsAPI = GoalsAPI()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // get all goals to populate table
        goalsAPI.getAll { (allGoals) in
            self.goals = allGoals
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
        return goals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GoalTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GoalTableViewCell else {
            fatalError("The dequeued cell is not an instance of GoalTableViewCell.")
        }

        let goal = goals[indexPath.row]
        
        cell.completedStreakLabel.text = "(\(goal.completedStreak))"
        cell.nameLabel.text = goal.name
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let goalToDelete = goals[indexPath.row]
            
            // delete goal from database
            goalsAPI.delete(goal: goalToDelete)
            
            // Delete the row from the data source
            goals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
        
        switch (segue.identifier ?? "") {
        case "createGoal":
            print("creating a new goal")

        case "showGoalDetail":
            guard let goalDetailViewController = segue.destination as? GoalViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedGoalCell = sender as? GoalTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedGoalCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            // pass tapped goal to detail vc
            let selectedGoal = goals[indexPath.row]
            goalDetailViewController.goal = selectedGoal
        
        case "showHabits":
            print("navigating to habits list view")
        
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: - Actions
    @IBAction func unwindToGoalList(sender: UIStoryboardSegue) -> Void {
        
        if let sourceViewController = sender.source as? GoalViewController, let goal = sourceViewController.goal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // edit goal in the database
                goalsAPI.edit(goal: goal)
                
                // updates an existing goal in the array and view
                goals[selectedIndexPath.row] = goal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            } else {
                
                // add a new goal to the database
                goalsAPI.create(goal: goal, completion: { (goal) in
                    // add a new goal to the goals array and update the view
                    let newIndexPath = IndexPath(row: self.goals.count, section: 0)
                    self.goals.append(goal)
                    self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                })
            }
        }
    }

}
