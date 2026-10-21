class Dathan < Formula
  desc "Highlight source code to HTML, Hiccup or ANSI using Helix's grammars"
  homepage "https://github.com/waddie/dathan"
  url "https://github.com/waddie/dathan/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "090e5d1dc9dfa15f31224a2b05535c788e311894201886443c3182c45a252920"
  license "MIT"
  head "https://github.com/waddie/dathan.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/waddie/homebrew-brew/releases/download/dathan-0.10.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "15e910cec26d435d2b4ae32c1dadb0835f0182e3780613a843bd579d110ad5c3"
    sha256 cellar: :any,                 x86_64_linux: "a385188e444b438621a60ad74f929377a3c9226c14dfeb08e813bd4cec312efd"
  end

  depends_on "rust" => :build
  depends_on "helix" => :recommended

  # Homebrew's helix compiles its default languages.toml into hx and installs
  # no copy, so dathan can't find one next to the runtime. Pinned to the helix
  # version in homebrew-core; bump by hand when helix releases.
  resource "helix-languages" do
    url "https://raw.githubusercontent.com/helix-editor/helix/25.07.1/languages.toml"
    sha256 "128aa00d5ab81f8e61b75babc4b7c2bb5086528eea641c24813fa6a855e4d696"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    if build.with? "helix"
      system "cargo", "install", *std_cargo_args(root: libexec)
      pkgshare.install resource("helix-languages")

      # Only fill in helix's runtime when none is set, so a source checkout in
      # HELIX_RUNTIME keeps its own languages.toml. dathan still prefers
      # ~/.config/helix/runtime over both.
      (bin/"dathan").write <<~SH
        #!/bin/bash
        if [ -z "${HELIX_RUNTIME}" ]; then
          export HELIX_RUNTIME="#{formula_opt_libexec("helix")}/runtime"
          export DATHAN_LANGUAGES="${DATHAN_LANGUAGES:-#{opt_pkgshare}/languages.toml}"
        fi
        exec "#{opt_libexec}/bin/dathan" "$@"
      SH
    else
      system "cargo", "install", *std_cargo_args
    end
  end

  def caveats
    return if build.with? "helix"

    <<~EOS
      dathan needs a Helix runtime with compiled grammars. It looks in
      ~/.config/helix/runtime, then $HELIX_RUNTIME, or pass --runtime.
      It also needs a full languages.toml: pass --languages or set
      DATHAN_LANGUAGES.
    EOS
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/dathan --version")

    if build.with? "helix"
      (testpath/"hello.rs").write "fn main() {}\n"
      assert_match "main", shell_output("#{bin}/dathan --format html hello.rs")
    end
  end
end
