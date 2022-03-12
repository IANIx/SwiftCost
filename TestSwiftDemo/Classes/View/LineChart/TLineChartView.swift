//
//  TLineChartView.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/20.
//

import UIKit

private let _lineWidth: CGFloat = 0.8
private let _lineColor = UIColor.hexStringColor(hexString: "#696969").cgColor
private let _dotWidth: CGFloat = 8.0
private let _dotColor = mainColor.cgColor

private let _borderWidth: CGFloat = 0.9
private let _borderColor = UIColor.hexStringColor(hexString: "#E2E2E2").cgColor
private let _borderColor2 = UIColor.hexStringColor(hexString: "#E0DFE0").cgColor

private let _borderPadding: CGFloat = 10
private let _textHeight: CGFloat = 35

struct PointEntry {
    let value: CGFloat
    let label: String
    let isWrite: Bool
    
    init(_ v: CGFloat, _ l: String = "", _ w: Bool = true) {
        value = v
        label = l
        isWrite = w
    }
}

class TLineChartView: UIView {

    /// 总区域大小
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat = 0.0
    
    /// 折线区域大小
    private var chartWidth: CGFloat = 0.0
    private var chartHeight: CGFloat = 0.0
    
    /// layer
    private let dataLayer: CALayer = CALayer()
    private let borderLayer: CALayer = CALayer()
    private let textLayer: CALayer = CALayer()
    private let mainLayer: CALayer = CALayer()
    
    /// data
    var dataEntries: [PointEntry] = [] {
        didSet {
            self.setNeedsLayout()
        }
    }
    private var data: [CGFloat] = []
    private var pointData: [CGPoint] = []
    private var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var endPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    override func draw(_ rect: CGRect) {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        mainLayer.frame = CGRect(x: 0, y: 0, width: contentWidth, height: contentHeight)
        borderLayer.frame = mainLayer.frame
        dataLayer.frame = CGRect(x: _borderPadding, y: 0, width: chartWidth, height: chartHeight)
        textLayer.frame = CGRect(x: _borderPadding, y: chartHeight, width: chartWidth, height: _textHeight)
        
        startDraw()
    }
    
    private func setupView() {
        contentHeight = self.bounds.size.height
        contentWidth = self.bounds.size.width
        chartWidth = contentWidth - (_borderPadding * 2)
        chartHeight = contentHeight - _textHeight
        startPoint = CGPoint(x: _borderPadding, y: chartHeight)
        endPoint = CGPoint(x: contentWidth - _borderPadding, y: chartHeight)

        drawBorderLine()
        
        mainLayer.addSublayer(borderLayer)
        mainLayer.addSublayer(dataLayer)
        mainLayer.addSublayer(textLayer)
        
        self.layer.addSublayer(mainLayer)
    }
    
    private func startDraw() {
        clean()
        guard dataEntries.count > 0 else {
            return
        }
        
        data =  dataEntries.map { (entry) -> CGFloat in
            return entry.value
        }
        pointData = calculatePoint()
        
        drawLine()
        drawAverageLine()
        drawDots()
        drawLables()
    }
    
    private func clean() {
        dataLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
        textLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
    }

}

// MARK: - Draw
extension TLineChartView {
    
    /// base line
    private func drawBorderLine() {
        /// bottom line
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: contentHeight))
        path.addLine(to: CGPoint(x: contentWidth, y: contentHeight))
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = _borderColor
        layer.lineWidth = _borderWidth
        borderLayer.addSublayer(layer)
        
        /// chart top line
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: _borderPadding, y: 0))
        path1.addLine(to: CGPoint(x: contentWidth - _borderPadding, y: 0))
        
        let layer1 = CAShapeLayer()
        layer1.path = path1.cgPath
        layer1.strokeColor = _borderColor2
        layer1.lineWidth = _borderWidth
        borderLayer.addSublayer(layer1)
        
        /// chart bottom line
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: _borderPadding, y: chartHeight))
        path2.addLine(to: CGPoint(x: contentWidth - _borderPadding, y: chartHeight))
        
        let layer2 = CAShapeLayer()
        layer2.path = path2.cgPath
        layer2.strokeColor = _borderColor2
        layer2.lineWidth = _borderWidth
        borderLayer.addSublayer(layer2)
    }
    
    /// chart line
    private func drawLine() {
        guard pointData.count > 0 else {
            return
        }
        
        let path = UIBezierPath()
        path.move(to: pointData[0])
        
        for i in 1..<pointData.count {
            path.addLine(to: pointData[i])
        }
        
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: dataLayer.frame.width, height: dataLayer.frame.height)
        layer.path = path.cgPath
        layer.strokeColor = _lineColor
        layer.lineWidth = _lineWidth
        layer.fillColor = UIColor.clear.cgColor
        dataLayer.addSublayer(layer)
    }
    
    /// average line
    private func drawAverageLine() {
        guard data.count > 0 else {
            return
        }
                
        let total = data.reduce(0, +)
        guard total > 0, let max = data.max()  else {
            return
        }
        
        let average = total / CGFloat(data.count)
        let min: CGFloat = 0
        let scale = max - min
        let yValue = chartHeight * (1 - (average / scale))
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: yValue))
        path.addLine(to: CGPoint(x: chartWidth, y: yValue))

        
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: dataLayer.frame.width, height: dataLayer.frame.height)
        layer.path = path.cgPath
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.lineWidth = 1
        layer.lineDashPattern = [6, 6]
        
        dataLayer.addSublayer(layer)
    }
    
    /// dots
    private func drawDots() {
        guard pointData.count > 0 else {
            return
        }
        
        for i in 0..<pointData.count {
            let xValue: CGFloat = pointData[i].x - (_dotWidth / 2)
            let yValue: CGFloat = pointData[i].y - (_dotWidth / 2)
            let dotLayer = DotCALayer()
            dotLayer.frame = CGRect(x: xValue, y: yValue, width: _dotWidth, height: _dotWidth)
            if dataEntries[i].isWrite {
                dotLayer.dotColor = _dotColor
            } else {
                dotLayer.dotColor = UIColor.white.cgColor
            }
            dataLayer.addSublayer(dotLayer)
            
        }
    }
    
    private func drawLables() {
        guard dataEntries.count > 0 else {
            return
        }
        
        let width: CGFloat = (chartWidth / CGFloat(dataEntries.count - 1))
        let textWidth = width < 30.0 ? 30.0 : width
        
        for i in 0..<dataEntries.count {
            let textLayer = CATextLayer()
            var x: CGFloat = (width * CGFloat(i)) - (textWidth / 2)
            if (i == 0) {
                x = 0.0
            } else if (i == dataEntries.count - 1) {
                x = chartWidth - textWidth
            }
            
            textLayer.frame = CGRect(x: x, y:  8, width: textWidth - 2, height: 16)
            textLayer.foregroundColor = defaultTitleColor.cgColor
            textLayer.backgroundColor = UIColor.clear.cgColor
            if (i == 0) {
                textLayer.alignmentMode = CATextLayerAlignmentMode.left
            } else if (i == dataEntries.count - 1) {
                textLayer.alignmentMode = CATextLayerAlignmentMode.right
            } else {
                textLayer.alignmentMode = CATextLayerAlignmentMode.center
            }
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.fontSize = 11
            textLayer.string = "\(dataEntries[i].label)"
            self.textLayer.addSublayer(textLayer)
        }
    }

    
    private func calculatePoint() -> [CGPoint] {
        var points: [CGPoint] = []
        
        let max = data.max() ?? 0
        let min: CGFloat = 0
        let scale = max - min
        let separationWidth: CGFloat = chartWidth/CGFloat(data.count - 1)

        for index in 0..<data.count {
            let xValue = (CGFloat(index) * separationWidth)
            let y = data[index]
            
            let yScale = (y / scale).isNaN ? 0.0 : (y / scale)
            let yValue = chartHeight * (1 - yScale)
            points.append(CGPoint(x: xValue, y: yValue))
        }
        
        return points
    }
}


/**
 * DotCALayer
 */
class DotCALayer: CALayer {
    private let _dotBorderWidth: CGFloat = 2
    var dotColor = _dotColor
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        self.backgroundColor = _lineColor
        self.cornerRadius = self.bounds.size.width / 2
        
        let inset = self.bounds.size.width - _dotBorderWidth
        let innerDotLayer = CALayer()
        innerDotLayer.frame = self.bounds.insetBy(dx: _dotBorderWidth/2, dy: _dotBorderWidth/2)
        innerDotLayer.cornerRadius = inset / 2
        innerDotLayer.backgroundColor = dotColor
        self.addSublayer(innerDotLayer)
    }
    
}
