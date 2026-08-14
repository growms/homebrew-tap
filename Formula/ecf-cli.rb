# Generee par scripts/render-homebrew-formula.sh — ne pas editer a la main.
# Les empreintes proviennent du SHA256SUMS publie avec la release v0.7.0.
class EcfCli < Formula
  desc "Manage remote terminal sessions for command-line coding tools"
  homepage "https://code-fleet.evo.camp"
  version "0.7.0"

  on_macos do
    on_arm do
      url "https://github.com/growms/ecf-releases/releases/download/v0.7.0/ecf-cli-darwin-arm64"
      sha256 "096c319447f8d760a61fec3de8a7ff799a9273e4ebcddaf02787186c7462725b"
    end
    on_intel do
      url "https://github.com/growms/ecf-releases/releases/download/v0.7.0/ecf-cli-darwin-amd64"
      sha256 "b57a2e987f6b2e806941db3e48efb5134bb20286e4f00db58a1a00a1ac806a4e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/growms/ecf-releases/releases/download/v0.7.0/ecf-cli-linux-arm64"
      sha256 "a8565e28674ac25a7bbef3e48a20bfdde3c70ac2e9db46375a62006c231e54c6"
    end
    on_intel do
      url "https://github.com/growms/ecf-releases/releases/download/v0.7.0/ecf-cli-linux-amd64"
      sha256 "cc374ffa845b49e3df738cc36dd010ba90d774b798bf71e90922378e31ddc2d0"
    end
  end

  def install
    bin.install Dir["ecf-cli-*"].first => "ecf-cli"
  end

  def caveats
    <<~CAVEAT
      Next step — connect this machine:

        ecf-cli install

      It asks for a key, tells you where to generate one, and sets up the
      background service.

      Two things worth knowing about this package:

      1. "ecf-cli install" also places a copy of the program in
         ~/.local/bin, and it tells you to put that directory first on your
         PATH. That copy then answers before this one. "brew upgrade" updates
         only the Homebrew copy, so after upgrading, re-run "ecf-cli install"
         to refresh the copy and the background service.

      2. "brew upgrade" never touches the running service. The service keeps
         the version it was installed with until you re-run "ecf-cli install".

      Before removing this package, undo the setup first:

        ecf-cli uninstall

      "brew uninstall" removes only this copy of the program. The background
      service, its configuration, its sessions and the copy in ~/.local/bin
      stay behind — and once the program is gone, nothing is left to remove
      them.
    CAVEAT
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ecf-cli version")
  end
end
