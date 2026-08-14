# Generee par scripts/render-homebrew-formula.sh — ne pas editer a la main.
# Les empreintes proviennent du SHA256SUMS publie avec la release v0.9.0.
class EcfCli < Formula
  desc "Manage remote terminal sessions for command-line coding tools"
  homepage "https://code-fleet.evo.camp"
  version "0.9.0"

  on_macos do
    on_arm do
      url "https://github.com/growms/ecf-releases/releases/download/v0.9.0/ecf-cli-darwin-arm64"
      sha256 "0a413f3a899afd5a76fe27f1a5e60d7870e40525ebe1edbe0e0f49660b1ccf19"
    end
    on_intel do
      url "https://github.com/growms/ecf-releases/releases/download/v0.9.0/ecf-cli-darwin-amd64"
      sha256 "61a3b4fab0d0af7738be77ed77d756b4c2a534fae012599962453e9b9f383535"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/growms/ecf-releases/releases/download/v0.9.0/ecf-cli-linux-arm64"
      sha256 "3712c63d5d4f27598f2a839935920e71e07ef8836006cdc44bef074ab1cfe475"
    end
    on_intel do
      url "https://github.com/growms/ecf-releases/releases/download/v0.9.0/ecf-cli-linux-amd64"
      sha256 "1865383dcc2583f0679a209eda715b961ac6873ed6cbe73352faf72ecfe27f28"
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
