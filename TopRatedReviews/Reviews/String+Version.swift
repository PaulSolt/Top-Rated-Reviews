//
//  String+Version.swift
//  ReviewDownloaderMac
//
//  Created by Paul Solt on 9/6/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import Foundation


// Helper tools for comparing version strings
extension String {
    
    // Based Endy Silveira's mod: https://gist.github.com/endy-s/3791fe5c856cccaabff331fd49356dbf
    var rawVersion: String {
        let str = deletingPrefix("v")
                    .split(separator: "-")
                    .first
        return String(str ?? "")
    }
    
    // https://www.hackingwithswift.com/example-code/strings/how-to-remove-a-prefix-from-a-string
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    // And DragonCherry extension: https://github.com/DragonCherry/VersionCompare
    func compare(toVersion targetVersion: String) -> ComparisonResult {
        let versionDelimiter = "."
        var result: ComparisonResult = .orderedSame
        var versionComponents = components(separatedBy: versionDelimiter)
        var targetComponents = targetVersion.components(separatedBy: versionDelimiter)
        
        while versionComponents.count < targetComponents.count {
            versionComponents.append("0")
        }
        while targetComponents.count < versionComponents.count {
            targetComponents.append("0")
        }
        
        for (version, target) in zip(versionComponents, targetComponents) {
            result = version.compare(target, options: .numeric)
            if result != .orderedSame {
                break
            }
        }
        
        return result
    }
    
    func isVersion(equalTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedSame }
    func isVersion(greaterThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedDescending }
    func isVersion(greaterThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedAscending }
    func isVersion(lessThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedAscending }
    func isVersion(lessThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedDescending }
}


