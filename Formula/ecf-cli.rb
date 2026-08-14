# Generee par scripts/render-homebrew-formula.sh — ne pas editer a la main.
# Les empreintes proviennent du SHA256SUMS publie avec la release v0.8.0.
class EcfCli < Formula
  desc "Manage remote terminal sessions for command-line coding tools"
  homepage "https://code-fleet.evo.camp"
  version "0.8.0"

  on_macos do
    on_arm do
      url "https://github.com/growms/ecf-releases/releases/download/v0.8.0/ecf-cli-darwin-arm64"
      sha256 "99938d585753b5eeb66ff35e6a14aed5ead7ba578f43980b27cdda8542493e3c"
    end
    on_intel do
      url "https://github.com/growms/ecf-releases/releases/download/v0.8.0/ecf-cli-darwin-amd64"
      sha256 "5482c5b248a1d25877f81530f41e4449e447183e671c164137d69c8e02f57452"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/growms/ecf-releases/releases/download/v0.8.0/ecf-cli-linux-arm64"
      sha256 "1ec6a16fce9f7c99a30166aa97ce1dc249ef72552fc4377a21e07c414482afd7"
    end
    on_intel do
      url "https://github.com/growms/ecf-releases/releases/download/v0.8.0/ecf-cli-linux-amd64"
      sha256 "662ccfa4c88db3f7840a7dfd01dd3e0262bfa77cd62f284a01690925c729b859"
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
