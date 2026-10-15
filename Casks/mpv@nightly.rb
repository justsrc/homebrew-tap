cask "mpv@nightly" do
  version "nightly-36"
  sha256 :no_check

  url "https://github.com/justsrc/mpv-builder/releases/download/nightly/mpv-macos-arm64.zip"
  name "mpv"
  desc "Media player (nightly build)"
  homepage "https://github.com/justsrc/mpv-builder"

  depends_on arch: :arm64
  depends_on macos: :monterey

  app "mpv.app"
  binary "#{appdir}/mpv.app/Contents/MacOS/mpv"

  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-rd", "com.apple.quarantine", "{{appdir}}/mpv.app"],
        must_succeed: false
  end

  uninstall quit: "io.mpv"

  zap trash: [
    "~/Library/Application Support/CrashReporter/mpv_*.plist",
    "~/Library/Caches/io.mpv",
    "~/Library/Logs/DiagnosticReports/mpv-*.ips",
    "~/Library/Logs/mpv.log",
    "~/Library/Preferences/io.mpv.plist",
    "~/Library/Preferences/mpv.plist",
  ]
end
