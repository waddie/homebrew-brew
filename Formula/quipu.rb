class Quipu < Formula
  desc "Script keyboard entry in the terminal"
  homepage "https://github.com/waddie/quipu"
  url "https://github.com/waddie/quipu/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "b97f68e4757310fa951154c75d5aaf69aac0c745d4653f3e66ff552134c425a0"
  license "AGPL-3.0-or-later"
  head "https://github.com/waddie/quipu.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/waddie/homebrew-brew/releases/download/quipu-0.4.0_1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "b5761a364e2b33a4827a71c3cb3532c5f06c4b490706c48eab2d1b333c915058"
    sha256 cellar: :any,                 x86_64_linux: "dbdbdaed232c14792fdf9a444c469c1d1874d99add7cdc3f2add38c7b04ed3be"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/quipu --version")

    (testpath/"bad.qp").write "$ <nope>\n"
    assert_match "unknown key <nope>", shell_output("#{bin}/quipu bad.qp 2>&1", 1)
  end
end
