//
//  Canvas.swift
//  ColorNumber
//
//  Created by Chung-Sama on 2018/01/09.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

public class Canvas: UIView {
    var itemSize: CGFloat
    var numberOfItemInRow: Int
    var numberOfItemInColumn: Int
    var symbolsMatix: [[String]]
    var height: Int
    var width: Int
    var pixels = Array<Array<UILabel>>()
    public var paintBrushColor: UIColor = UIColor.blue
    public init(itemSize: CGFloat, symbolsMatix: [[String]]){
        self.itemSize = itemSize
        self.symbolsMatix = symbolsMatix
        self.numberOfItemInRow = symbolsMatix[0].count
        self.numberOfItemInColumn = symbolsMatix.count
        self.width = Int(itemSize) * self.numberOfItemInRow
        self.height = Int(itemSize) * self.numberOfItemInColumn
        print("\(self.numberOfItemInRow)x\(self.numberOfItemInColumn)")
        super.init(frame: CGRect(x: 0, y: 0, width: CGFloat(self.numberOfItemInRow) * itemSize, height: CGFloat(self.numberOfItemInColumn) * itemSize))
        setupDisplayCanvasView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.black.cgColor
    }
    func setupDisplayCanvasView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tapGestureRecognizer.delegate = self
        addGestureRecognizer(tapGestureRecognizer)
        let dragGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleDrag(sender:)))
        dragGestureRecognizer.minimumPressDuration = 0.25
        addGestureRecognizer(dragGestureRecognizer)
        for y in 0..<self.numberOfItemInColumn {
            self.pixels.append([])
            for x in 0..<self.numberOfItemInRow {
                let label = UILabel()
                label.frame = CGRect(x: CGFloat(x) * itemSize, y: CGFloat(y) * itemSize, width: itemSize, height: itemSize)
                label.backgroundColor = UIColor.white
                label.text = self.symbolsMatix[y][x]
                label.font = UIFont.boldSystemFont(ofSize: 8)
                label.textAlignment = .center
                label.textColor = UIColor.black
                label.layer.borderWidth = 0.2
                label.layer.borderColor = UIColor.black.cgColor
                addSubview(label)
                self.pixels[y].append(label)
            }
        }
    }
    @objc private func handleTap(sender: UIGestureRecognizer) {
        print("tapped: \(sender.location(in: self))")
        self.draw(atPoint: sender.location(in: self))
    }
    
    @objc private func handleDrag(sender: UIGestureRecognizer) {
        switch sender.state {
        case .changed, .began:
            print("changed & began: \(sender.location(in: self))")
            self.draw(atPoint: sender.location(in: self))
        case .ended:
            print("End")
        default: break
        }
    }
    private func draw(atPoint point: CGPoint) {
        let x = Int(point.y / itemSize)
        let y = Int(point.x / itemSize)
        guard y < width && x < height && y >= 0 && x >= 0 else { return }
        self.pixels[x][y].backgroundColor = self.paintBrushColor
    }
}
extension Canvas: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
