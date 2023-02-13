//
//  FloatingPanelControllerHelper.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import FloatingPanel

class FloatingPanelControllerHelper {
    
    class func createFloatingPanelController(isRemovalInteractionEnabled: Bool = true, enableDismissTapGesture: Bool = true) -> FloatingPanelController {
        
        let fpc = FloatingPanelController()
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 8.0
        appearance.backgroundColor = .clear
        
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = .black
        shadow.offset = CGSize(width: 0, height: 16)
        shadow.radius = 16
        shadow.spread = 8
        appearance.shadows = [shadow]
        
        fpc.surfaceView.appearance = appearance
        fpc.contentMode = .fitToBounds
        fpc.isRemovalInteractionEnabled = isRemovalInteractionEnabled
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = isRemovalInteractionEnabled
        
        return fpc
    }
    
}
