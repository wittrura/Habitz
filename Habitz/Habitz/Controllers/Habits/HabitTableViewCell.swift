//
//  HabitViewCell.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/13/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit
import BEMCheckBox

class HabitTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var completedStreakLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isCompleteLabel: UILabel!
    @IBOutlet weak var completeCheckBox: BEMCheckBox!
    var habit: Habit?
    let completionsAPI = CompletionsAPI()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        completeCheckBox.onAnimationType = BEMAnimationType.bounce
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func toggleCheckBox(_ sender: BEMCheckBox) {
        guard let habit = habit else {return}
        
        // mark as complete or incomplete based on the change of state in the checkbox
        if completeCheckBox.on {
            completionsAPI.markComplete(habit)
            
        } else {
            completionsAPI.markIncomplete(habit)
        }
    }
}
