import UIKit
import Flutter
import Supabase

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    Supabase.initialize(
      url: "https://acevqbdpzgbtqznbpgzr.supabase.co", // Replace with your Supabase URL
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFjZXZxYmRwemdidHF6bmJwZ3pyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE5NzcwOTcsImV4cCI6MjA2NzU1MzA5N30.0CUdl2VhvaBfKLLhMnU1yH2mL9cI01DtX6Hrtq48dyw" // Replace with your Supabase anon key
    )
    Supabase.instance.client.handleDeeplinks(url: url, options: options)
    return true
  }
}
