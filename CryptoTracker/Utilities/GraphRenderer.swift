//
//  GraphRenderer.swift
//  CryptoTracker
//
//  Created by Ranbijay SinghDeo on 27/11/24.
//

import Foundation
import UIKit

class GraphRenderer {
    private let graphView: UIView

    init(graphView: UIView) {
        self.graphView = graphView
    }

    func renderGraph(with points: [Double], graphColor: UIColor) {
        guard let maxPrice = points.max(), let minPrice = points.min(), maxPrice != minPrice else {
            clearGraph()
            return
        }

        clearGraph()
        setupBackground()
        addMaxMinLabels(max: maxPrice, min: minPrice)
        drawGraphPath(points: points, maxPrice: maxPrice, minPrice: minPrice, color: graphColor)
    }

    private func clearGraph() {
        graphView.subviews.forEach { $0.removeFromSuperview() }
        graphView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }

    private func setupBackground() {
        let backgroundView = UIView(frame: graphView.bounds)
        backgroundView.backgroundColor = UIColor(red: 48/255, green: 55/255, blue: 67/255, alpha: 0.9)
        backgroundView.layer.cornerRadius = 10
        backgroundView.clipsToBounds = true
        graphView.addSubview(backgroundView)
    }

    private func addMaxMinLabels(max: Double, min: Double) {
        let maxLabel = createLabel(text: "High: $\(String(format: "%.2f", max))", position: CGPoint(x: 10, y: 5))
        let minLabel = createLabel(text: "Low: $\(String(format: "%.2f", min))", position: CGPoint(x: 10, y: graphView.bounds.height - 20))

        graphView.addSubview(maxLabel)
        graphView.addSubview(minLabel)
    }

    private func createLabel(text: String, position: CGPoint) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .darkGray
        label.sizeToFit()
        label.frame.origin = position
        return label
    }

    private func drawGraphPath(points: [Double], maxPrice: Double, minPrice: Double, color: UIColor) {
        let path = UIBezierPath()

        for (index, price) in points.enumerated() {
            let xPosition = CGFloat(index) * (graphView.frame.width / CGFloat(points.count - 1))
            let yPosition = graphView.frame.height - ((CGFloat(price - minPrice) / CGFloat(maxPrice - minPrice)) * graphView.frame.height)
            let point = CGPoint(x: xPosition, y: yPosition)

            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        let graphLayer = CAShapeLayer()
        graphLayer.path = path.cgPath
        graphLayer.strokeColor = color.cgColor
        graphLayer.fillColor = UIColor.clear.cgColor
        graphLayer.lineWidth = 1.5
        graphView.layer.addSublayer(graphLayer)
    }
}
