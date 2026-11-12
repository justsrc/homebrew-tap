# GUI Tethernet.app. Built from source — locally compiled artifacts carry no quarantine flag,
# so ad-hoc signing allows them to run without a developer certificate (this is the
# distribution premise of the entire project; see docs/GUI-SPIKE.md in the repository).
#
# Privileged components are not installed here: the App guides a one-click installation on
# first launch (AEWP + administrator password).
# A Finder alias is also automatically created on first launch — brew runs even postinstall
# inside a sandbox and cannot write to /Applications (tested).
class Tethernet < Formula
  desc "Userspace RNDIS driver for macOS with a SwiftUI app"
  homepage "https://github.com/justsrc/Tethernet"
  url "https://github.com/justsrc/Tethernet/archive/refs/tags/v0.1.0-alpha1.tar.gz"
  sha256 "7967b56998b2e5be8876cd06b614636b59fb97d6098ad9e8ac3697c2eb85ff39"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/justsrc/tap"
    sha256 cellar: :any, arm64_golden_gate: "c50ef3127a442471a5d7c086215d6bf993a9e037399ae84197c86f09af13dfd5"
    sha256 cellar: :any, arm64_tahoe:       "124f470f301691d689f75a5591ff0f0b8ce6eea9887fcfebf19ce56bfd22227f"
  end

  depends_on "cmake" => :build
  # Linked at build time; dylib is embedded into the .app and no longer depends on Homebrew's copy at runtime.
  depends_on "libusb"
  # SwiftUI UI uses @Observable and ContentUnavailableView (the CLI formula
  # still supports 13.3; the two are independent).
  depends_on macos: :sonoma

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DTETHERNET_BUILD_TESTS=OFF",
           "-DTETHERNET_BUILD_BENCHMARKS=OFF",
           *std_cmake_args
    system "cmake", "--build", "build"
    # SwiftPM's built-in sandbox-exec cannot be nested inside Homebrew's build sandbox and must be disabled
    # (all Swift formulas in homebrew-core do this).
    system "gui/Scripts/build-gui.sh", "--swift-build-flags=--disable-sandbox"
    prefix.install "dist/Tethernet.app"
  end

  post_install_steps do
    # Homebrew patches Mach-O binaries in the keg according to its own rules after installation
    # (tested: it removes the @executable_path rpath equivalent to @loader_path in the executable
    # as a duplicate), and then re-signs them as bare binaries — which invalidates the bundle's
    # resource seal, causing codesign --verify --deep to report
    # "code has no resources but signature indicates they must be present".
    # Functionality is unaffected (@loader_path can still find the dylib); here we re-seal everything
    # with ad-hoc signing to restore the signature to a consistent state.
    run "/usr/bin/codesign",
        args: ["--force", "--deep", "--sign", "-", "{{prefix}}/Tethernet.app"]
  end

  def caveats
    <<~EOS
      To launch:
        open "#{opt_prefix}/Tethernet.app"
      On first launch, a Finder alias will be automatically created in /Applications,
      after which you can launch Tethernet directly via Spotlight.

      First launch will guide privileged component installation: click "Install the helper"
      and enter your administrator password once.
      To uninstall: first click "Uninstall the helper…" on the Manage page,
      then run:
        brew uninstall tethernet

      The CLI tool is a separate formula: brew install justsrc/tap/tethernet-cli
    EOS
  end

  test do
    app = prefix/"Tethernet.app"
    assert_predicate app/"Contents/MacOS/Tethernet", :executable?
    assert_predicate app/"Contents/Library/HelperTools/com.tethernet.helper", :executable?
    system "codesign", "--verify", "--deep", "--strict", app
  end
end
