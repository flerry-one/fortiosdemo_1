import Foundation

// MARK: - Statistic
struct Statistic: Codable {
    var stats: [String: Stat]?
    var matches: [Match]?
}

// MARK: - Match
struct Match: Codable {
    var id: String?
    var title: String?
    var gameType: String?
    var matchesCount: Int?
    var stats: Stats?
    var date: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case gameType = "game_type"
        case matchesCount = "matches_count"
        case stats, date
    }
}

// MARK: - Stats
struct Stats: Codable {
    var score, outlived, timePlayed, top6: Kills?
    var kills, wins, top3: Kills?

    enum CodingKeys: String, CodingKey {
        case score, outlived
        case timePlayed = "time_played"
        case top6 = "top_6"
        case kills, wins
        case top3 = "top_3"
    }
}

// MARK: - Kills
struct Kills: Codable {
    var value: Int?
    var displayValue: String?
}

// MARK: - Stat
struct Stat: Codable {
    var value, percentile: Double?
    var displayValue: String?
}
