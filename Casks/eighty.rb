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
  depends_on macos: ">= :golden_gate"

  app "Eighty.app"
  binary "#{appdir}/Eighty.app/Contents/Helpers/eighty"

  # The app is ad-hoc signed, not notarized, so clear the download quarantine.
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/Eighty.app"]
  end

  # Stops the background service and leaves macOS's plain charge limit in place.
  uninstall quit:   "dev.eighty.menubar",
            script: {
              executable: "#{appdir}/Eighty.app/Contents/Helpers/eighty",
              args:       ["uninstall"],
              sudo:       true,
            }

  caveats <<~EOS
    Open Eighty from Applications, then click its menu bar icon and choose
    "Install Background Service". Or, from a terminal: sudo eighty install
  EOS
end
