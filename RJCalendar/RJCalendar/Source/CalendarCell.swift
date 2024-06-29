//
//  CalendarCell.swift
//  RJCalendar
//
//  Created by Ramanjeet Singh on 26/06/24.
//

import Foundation
import UIKit

class CalendarCell: UICollectionViewCell {
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(dayLabel)
        contentView.addSubview(dotView)
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            dayLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            dotView.topAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 8),
            dotView.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 5),
            dotView.widthAnchor.constraint(equalToConstant: 8),
            dotView.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
    
    func configure(day: String, date: Int, selectedDayColor: UIColor, normalDayColor: UIColor, dayTextColor: UIColor, selectedDayTextColor: UIColor, weekDayTextColor: UIColor, isCurrentDay: Bool, hasDot: Bool, dotColor: UIColor, isCurrentMonth: Bool, isSelected: Bool) {
        dayLabel.text = day
        dateLabel.text = "\(date)"
        
        if isSelected {
            contentView.backgroundColor = selectedDayColor
            dayLabel.textColor = selectedDayTextColor
            dateLabel.textColor = selectedDayTextColor
        } else {
            contentView.backgroundColor = normalDayColor
            dayLabel.textColor = isCurrentMonth ? weekDayTextColor : dayTextColor
            dateLabel.textColor = dayTextColor
        }
        
        dotView.isHidden = !hasDot
        dotView.backgroundColor = dotColor
    }
}



extension Calendar {
    func date(from components: DateComponents, adjustingDayIfNeeded: Bool) -> Date? {
        if adjustingDayIfNeeded, let newDate = self.date(from: components) {
            return newDate
        } else {
            var safeComponents = components
            // Adjust the day to the last day of the month if the original day is not valid
            while self.date(from: safeComponents) == nil, let day = safeComponents.day, day > 1 {
                safeComponents.day = day - 1
            }
            return self.date(from: safeComponents)
        }
    }
}
