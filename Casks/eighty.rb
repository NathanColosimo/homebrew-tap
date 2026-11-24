cask "eighty" do
  version "0.1.1"
  sha256 "e0b5cee0b12fa12887e06a7d7851acef6651afa687a14a65982b09a9c5593471"

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

  # The app is ad-hoc signed, not notarized, so clear the download quarantine.
  # The declarative postflight_steps that brew style prefers have no xattr step.
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/Eighty.app"]
  end

  # Homebrew runs uninstall directives on every upgrade too, so the background
  # service (its own root-owned copy, unaffected by upgrades) is removed only by
  # zap. After an upgrade the app offers to update the service.
  uninstall quit: "dev.eighty.menubar"

  zap script: {
        executable:   "/Library/PrivilegedHelperTools/dev.eighty",
        args:         ["uninstall"],
        sudo:         true,
        must_succeed: false,
      },
      trash:  "~/Library/Preferences/dev.eighty.menubar.plist"

  caveats <<~EOS
    Open Eighty from Applications, then click its menu bar icon and choose
    "Install Background Service". Or, from a terminal: sudo eighty install

    To remove the background service when uninstalling, use:
      brew uninstall --zap --cask eighty
  EOS
end
