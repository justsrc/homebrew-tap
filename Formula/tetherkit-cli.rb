# Command-line tool. Renamed from `tetherkit` starting in v0.1.2 — that name now belongs to
# the GUI formula; the binary was simultaneously renamed to tetherkit-cli, functionality remains unchanged.
class TetherkitCli < Formula
  desc "Userspace RNDIS driver that exposes USB tethering devices as a macOS NIC"
  homepage "https://github.com/XiaoMiku01/TetherKit"
  url "https://github.com/XiaoMiku01/TetherKit/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "a99d5c8497fa9dc145ebbaf307350a7c9a8b5ae0be638a000f88cb627234690e"
  license "MIT"
  head "https://github.com/XiaoMiku01/TetherKit.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/justsrc/tap"
    sha256 cellar: :any, arm64_tahoe: "aa2db4137e62d76e819cbe44d72ecfeee4ca13c86e4607b54d7aecf0cb38bed3"
  end

  depends_on "cmake" => :build
  depends_on "libusb"
  # feth(if_fake) + Darwin BPF: macOS exclusive.
  # The actual minimum is 13.3 (due to libc++ std::to_chars availability annotations);
  # Homebrew only checks major versions, so 13.0–13.2 will encounter an explicit error during configure.
  depends_on macos: :ventura

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DTETHERKIT_BUILD_TESTS=OFF",
           "-DTETHERKIT_BUILD_BENCHMARKS=OFF",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      Creating the feth interface and opening /dev/bpf* requires root:
        sudo tetherkit-cli

      Listing devices does not require root:
        tetherkit-cli --list

      The GUI app is in another formula: brew install justsrc/tap/tetherkit
    EOS
  end

  test do
    # Do not compare against Homebrew's version: on --HEAD install it is "HEAD-<sha>",
    # whereas the binary outputs PROJECT_VERSION from CMake.
    assert_match(/^TetherKit \d+\.\d+\.\d+ /, shell_output("#{bin}/tetherkit-cli --version"))
    # Should exit cleanly even when no devices are plugged in (an RNDIS device is not required for testing).
    system bin/"tetherkit-cli", "--list"
  end
end
