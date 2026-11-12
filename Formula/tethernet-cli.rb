# Command-line tool. The `tethernet` formula name belongs to the GUI; the CLI
# formula and its binary carry the tethernet-cli name.
class TethernetCli < Formula
  desc "Userspace RNDIS driver that exposes USB tethering devices as a macOS NIC"
  homepage "https://github.com/justsrc/Tethernet"
  url "https://github.com/justsrc/Tethernet/archive/refs/tags/v0.1.0-alpha1.tar.gz"
  sha256 "7967b56998b2e5be8876cd06b614636b59fb97d6098ad9e8ac3697c2eb85ff39"
  license "MIT"
  head "https://github.com/justsrc/Tethernet.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "libusb"
  # feth(if_fake) + Darwin BPF: macOS exclusive.
  # The actual minimum is 13.3 (due to libc++ std::to_chars availability annotations);
  # Homebrew only checks major versions, so 13.0–13.2 will encounter an explicit error during configure.
  depends_on macos: :ventura

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DTETHERNET_BUILD_TESTS=OFF",
           "-DTETHERNET_BUILD_BENCHMARKS=OFF",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      Creating the feth interface and opening /dev/bpf* requires root:
        sudo tethernet-cli

      Listing devices does not require root:
        tethernet-cli --list

      The GUI app is in another formula: brew install justsrc/tap/tethernet
    EOS
  end

  test do
    # Do not compare against Homebrew's version: on --HEAD install it is "HEAD-<sha>",
    # whereas the binary outputs PROJECT_VERSION from CMake.
    assert_match(/^Tethernet \d+\.\d+\.\d+ /, shell_output("#{bin}/tethernet-cli --version"))
    # Should exit cleanly even when no devices are plugged in (an RNDIS device is not required for testing).
    system bin/"tethernet-cli", "--list"
  end
end
