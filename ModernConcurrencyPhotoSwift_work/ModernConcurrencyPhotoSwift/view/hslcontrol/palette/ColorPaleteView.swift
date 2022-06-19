//
//  ColorPaleteView.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPaleteView: UIView {

    @IBOutlet weak var colorSampleView: UIView?
    @IBOutlet weak var slider: HSVSlider?
    @IBOutlet weak var colorButtonsList: UICollectionView?
    var tapGestureRecognizer:UITapGestureRecognizer?
    
    var adapter: ColorAdapter?
    weak var filterListener: FilterChangedListener?

    private var singleMode: Bool = false

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

        adapter = ColorAdapter()
        colorButtonsList?.register(UINib.init(nibName: ColorCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ColorCell.cellIdentifier)
        colorButtonsList?.dataSource = adapter
        colorButtonsList?.delegate = adapter

        changeMode(mode: singleMode)
        setupColor(hue: CGFloat(0)/360.0)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        self.slider?.addGestureRecognizer(tapGestureRecognizer!)
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: ColorPaleteView.self)
        let nib = UINib(nibName: "ColorPaleteView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    func setupData(colors: [ColorItem]) {
        self.adapter?.setupData(items: colors)
        self.adapter?.owner = self
        self.colorButtonsList?.reloadData()
    }
    
    private func changeMode(mode: Bool) {
        slider?.isHidden = !mode
        colorSampleView?.isHidden = !mode
        colorButtonsList?.isHidden = mode
    }
    
    private func setupColor(hue: CGFloat) {
        self.filterListener?.filterColorSelected(color: hue.colorForHue())
        self.colorSampleView?.backgroundColor = UIColor(hue: hue)
    }

    @IBAction func colorSelected(_ sender: HSVSlider) {
        let hue = sender.value
        setupColor(hue: CGFloat(hue)/ColorFilter.maxHue)
    }

    @IBAction func changePaletteMode(_ sender: Any) {
       singleMode = !singleMode
        changeMode(mode: singleMode)
        if (!singleMode) {
            filterListener?.needSetupFilter()
        }
    }
    
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        let pointTapped: CGPoint = gestureRecognizer.location(in: self.slider)
        if let slider = self.slider {
        let positionOfSlider: CGPoint = slider.frame.origin
        let widthOfSlider: CGFloat = slider.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(slider.maximumValue) / widthOfSlider)
        
        slider.setValue(Float(newValue), animated: true)
        setupColor(hue: CGFloat(newValue)/ColorFilter.maxHue)
        }
    }
    
    deinit {
        filterListener = nil
        self.adapter?.owner = nil
        self.colorButtonsList?.dataSource = nil
        self.colorButtonsList?.delegate = nil 
        if let gr = tapGestureRecognizer, let slider = self.slider {
         gr.removeTarget(self, action: #selector(sliderTapped(gestureRecognizer:)))
        slider.removeGestureRecognizer(gr)
        }
        tapGestureRecognizer = nil
    }
}

extension ColorPaleteView: ListOwner {
    func reload() {
        colorButtonsList?.reloadData()
    }

    func selectedItem(index: Int) {
        filterListener?.filterItemChanged(index: index)
    }
}
