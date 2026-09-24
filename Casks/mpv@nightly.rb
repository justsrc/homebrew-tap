cask "mpv@nightly" do
  version "nightly-19"
  sha256 :no_check

  url "https://github.com/justsrc/mpv-builder/releases/download/nightly/mpv-macos-arm64.zip"
  name "mpv"
  desc "Media player (nightly build)"
  homepage "https://github.com/justsrc/mpv-builder"

  depends_on macos: :big_sur
  depends_on arch: :arm64

  app "mpv.app"
end
