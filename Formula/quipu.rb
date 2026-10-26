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
    root_url "https://github.com/waddie/homebrew-brew/releases/download/quipu-0.4.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "c805131a0f6c9b68d7af94cacb4f323a3b02f3b2ce4c735bdf9d5c1e5561ca18"
    sha256 cellar: :any,                 x86_64_linux: "52b38034e0cf4e5500fbf36fac2ca10c54f8809ff2c47d355ce2b72a740b5d19"
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
