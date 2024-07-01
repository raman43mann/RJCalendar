# RJCalendar

Use RJCalendar to select dates in your app . Yoe can easiy integrate this code in your swift iOS based application  .

## Clone 
To run the RJCalendar project, clone the repo, and run the project.<br />
&nbsp;&nbsp;OR<br />
Manually -> Copy the folder named "Source" and paste to your codes target directory.

<img src = "https://github.com/raman43mann/RJCalendar/assets/154659783/5ae3d580-a38c-4bbe-844b-75d35cd4918a" width="300" height="670">

## How to use

Step 1 : Integrate the files to your project.

Step 2 : Add custom view as XIB or in UIViewController or in TableView/CollectionView Cells Content View , then add custom class to view as "RJCalendarView" in storyboard and UI part.

Step 3 : Create an outlet for this view in your assosiated file.<br />
like this<br />
@IBOutlet weak var calendarView: RJCalendarView!

Step 4 : You can setup the colors for selected or unselected items from the code as well from Attribute Inspector.

        calendarView.selectedDayColor = .systemGray6
        calendarView.normalDayColor = .clear
        calendarView.dayTextColor = .black
        calendarView.weekDayTextColor = .gray
        calendarView.dotColor = .red
        calendarView.selectedDayTextColor = .blue
        
Step 5: Custom enumuration property allow you to show the custom dates in calendar as per your requirement.

        calendarView.dateRange = .threeMonths

        calendarView.dateRange = .sixMonths

        calendarView.dateRange = .oneYear
        
        let currentDate = Date() , futureDate = Date()
        calendarView.dateRange = .custom(startDate: currentDate, endDate: futureDate)


Step 6 : It allow you to get a selected date with onDateSelected clouser method, Where you can easily format you date as per your requirement(dd/MM/yyyy).

             calendarView.onDateSelected = {
                   date in
                   let formatter = DateFormatter()
                   formatter.dateFormat = "dd-MM-yyyy"
                   formatter.timeZone = TimeZone.current
                   
                   debugPrint("Date",formatter.string(from: date))
               }



## Requirements
- Xcode 14 to onwards
- iOS 15,*
- iPad OS 15,*
- Swift 5.0 


## Author
raman43mann, rjmann43@gmail.com , Linkedin : https://www.linkedin.com/in/raman-mann-957201154

## License
RJCalendar is available under the MIT license. See the LICENSE file for more info.
