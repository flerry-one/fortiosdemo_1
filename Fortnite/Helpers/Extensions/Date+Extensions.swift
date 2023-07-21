import Foundation

extension Date {
    
    func dateInTimeZone(timeZoneIdentifier: String, dateFormat: String) -> String {
        let dtf = DateFormatter()
        dtf.timeZone = TimeZone(identifier: timeZoneIdentifier)
        dtf.dateFormat = dateFormat
        return dtf.string(from: self)
    }
    
}
