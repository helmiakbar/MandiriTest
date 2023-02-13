//
//  FloatingPanelCustomLayout.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import Foundation
import FloatingPanel

class CustomPanelFullLayout: FloatingPanelLayout {
    var position: FloatingPanelPosition = .bottom
    var initialState: FloatingPanelState { .full }
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 20.0, edge: .top, referenceGuide: .safeArea)
        ]
    }

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
            return 0.3
        }
}

class ModalPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .full

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelIntrinsicLayoutAnchor(absoluteOffset: 0.0, referenceGuide: .safeArea),
        ]
    }

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.3
    }
}

class FixedHeightLayout: FloatingPanelLayout {
    private let height: CGFloat
    
    init(height: CGFloat) {
        self.height = height
    }
    
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .tip: FloatingPanelLayoutAnchor(absoluteInset: self.height, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.3
    }
}

class FixedTopHeightLayout: FloatingPanelLayout {
    private let height: CGFloat
    
    init(height: CGFloat) {
        self.height = height
    }
    
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .full
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: self.height, edge: .top, referenceGuide: .safeArea)
        ]
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.3
    }
}

class DynamicPanelLayout: FloatingPanelLayout {
    
    private let height: CGFloat
    
    init(height: CGFloat) {
        self.height = height
    }
    
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .tip: FloatingPanelLayoutAnchor(absoluteInset: self.height, edge: .bottom, referenceGuide: .safeArea),
            .full: FloatingPanelLayoutAnchor(absoluteInset: 20.0, edge: .top, referenceGuide: .safeArea)
        ]
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.3
    }
}
