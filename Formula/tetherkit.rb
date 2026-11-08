# GUI TetherKit.app. Built from source — locally compiled artifacts carry no quarantine flag,
# so ad-hoc signing allows them to run without a developer certificate (this is the
# distribution premise of the entire project; see docs/GUI-SPIKE.md in the repository).
#
# Privileged components are not installed here: the App guides a one-click installation on
# first launch (AEWP + administrator password).
# A Finder alias is also automatically created on first launch — brew runs even postinstall
# inside a sandbox and cannot write to /Applications (tested).
class Tetherkit < Formula
  desc "Userspace RNDIS driver for macOS with a SwiftUI app"
  homepage "https://github.com/XiaoMiku01/TetherKit"
  url "https://github.com/XiaoMiku01/TetherKit/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "a99d5c8497fa9dc145ebbaf307350a7c9a8b5ae0be638a000f88cb627234690e"
  license "MIT"

  depends_on "cmake" => :build
  # Linked at build time; dylib is embedded into the .app and no longer depends on Homebrew's copy at runtime.
  depends_on "libusb"
  # SwiftUI UI uses @Observable and ContentUnavailableView (the CLI formula
  # still supports 13.3; the two are independent).
  depends_on macos: :sonoma

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DTETHERKIT_BUILD_TESTS=OFF",
           "-DTETHERKIT_BUILD_BENCHMARKS=OFF",
           *std_cmake_args
    system "cmake", "--build", "build"
    # SwiftPM's built-in sandbox-exec cannot be nested inside Homebrew's build sandbox and must be disabled
    # (all Swift formulas in homebrew-core do this).
    system "gui/Scripts/build-gui.sh", "--swift-build-flags=--disable-sandbox"
    prefix.install "dist/TetherKit.app"
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
        args: ["--force", "--deep", "--sign", "-", "{{prefix}}/TetherKit.app"]
  end

  def caveats
    <<~EOS
      To launch:
        open "#{opt_prefix}/TetherKit.app"
      On first launch, a Finder alias will be automatically created in /Applications,
      after which you can launch TetherKit directly via Spotlight.

      First launch will guide privileged component installation: click "Install Privileged Helper"
      and enter your administrator password once.
      To uninstall: first click "Uninstall Privileged Helper…" at the bottom of the App dashboard,
      then run:
        brew uninstall tetherkit

      The CLI tool is a separate formula: brew install justsrc/tap/tetherkit-cli
    EOS
  end

  test do
    app = prefix/"TetherKit.app"
    assert_predicate app/"Contents/MacOS/TetherKit", :executable?
    assert_predicate app/"Contents/Library/HelperTools/com.tetherkit.helper", :executable?
    system "codesign", "--verify", "--deep", "--strict", app
  end
end
