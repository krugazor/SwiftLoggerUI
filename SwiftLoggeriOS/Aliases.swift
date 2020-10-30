//
//  File.swift
//  SwiftLoggeriOS
//
//  Created by Nicolas Zinovieff on 10/23/20.
//

import Foundation
import UIKit
import SwiftUI

extension Image {
    init(nsImage: NSImage) {
        self.init(uiImage: nsImage)
    }
}

extension UIImage {
    var png : Data? {
        return self.pngData()
    }
}

extension UIScrollView {
    func scrollsToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: contentOffset.x,
                                   y: contentSize.height - bounds.height + adjustedContentInset.bottom)
        setContentOffset(bottomOffset, animated: animated)
    }
}

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}
