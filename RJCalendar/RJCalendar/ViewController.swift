//
//  ViewController.swift
//  RJCalendar
//
//  Created by Ramanjeet Singh on 26/06/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var calendarView: RJCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendarView.dateRange = .threeMonths
        calendarView.onDateSelected = {
                   date in
                   let formatter = DateFormatter()
                   formatter.dateFormat = "dd-MM-yyyy"
                   formatter.timeZone = TimeZone.current
                   
                   debugPrint("Date",formatter.string(from: date))
               }



      // Add UIView assign this custom view and height should be greater then 100
    }
 

     
}

