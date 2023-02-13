//
//  String+Extension.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import Foundation
import UIKit

extension String {
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex..<endIndex])
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func subString(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func subString(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func subString(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    var htmlToAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            return try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSMutableAttributedString()
        }
    }
}

extension UILabel {
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText

        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }

    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
    
    var numberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}


enum CustomDateFormatter {
    case yyyy_dash_MM_dash_dd_T_HH_colon_mm_colon_ssZZZZ
    case dd_MMMM_yyyy
    case MMMM_yyyy
    case yyyy_dash_MM_dash_dd_HH_colon_mm_colon_ss
    case hh_colon_mm_a
    case HH_colon_mm
    case MM_slash_dd_slash_yy
    case MM_slash_dd_slash_yyyy
    case dd_MMMM
    case EEEE_comma_dd_MMMM_yyyy
    case dd_MMM
    case dd
    case MMMM
    case dd_MMM_yyyy_HH_colon_mm_colon_ss
    case dd_MMM_yyyy_comma_HH_colon_mm
    case EEEE_comma_dd_MMM_yyyy_HH_colon_mm
    case dd_dash_MMM
    case yyyy_dash_MM_dash_dd_T_HH_colon_mm_colon_ss_dot_SSSZ
    case EEEE
    case dd_MMM_comma_hh_colon_mm_a
    case dd_MMM_yyyy_dash_HH_colon_mm_a
    case dd_slash_MM_slash_yyyy
    case HH_colon_mm_colon_ss_dash_HH_colon_mm_colon_ss
    case HH_colon_mm_dash_HH_colon_mm
    case dd_MMM_comma_hh_dot_mm
    case dd_MMM_comma_HH_dot_mm_
    case HH_dot_mm_
    case dd_dash_MM_dash_yyyy
    case EEEE_comma_dd_MMM_yyyy
    case dd_MMM_yyyy_HH_dot_mm
    case yyyy_dash_MM_dash_dd_T_HH_colon_mm_colon_ssZ
    case HH_colon_mm_colon_ss
    case yyyy_dash_MM_dash_dd_HH_colon_mm
    case dd_MMM_yyyy
    case dd_dash_MMM_dash_yyyy_HH_colon_mm
    case EEEE_comma_dd_MMM_yyyy_comma_Pukul_HH_colon_mm
    case dd_slash_MM_slash_yyyy_HH_colon_mm
    case yyyy_dash_MM_dash_dd
    case dd_MMMM_yyyy_HH_colon_mm_WIB
    case d_MMM
    case EEEE_comma_dd_MMM_yyyy_comma_HH_dot_mm
    case EEEE_comma_dd_MMMM_yyyy_HH_colon_mm_WIB
    case MMM_dd_comma_yyyy
    case dd_MM_yyyy_HH_colon_ss
    case yyyy
    
    public func formatter() -> DateFormatter {
        switch self {
        case .yyyy_dash_MM_dash_dd_T_HH_colon_mm_colon_ssZZZZ:
            return indonesianLocalFormatter(string: "yyyy-MM-dd'T'HH:mm:ssZZZZ")
        case .yyyy_dash_MM_dash_dd_HH_colon_mm_colon_ss://2019-08-09 10:10:10
            return indonesianLocalFormatter(string: "yyyy-MM-dd HH:mm:ss")
        case .dd_MMMM_yyyy:
            return indonesianLocalFormatter(string: "dd MMMM yyyy")
        case .MMMM_yyyy:
            return indonesianLocalFormatter(string: "MMMM yyyy")
        case .hh_colon_mm_a:
            return indonesianLocalFormatter(string: "hh:mm a")
        case .MM_slash_dd_slash_yy:
            return indonesianLocalFormatter(string: "MM/dd/yy")
        case .MM_slash_dd_slash_yyyy:
            return indonesianLocalFormatter(string: "MM/dd/yyyy")
        case .HH_colon_mm:
            return indonesianLocalFormatter(string: "HH:mm")
        case .dd_MMMM:
            return indonesianLocalFormatter(string: "dd MMMM")
        case .EEEE_comma_dd_MMMM_yyyy:
            return indonesianLocalFormatter(string: "EEEE, dd MMMM yyyy")
        case .dd_MMM:
            return indonesianLocalFormatter(string: "dd MMM")
        case .dd:
            return indonesianLocalFormatter(string: "dd")
        case .MMMM:
            return indonesianLocalFormatter(string: "MMMM")
        case .dd_MMM_yyyy_HH_colon_mm_colon_ss:
            return indonesianLocalFormatter(string: "dd MMM yyyy HH:mm:ss")
        case .dd_MMM_yyyy_comma_HH_colon_mm:
            return indonesianLocalFormatter(string: "dd MMM yyyy, HH:mm")
        case .EEEE_comma_dd_MMM_yyyy_HH_colon_mm:
            return indonesianLocalFormatter(string: "EEEE, dd MMM yyyy HH:mm")
        case .dd_dash_MMM:
            return indonesianLocalFormatter(string: "dd-MMM")
        case .yyyy_dash_MM_dash_dd_T_HH_colon_mm_colon_ss_dot_SSSZ:
            return indonesianLocalFormatter(string: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        case .EEEE:
            return indonesianLocalFormatter(string: "EEEE")
        case .dd_MMM_comma_hh_colon_mm_a:
            return indonesianLocalFormatter(string: "dd MMM, hh:mm a")
        case .dd_MMM_yyyy_dash_HH_colon_mm_a:
            return indonesianLocalFormatter(string: "dd MMM yyyy - HH:mm a")
        case .dd_slash_MM_slash_yyyy:
            return indonesianLocalFormatter(string: "dd/MM/yyyy")
        case .HH_colon_mm_colon_ss_dash_HH_colon_mm_colon_ss:
            return indonesianLocalFormatter(string: "HH:mm:ss - HH:mm:ss")
        case .HH_colon_mm_dash_HH_colon_mm:
            return indonesianLocalFormatter(string: "HH:mm - HH:mm")
        case .dd_MMM_comma_hh_dot_mm:
            return indonesianLocalFormatter(string: "dd MMM, hh.mm")
        case .dd_MMM_comma_HH_dot_mm_:
            return indonesianLocalFormatter(string: "dd MMM, HH.mm ")
        case .HH_dot_mm_:
            return indonesianLocalFormatter(string: "HH.mm ")
        case .dd_dash_MM_dash_yyyy:
            return indonesianLocalFormatter(string: "dd-MM-yyyy")
        case .EEEE_comma_dd_MMM_yyyy:
            return indonesianLocalFormatter(string: "EEEE, dd MMM yyyy")
        case .dd_MMM_yyyy_HH_dot_mm:
            return indonesianLocalFormatter(string: "dd MMM yyyy HH.mm")
        case .yyyy_dash_MM_dash_dd_T_HH_colon_mm_colon_ssZ:
            return indonesianLocalFormatter(string: "yyyy-MM-dd'T'HH:mm:ssZ")
        case .HH_colon_mm_colon_ss:
            return indonesianLocalFormatter(string: "HH:mm:ss")
        case .yyyy_dash_MM_dash_dd_HH_colon_mm:
            return indonesianLocalFormatter(string: "yyyy-MM-dd HH:mm")
        case .dd_MMM_yyyy:
            return indonesianLocalFormatter(string: "dd MMM yyyy")
        case .dd_dash_MMM_dash_yyyy_HH_colon_mm:
            return indonesianLocalFormatter(string: "dd-MM-yyyy HH:mm")
        case .EEEE_comma_dd_MMM_yyyy_comma_Pukul_HH_colon_mm:
            return indonesianLocalFormatter(string: "EEEE, dd MMM yyyy, 'Pukul' HH:mm")
        case .dd_slash_MM_slash_yyyy_HH_colon_mm:
            return indonesianLocalFormatter(string: "dd/MM/yyyy HH:mm")
        case .yyyy_dash_MM_dash_dd:
            return indonesianLocalFormatter(string: "yyyy-MM-dd")
        case .dd_MMMM_yyyy_HH_colon_mm_WIB:
            return indonesianLocalFormatter(string: "dd MMMM yyyy HH:mm 'WIB'")
        case .d_MMM:
            return indonesianLocalFormatter(string: "d MMM")
        case .EEEE_comma_dd_MMM_yyyy_comma_HH_dot_mm:
            return indonesianLocalFormatter(string: "EEEE, dd MMM yyyy, HH.mm")
        case .EEEE_comma_dd_MMMM_yyyy_HH_colon_mm_WIB:
            return indonesianLocalFormatter(string: "EEEE, dd MMMM yyyy HH:mm 'WIB'")
        case .MMM_dd_comma_yyyy:
            return indonesianLocalFormatter(string: "MMM dd, yyyy")
        case .dd_MM_yyyy_HH_colon_ss:
            return indonesianLocalFormatter(string: "dd-MM-yyyy HH:ss")
        case .yyyy:
            return indonesianLocalFormatter(string: "yyyy")
        }
    }
    
    private func indonesianLocalFormatter(string: String) -> DateFormatter {
        let localFormatter = DateFormatter.dataFormatter(string)
        localFormatter.locale = Locale(identifier: "ID")
        return localFormatter
    }
    
    public func stringFromDate(_ date: Date) -> String {
        return self.formatter().string(from: date)
    }
    
    public func dateFromString(_ string: String) -> Date? {
        return self.formatter().date(from: string)
    }
}
