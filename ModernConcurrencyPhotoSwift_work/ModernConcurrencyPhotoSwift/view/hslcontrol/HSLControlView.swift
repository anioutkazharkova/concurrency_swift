//
//  HSLControlView.swift
//  HSLImageProcessing
//
//  Created by 1 on 06.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class HSLControlView: UIView {

    private var sense: CGFloat = 0.15
    weak var listener: ColorChangedListener?
    weak var filterListener: FilterChangedListener? {
        didSet {
            colorPalette?.filterListener = filterListener
        }
    }

    var selectedFilter: ColorFilter? = nil {
        didSet {
            self.selectedFilter?.sense = sense
            setupSliders(color: selectedColor)
        }
    }

    var selectedColor: UIColor {
        get {
            return selectedFilter?.defaultColor.getColor() ?? UIColor.red
        }
    }

    var currentColor: UIColor = UIColor.red

    var currentHue: Float? {
        get {
            return hueSlider?.value
        }
    }

    var currentSat: Float? {
        get {
            return satSlider?.value
        }
    }

    var currentLum: Float? {
        get {
            return lumSlider?.value
        }
    }

    @IBOutlet weak var hueSlider: GradientSlider?

    @IBOutlet weak var satSlider: GradientSlider?

    @IBOutlet weak var lumSlider: GradientSlider?

    @IBOutlet weak var colorPalette: ColorPaleteView?
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initContent()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initContent()
    }

    private  func initContent() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: HSLControlView.self)
        let nib = UINib(nibName: "HSLControlView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

        return view
    }

  
    @IBAction func hueChanged(_ sender: Any) {
        colorChanged()
        resetForHue()
    }

    @IBAction func satChanged(_ sender: Any) {
        colorChanged()
    }

    @IBAction func lumChanged(_ sender: Any) {
        colorChanged()
       resetForLum()
    }
    
    func setupColors(colors: [ColorItem]) {
        colors[0].isSelected = true
        colorPalette?.setupData(colors: colors)
    }
    
    //Передача интенсивности текущему фильтру
    func changeIntencity(sense: CGFloat) {
        self.sense = sense
        self.selectedFilter?.sense = sense
        listener?.colorChanged(filter: selectedFilter!)
    }
    
    
    func changeFilter(filter: ColorFilter) {
        if let hue = currentHue, let sat = currentSat, let lum = currentLum {
            selectedFilter?.selectedHue = CGFloat(hue)
            selectedFilter?.selectedSat = CGFloat(sat)
            selectedFilter?.selectedLum = CGFloat(lum)
        }
        self.selectedFilter = filter
        self.selectedFilter?.sense = sense
    }
    
   private func setupSliders(color: UIColor) {
        hueSlider?.addGradient(colors: color.createColorSet())
        satSlider?.addGradient(colors: [color.cgColor, color.cgColor])
        lumSlider?.addGradient(colors: color.createLumSet())
        hueSlider?.value = Float(selectedFilter?.selectedHue ?? 0)
        satSlider?.value = Float(selectedFilter?.selectedSat ?? 1)
        lumSlider?.value = Float(selectedFilter?.selectedLum ?? ColorFilter.lumStart)
    }

   private func colorChanged() {
        if let hue = currentHue, let sat = currentSat, let lum = currentLum {
            selectedFilter?.selectedHue = CGFloat(hue)
            selectedFilter?.selectedSat = CGFloat(sat)
            selectedFilter?.selectedLum = CGFloat(lum)
            listener?.colorChanged(filter: selectedFilter!)
        }
    }

    //При смене цвета изменить бегунки насыщенности и светлоты
  private  func resetForHue() {
        if let hue = currentHue, let lum = currentLum {
            currentColor = selectedColor.hslColor(hue: selectedColor.normalizeHue(shift: CGFloat(hue)/ColorFilter.maxHue), sat: 1, lum: CGFloat(lum)/ColorFilter.lumDiv)
            satSlider?.addGradient(colors: [currentColor.cgColor, currentColor.cgColor])
            lumSlider?.addGradient(colors: currentColor.colorWithLum(lum: selectedColor.hsl!.lightness).createLumSet())
        }
    }

//При смене светлоты изменить бегунки цвета и насыщенности
  private  func resetForLum() {
        if let hue = currentHue, let lum = currentLum {
            currentColor = selectedColor.hslColor(hue: selectedColor.normalizeHue(shift: CGFloat(hue)/ColorFilter.maxHue), sat: 1, lum: CGFloat(lum)/ColorFilter.lumDiv)
            hueSlider?.addGradient(colors: currentColor.createColorSet())
            satSlider?.addGradient(colors: [currentColor.cgColor, currentColor.cgColor])

        }
    }

    deinit {
        listener = nil
        filterListener = nil
    }
}


