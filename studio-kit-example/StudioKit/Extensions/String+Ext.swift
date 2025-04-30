//
//  String+Ext.swift
//  harvest
//
//  Created by Kristian Wagner on 2025-02-12.
//

import Foundation

extension String {
    func convertDate(toFormat: String? = "dd MMM") -> String? {
        // Create a DateFormatter to parse the input ISO 8601 string
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ" // "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")

        // Attempt to convert the string into a Date object
        if let date = inputFormatter.date(from: self) {
            // Create another DateFormatter to convert the Date into the desired format
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = toFormat
            
            // Return the formatted date as a string
            return outputFormatter.string(from: date)
        } else {
            // Return nil if the string couldn't be parsed
            return self
        }
    }
    
    func isDateInPast() -> Bool {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = inputFormatter.date(from: self) {
            return date < Date()  // Compare date with the current date
        }
        
        return false // Return false if the date couldn't be parsed
    }
    
    func toLanguageName() -> String {
        let code = self
        
        // Get the display name in the current locale
        let locale = Locale.current
        
        // Get the language name in the current locale
        if let languageName = locale.localizedString(forLanguageCode: code) {
            // Capitalize the first letter
            return languageName.prefix(1).capitalized + languageName.dropFirst()
        }
        
        // Return the code if no name is found
        return code
    }
    
    static func randomAlphanumericString(length: Int) -> String {
        let lettersAndNumbers = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in lettersAndNumbers.randomElement()! })
    }
    
    static func createUuid() -> String {
        let length = 10
        let lettersAndNumbers = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in lettersAndNumbers.randomElement()! })
    }
    
    
}
