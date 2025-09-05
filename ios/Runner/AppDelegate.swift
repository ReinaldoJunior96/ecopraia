import Flutter
import UIKit
// TODO: Descomentar quando adicionar a chave do Google Maps
// import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // TODO: Descomentar e inserir sua chave do Google Maps aqui
    // GMSServices.provideAPIKey("SUA_CHAVE_DO_GOOGLE_MAPS_AQUI")
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
