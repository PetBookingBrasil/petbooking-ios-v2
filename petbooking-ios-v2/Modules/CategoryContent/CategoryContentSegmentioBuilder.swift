//
//  CategoryContentSegmentioBuilder.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 08/02/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

struct CategoryContentSegmentioBuilder {
    
    static func setupBadgeCountForIndex(_ segmentioView: Segmentio, index: Int) {
        segmentioView.addBadge(at: index, count: 10, color: .red)
    }
    
    static func buildSegmentioView(segmentioView: Segmentio, segmentioStyle: SegmentioStyle) {
        segmentioView.setup(content: segmentioContent(),
                            style: segmentioStyle,
                            options: segmentioOptions(segmentioStyle: segmentioStyle))
    }
    
    private static func segmentioContent() -> [SegmentioItem] {
        return [SegmentioItem(title: "LISTA", image: nil),
                SegmentioItem(title: "MAPA", image: nil)]
    }
    
    private static func segmentioOptions(segmentioStyle: SegmentioStyle) -> SegmentioOptions {
        var imageContentMode = UIViewContentMode.center
        switch segmentioStyle {
        case .imageBeforeLabel, .imageAfterLabel:
            imageContentMode = .center
            
        default:
            break
        }
        
        let horizontalSeparatorOptions = SegmentioHorizontalSeparatorOptions(type: .top, color: UIColor(hex: "B00021"))
        let verticalSeparatorOptions = SegmentioVerticalSeparatorOptions(ratio: 0, color: .clear)
        
        return SegmentioOptions(backgroundColor: UIColor(hex: "B00021"),
                                maxVisibleItems: 2,
                                scrollEnabled: false,
                                indicatorOptions: segmentioIndicatorOptions(),
                                horizontalSeparatorOptions: horizontalSeparatorOptions,
                                verticalSeparatorOptions: verticalSeparatorOptions,
                                imageContentMode: imageContentMode,
                                labelTextAlignment: .center,
                                labelTextNumberOfLines: 1,
                                segmentStates: segmentioStates(),
                                animationDuration: 0.3)
    }
    
    private static func segmentioStates() -> SegmentioStates {
        let font = UIFont.robotoRegular(ofSize: 13)
        return SegmentioStates(defaultState: segmentioState(backgroundColor: .clear,
                                                            titleFont: font,
                                                            titleTextColor: UIColor.white.withAlphaComponent(0.7)),
                               selectedState: segmentioState(backgroundColor: .clear,
                                                             titleFont: font,
                                                             titleTextColor: .white),
                               highlightedState: segmentioState(backgroundColor: .white,
                                                                titleFont: font,
                                                                titleTextColor: .gray))
    }
    
    private static func segmentioState(backgroundColor: UIColor, titleFont: UIFont, titleTextColor: UIColor) -> SegmentioState {
        return SegmentioState(backgroundColor: backgroundColor,
                              titleFont: titleFont,
                              titleTextColor: titleTextColor)
    }
    
    private static func segmentioIndicatorOptions() -> SegmentioIndicatorOptions {
        return SegmentioIndicatorOptions(type: .bottom,
                                         ratio: 0.8,
                                         height: 2,
                                         color: .white)
    }
    
    private static func segmentioHorizontalSeparatorOptions() -> SegmentioHorizontalSeparatorOptions {
        return SegmentioHorizontalSeparatorOptions(type: .bottom,
                                                   height: 0,
                                                   color: .white)
    }
    
    private static func segmentioVerticalSeparatorOptions() -> SegmentioVerticalSeparatorOptions {
        return SegmentioVerticalSeparatorOptions(ratio: 0,
                                                 color: .white)
    }
}

