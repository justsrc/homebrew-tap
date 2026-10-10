cask "radicle-desktop" do
  version "0.17.0"
  sha256 "e1362cfbeabd9117f3e8e1a57a886677e70bb3eceb0d8446c5181bc7631eeeb0"

  url "https://files.radicle.dev/releases/radicle-desktop/#{version}/radicle-desktop-aarch64.dmg"
  name "Radicle"
  desc "Desktop client for the Radicle peer-to-peer code collaboration network"
  homepage "https://radicle.dev/"

  livecheck do
    url "https://files.radicle.dev/releases/radicle-desktop/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  depends_on arch: :arm64
  depends_on :macos

  app "Radicle.app"

  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-rd", "com.apple.quarantine", "{{appdir}}/Radicle.app"],
        must_succeed: false
  end

  zap trash: [
    "~/Library/Application Support/xyz.radicle.desktop",
    "~/Library/Caches/xyz.radicle.desktop",
    "~/Library/WebKit/xyz.radicle.desktop",
  ]
end
