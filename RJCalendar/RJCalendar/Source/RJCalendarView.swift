//
//  RJCalendar.swift
//  RJCalendar
//
//  Created by Ramanjeet Singh on 26/06/24.
//

import Foundation
import UIKit



@IBDesignable
class RJCalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var collectionView: UICollectionView!
    private var selectedDate: Date = Date()
    private var datesWithDetails: [(Date, String, Bool)] = [] // Date, Day of the Week, Dot Visibility
    private let calendar = Calendar.current

    private let daysOfWeek = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    
    @IBInspectable var selectedDayColor: UIColor = .systemGray6
    @IBInspectable var normalDayColor: UIColor = .clear
    @IBInspectable var dayTextColor: UIColor = .black
    @IBInspectable var weekDayTextColor: UIColor = .gray
    @IBInspectable var dotColor: UIColor = .red
    @IBInspectable var selectedDayTextColor: UIColor = .blue
    
    var dateRange: DateRange = .threeMonths
    var showMonthYearLabel: Bool = false {
        didSet {
            updateMonthYearLabelVisibility()
        }
    }
    
    var onDateSelected: ((Date) -> Void)? // Closure to handle date selection
    
    private let monthYearLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private var monthYearLabelHeightConstraint: NSLayoutConstraint!
    private var collectionViewTopConstraint: NSLayoutConstraint!
    private var calendarHeightConstraint: NSLayoutConstraint!
    
    private let calendarHeight: CGFloat = 90
    private let monthYearLabelHeight: CGFloat = 30
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        generateDays()
        setupMonthYearLabel()
        setupCalendarHeight()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
        generateDays()
        setupMonthYearLabel()
        setupCalendarHeight()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateMonthYearLabel()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 70)
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 5)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: RJCalendarConstants.Table.cellIdentifire)
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(monthYearLabel)
        addSubview(collectionView)
        
        monthYearLabel.translatesAutoresizingMaskIntoConstraints = false
        monthYearLabelHeightConstraint = monthYearLabel.heightAnchor.constraint(equalToConstant: monthYearLabelHeight)
        collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: monthYearLabel.bottomAnchor, constant: 5)
        calendarHeightConstraint = heightAnchor.constraint(equalToConstant: calendarHeight + monthYearLabelHeight)
        
        NSLayoutConstraint.activate([
            monthYearLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            monthYearLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            monthYearLabelHeightConstraint,
            collectionViewTopConstraint,
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            calendarHeightConstraint
        ])
        
        
        showMonthAndYear(date: Date())
    }
    
    private func setupMonthYearLabel() {
        monthYearLabel.textAlignment = .center
        monthYearLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        updateMonthYearLabel()
    }
    
    private func setupCalendarHeight() {
        updateMonthYearLabelVisibility()
    }

    private func generateDays() {
        guard let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: Date())) else { return }
        var date = startDate
        var endDate: Date?
        
        switch dateRange {
        case .threeMonths:
            endDate = calendar.date(byAdding: .month, value: 3, to: startDate)
        case .sixMonths:
            endDate = calendar.date(byAdding: .month, value: 6, to: startDate)
        case .oneYear:
            endDate = calendar.date(byAdding: .year, value: 1, to: startDate)
        case .custom(let start, let end):
            date = start
            endDate = end
        }
        
        while date <= (endDate ?? Date()) {
            let dayOfWeek = calendar.component(.weekday, from: date)
            let hasDot = calendar.component(.day, from: date) % 3 == 0
            datesWithDetails.append((date, daysOfWeek[dayOfWeek - 1], hasDot))
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
    }

    private func updateMonthYearLabel() {
        if let centerIndexPath = collectionView.indexPathsForVisibleItems.sorted().first {
            let date = datesWithDetails[centerIndexPath.item].0
            showMonthAndYear(date: date)
        }
    }
    
    private func showMonthAndYear(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.timeZone = TimeZone.current // Ensure formatter uses local time zone
        monthYearLabel.text = formatter.string(from: date)
    }
    
    private func updateMonthYearLabelVisibility() {
        monthYearLabel.isHidden = !showMonthYearLabel
        monthYearLabelHeightConstraint.constant = showMonthYearLabel ? monthYearLabelHeight : 0
        collectionViewTopConstraint.constant = showMonthYearLabel ? 5 : 5
        calendarHeightConstraint.constant = calendarHeight + (showMonthYearLabel ? monthYearLabelHeight : 0)
        layoutIfNeeded()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datesWithDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RJCalendarConstants.Table.cellIdentifire, for: indexPath) as! CalendarCell
        let (date, dayOfWeek, hasDot) = datesWithDetails[indexPath.item]
        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
        cell.configure(day: dayOfWeek, date: Calendar.current.component(.day, from: date), selectedDayColor: selectedDayColor, normalDayColor: normalDayColor, dayTextColor: dayTextColor, selectedDayTextColor: selectedDayTextColor, weekDayTextColor: weekDayTextColor, isCurrentDay: Calendar.current.isDateInToday(date), hasDot: hasDot, dotColor: dotColor, isCurrentMonth: Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month), isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = datesWithDetails[indexPath.item].0
        collectionView.reloadData()
        updateMonthYearLabel()
        onDateSelected?(selectedDate) // Call the closure with the newly selected date
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateMonthYearLabel()
    }

    func updateDateRange(_ range: DateRange) {
        dateRange = range
        generateDays()
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        updateMonthYearLabel()
    }
}



