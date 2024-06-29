//
//  RJCalendarModels.swift
//  RJCalendar
//
//  Created by Ramanjeet Singh on 26/06/24.
//

import Foundation


enum DateRange {
    case threeMonths
    case sixMonths
    case oneYear
    case custom(startDate: Date, endDate: Date)
}
