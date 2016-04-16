//
//  PoemShow.swift
//  PoemShow
//
//  Created by Lois_pan on 16/3/31.
//  Copyright © 2016年 Lois_pan. All rights reserved.
//

//显示字体动画的view
import UIKit


public class PoemShow: UIView {
    /// 渐变色layer
    private var gradientLayer = CAGradientLayer()
    /// 字迹动画的时间
    private let textAnimationTime:NSTimeInterval = 5
    /// 字迹图层
    private let pathLayer = CAShapeLayer()
    
    public init(frame: CGRect, message:String) {
        super.init(frame: frame)
        show(message)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func show(message:String) {
        // 添加渐变色layer以及动画
        addGradientLayer()
        // 添加文字动画
        addPathLayer(message)
        //添加gradientLayer的遮罩
        
        gradientLayer.mask = pathLayer
        
        
        self.layer.sublayers.map { (layer) -> [CALayer] in
            print(layer)
            return layer
        }
        
        print("cout ---\(self.layer.sublayers?.count)")
    }

    /**
     添加渐变色的layer 和动画
     */
     func addGradientLayer() {
        
        // 渐变色的颜色数
        let count = 10
        var colors:[CGColorRef] = []
        
        let topColor = UIColor(red: (91/255.0), green: (91/255.0), blue: (91/255.0), alpha: 1)
        let buttomColor = UIColor(red: (24/255.0), green: (24/255.0), blue: (24/255.0), alpha: 1)

        let gradientColors: [CGColor] = [topColor.CGColor, buttomColor.CGColor]

        for var i = 0; i < count; i++ {
            let color = UIColor.init(red: CGFloat(arc4random() % 256) / 255, green: CGFloat(arc4random() % 256) / 255, blue: CGFloat(arc4random() % 256) / 255, alpha: 1.0)
            
            colors.append(color.CGColor)
        }
        print(gradientLayer)
        // 渐变色的方向
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradientLayer.colors = gradientColors
        gradientLayer.frame = self.bounds
        gradientLayer.type = kCAGradientLayerAxial
        
        self.layer.addSublayer(gradientLayer)
        
        // 渐变色的动画
        let animation = CABasicAnimation(keyPath: "colors")
        animation.duration = 0.5
        animation.repeatCount = MAXFLOAT
        
        var toColors:[CGColorRef] = []
        
        for var i = 0; i < count; i++ {
            let color = UIColor.init(red: CGFloat(arc4random() % 256) / 255, green: CGFloat(arc4random() % 256) / 255, blue: CGFloat(arc4random() % 256) / 255, alpha: 1.0)
            
            toColors.append(color.CGColor)
        }
        animation.autoreverses = true
        animation.toValue = toColors
        gradientLayer.addAnimation(animation, forKey: "gradientLayer")
    }
    
    
    /**
     添加笔迹的动画
     
     - parameter message: 显示的文字
     */
       func addPathLayer(message:String) {
        
        let textPath = bezierPathFrom(message)
        
        pathLayer.bounds = CGPathGetBoundingBox(textPath.CGPath)
//        pathLayer.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetHeight(frame) / 2)
        pathLayer.position = gradientLayer.position
        pathLayer.geometryFlipped = true
        pathLayer.path = textPath.CGPath
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 1
        pathLayer.strokeColor = UIColor.blackColor().CGColor
        
        // 笔迹的动画
        let textAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
        textAnimation.duration = textAnimationTime
        textAnimation.fromValue = 0
        textAnimation.toValue = 1
        textAnimation.delegate = self
        pathLayer.addAnimation(textAnimation, forKey: "strokeEnd")
        
    }
    
    /**
     将字符串转变成贝塞尔曲线
     */
     func bezierPathFrom(string:String) -> UIBezierPath{
        
        let paths = CGPathCreateMutable()
        let fontName = __CFStringMakeConstantString("MFTongXin_Noncommercial-Regular")
        
        print("\(fontName)")
        
        let fontRef:AnyObject = CTFontCreateWithName(fontName, 25, nil)
        
        let attrString = NSAttributedString(string: string, attributes: [kCTFontAttributeName as String : fontRef])
        let line = CTLineCreateWithAttributedString(attrString as CFAttributedString)
        let runA = CTLineGetGlyphRuns(line)
        
        for (var runIndex = 0; runIndex < CFArrayGetCount(runA); runIndex++){
            let run = CFArrayGetValueAtIndex(runA, runIndex);
            let runb = unsafeBitCast(run, CTRun.self)
            let  CTFontName = unsafeBitCast(kCTFontAttributeName, UnsafePointer<Void>.self)
            let runFontC = CFDictionaryGetValue(CTRunGetAttributes(runb),CTFontName)
            let runFontS = unsafeBitCast(runFontC, CTFont.self)
            let width = UIScreen.mainScreen().bounds.width
            
            var temp = 0
            var offset:CGFloat = 0.0
            
            //在这边修改应该可以修改横竖的方向
            for(var i = 0; i < CTRunGetGlyphCount(runb); i++){
                let range = CFRangeMake(i, 1)
                let glyph:UnsafeMutablePointer<CGGlyph> = UnsafeMutablePointer<CGGlyph>.alloc(1)
                glyph.initialize(0)
                let position:UnsafeMutablePointer<CGPoint> = UnsafeMutablePointer<CGPoint>.alloc(1)
                position.initialize(CGPointZero)
                CTRunGetGlyphs(runb, range, glyph)
                CTRunGetPositions(runb, range, position);
                
                let temp3 = CGFloat(position.memory.x)
                let temp2 = (Int) (temp3 / width)
                let temp1 = 0
                if(temp2 > temp1){
                    temp = temp2
                    offset = position.memory.x - (CGFloat(temp) * width)
                }
                let path = CTFontCreatePathForGlyph(runFontS,glyph.memory,nil)
                let x = position.memory.x - (CGFloat(temp) * width) - offset
                let y = position.memory.y - (CGFloat(temp) * 80)
                var transform = CGAffineTransformMakeTranslation(x, y)
                CGPathAddPath(paths, &transform, path)
                glyph.destroy()
                glyph.dealloc(1)
                position.destroy()
                position.dealloc(1)
            }
        }
        
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointZero)
        bezierPath.appendPath(UIBezierPath(CGPath: paths))
        
        return bezierPath
    }
}
