//
//  Supabase.swift
//  SecuRide
//
//  Created by Om Rajpal on 7/21/24.
//


import Foundation
import OSLog
import Supabase

let supabase = SupabaseClient(
  supabaseURL: URL(string: "https://bdhvlsqtkvhbukvbnsfl.supabase.co")!,
  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJkaHZsc3F0a3ZoYnVrdmJuc2ZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjEzOTYxNjAsImV4cCI6MjAzNjk3MjE2MH0.CWZYcMb1F3OjQfpDtGeSVUIj7MIj4EdIVZ1YN4yvyKQ",
  options: .init(
    global: .init(logger: AppLogger())
  )
)

struct AppLogger: SupabaseLogger {
  let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "supabase")

  func log(message: SupabaseLogMessage) {
    switch message.level {
    case .verbose:
      logger.log(level: .info, "\(message.description)")
    case .debug:
      logger.log(level: .debug, "\(message.description)")
    case .warning, .error:
      logger.log(level: .error, "\(message.description)")
    }
  }
}
