class FdkAac < Formula
  desc "Standalone library of the Fraunhofer FDK AAC code from Android"
  homepage "https://sourceforge.net/projects/opencore-amr/"
  url "https://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-3.0.0.tar.gz"
  sha256 "70b95857b958fb8f794489307a87845dde4cc1fcea060f3f29f40e4b2fe16c82"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/justsrc/homebrew-tap/releases/download/fdk-aac-3.0.0"
    sha256 cellar: :any, arm64_tahoe: "e6a2445ae24606411811c043c061ae2024e4eb34ec89f689a8c753790c033aaf"
  end

  head do
    url "https://git.code.sf.net/p/opencore-amr/fdk-aac.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-example"
    system "make", "install"
  end

  test do
    system bin/"aac-enc", test_fixtures("test.wav"), "test.aac"
    assert_path_exists testpath/"test.aac"
  end
end
