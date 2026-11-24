cask "radicle-desktop" do
  version "0.19.0"
  sha256 "4a84f6e182fd9c21bf79c4578398b8884aba70644c5125ba3d14b7d43e1965b6"

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
