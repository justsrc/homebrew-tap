cask "mark-text" do
  arch arm: "arm64", intel: "x64"

  version "0.22.0"
  sha256 arm:   "ae4756d8446867ee927e346bcb67f858539efabf72f7ade24996acb84416fb35",
         intel: "b0c9567a747c3ec8b4ba7dde60ddf48af05cf231db6657001c6dd0fedfbcf514"

  url "https://github.com/marktext/marktext/releases/download/v#{version}/marktext-mac-#{arch}-#{version}.dmg"
  name "MarkText"
  desc "Markdown editor"
  homepage "https://github.com/marktext/marktext"

  auto_updates true
  depends_on macos: :monterey

  app "MarkText.app"

  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-rd", "com.apple.quarantine", "{{appdir}}/MarkText.app"],
        must_succeed: false
  end

  zap trash: [
    "~/Library/Application Support/marktext",
    "~/Library/Logs/marktext",
    "~/Library/Preferences/com.github.marktext.marktext.plist",
    "~/Library/Saved Application State/com.github.marktext.marktext.savedState",
  ]
end
