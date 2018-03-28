//
//  TeamPlayVC.swift
//  NewsTestProject
//
//  Created by Sergii on 3/28/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import UIKit
import Charts

class TeamPlayVC: EmbedParentStatVC {

    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var winRateLabel: UILabel!
    @IBOutlet weak var squadScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPieChart()
    }

    func setUpPieChart() {
        pieChart.legend.enabled = false
        pieChart.entryLabelColor = .clear
        pieChart.holeColor = UIColor.darkGray
        pieChart.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        pieChart.delegate = self
        pieChart.holeRadiusPercent = 0.4
        pieChart.transparentCircleRadiusPercent = 0.3
        pieChart.chartDescription?.enabled = false
        pieChart.minOffset = 0
    }
    
    override func fillData(with stats: PlayerStats) {
        super.fillData(with: stats)
        
        //piechart
        let wins = stats.numWins
        let loses = stats.numLosses
        let rounds = stats.numRounds
        let winRate = Float(stats.numWins)/Float(stats.numWins + stats.numLosses) * 100
        
        let winEntry = PieChartDataEntry(value: Double(wins), label: "Wins")
        let lossEntry = PieChartDataEntry(value: Double(loses), label: "Losses")
        
        let dataSet = PieChartDataSet(values: [winEntry, lossEntry], label: nil)
        dataSet.colors = [.blue, .red]
        dataSet.sliceSpace = 4
        dataSet.selectionShift = 6
        
        let data = PieChartData(dataSets: [dataSet])
        data.setValueTextColor(.white)
        data.setValueFont(UIFont(name: "AgencyFB-Bold", size: 15)!)
        
        pieChart.data = data
        pieChart.notifyDataSetChanged()
        
        //winrate
        winRateLabel.text = String(format: "%.0f%%", winRate)
        
        //squad score
        squadScoreLabel.text = String(format: "%i", stats.squadScore)
    }
}

extension TeamPlayVC: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
}
