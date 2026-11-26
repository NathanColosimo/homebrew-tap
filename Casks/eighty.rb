cask "eighty" do
  version "0.1.7"
  sha256 "e8c2b2128ee284a8c49bb7f7c207c87fcee047ae590490735cca6081ced26837"

  url "https://github.com/NathanColosimo/eighty/releases/download/v#{version}/Eighty-#{version}.zip"
  name "Eighty"
  desc "Battery charge limit and heat protection for Apple silicon Macs"
  homepage "https://github.com/NathanColosimo/eighty"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :golden_gate # this macOS or later

  app "Eighty.app"
  binary "#{appdir}/Eighty.app/Contents/Helpers/eighty"

  # Homebrew runs uninstall directives on every upgrade too, so they only quit
  # the app. The background service runs from inside the app, so an upgrade
  # restarts it on the new version. Zap stops it and removes its files.
  uninstall quit: "dev.eighty.menubar"

  zap launchctl: "dev.eighty.daemon",
      delete:    [
        "/Library/Application Support/eighty",
        "/Library/Logs/eighty",
      ],
      trash:     "~/Library/Preferences/dev.eighty.menubar.plist"

  caveats <<~EOS
    Open Eighty from Applications, click its menu bar icon, choose
    "Turn On Background Service", and allow Eighty in System Settings.

    To also remove its settings and logs when uninstalling, use:
      brew uninstall --zap --cask eighty
  EOS
end
