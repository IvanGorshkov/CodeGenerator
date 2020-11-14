//
//  CenterTextLayer.swift
//  CenterTextLayer
//
//  Created by Cem Olcay on 12/04/2017.
//
//  http://stackoverflow.com/a/41518502/2048130
//

#if os(iOS) || os(tvOS)
  import UIKit
#elseif os(OSX)
  import AppKit
#endif

public class CenterTextLayer: CATextLayer {

  public override init() {
    super.init()
  }

  public override init(layer: Any) {
    super.init(layer: layer)
  }

  public required init(coder aDecoder: NSCoder) {
    super.init(layer: aDecoder)
  }

  public override func draw(in ctx: CGContext) {
    let height = self.bounds.size.height
    let fontSize = self.fontSize
    let yDiff = (height-fontSize)/2 - fontSize/10

    ctx.saveGState()
    ctx.translateBy(x: 0, y: yDiff)
    super.draw(in: ctx)
    ctx.restoreGState()
  }
}
