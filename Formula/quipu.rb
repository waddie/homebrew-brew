class Quipu < Formula
  desc "Script keyboard entry in the terminal"
  homepage "https://github.com/waddie/quipu"
  url "https://github.com/waddie/quipu/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "19610cead2abadc5942646df750610c2aeddffb0a35c9af752595e8ad63c8af5"
  license "AGPL-3.0-or-later"
  revision 1
  head "https://github.com/waddie/quipu.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
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
