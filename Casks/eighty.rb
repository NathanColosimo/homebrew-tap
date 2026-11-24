cask "eighty" do
  version "0.1.2"
  sha256 "39eb3f51e598dc1a92464ee1e7b1caca1841a61bf068db9b36f001fb1e525961"

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
