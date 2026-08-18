# Generee par scripts/render-homebrew-formula.sh — ne pas editer a la main.
# Les empreintes proviennent du SHA256SUMS publie avec la release v0.10.4.
class EcfCli < Formula
  desc "Manage remote terminal sessions for command-line coding tools"
  homepage "https://code-fleet.evo.camp"
  version "0.10.4"

  on_macos do
    on_arm do
      url "https://github.com/growms/ecf-releases/releases/download/v0.10.4/ecf-cli-darwin-arm64"
      sha256 "4cd97afd02b5507b4fc643cd3bb04472d4a6aac40cfdd2887694add75cb3f0c3"
    end
    on_intel do
      url "https://github.com/growms/ecf-releases/releases/download/v0.10.4/ecf-cli-darwin-amd64"
      sha256 "b1223b757a40dc99f78b421524a000b78ccea3cf9de3dd8bdf58de649a63f9f5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/growms/ecf-releases/releases/download/v0.10.4/ecf-cli-linux-arm64"
      sha256 "9bf582c7a5dd6c5e3f52770726a2185b661ca3c3dc515934f98a6c536893c39a"
    end
    on_intel do
      url "https://github.com/growms/ecf-releases/releases/download/v0.10.4/ecf-cli-linux-amd64"
      sha256 "c8bf04f2bd31ce485dc4db57d3d7f4c288066553322bcb392074d416f8fa7fb2"
    end
  end

  def install
    bin.install Dir["ecf-cli-*"].first => "ecf-cli"
    # Le daemon n'est pas publie comme actif de release : ecf-cli le porte
    # (ADR-046), et lui seul sait l'en sortir. Sans cette etape, le paquet
    # livrerait un programme dont le service n'a pas le binaire.
    #
    # Dans bin, pas dans libexec : le service vise le chemin opt du paquet
    # (#{opt_bin}/ecf-daemon), stable d'une version a l'autre — c'est le motif
    # de cloudflared, et c'est ce qui fait de "brew upgrade" une vraie mise a
    # jour du daemon plutot que d'un exemplaire que personne ne lance.
    # bin.install PRESERVE LE MODE DE LA SOURCE, et le fichier telecharge par
    # curl est en 0644 : c'est Homebrew qui rend bin/ executable APRES
    # def install. Sans ce chmod, l'appel ci-dessous echoue en EACCES chez
    # TOUS les utilisateurs — et Homebrew presente l'echec comme un probleme de
    # Command Line Tools, ce qui envoie chercher ailleurs. Constate sur la
    # release 0.10.1.
    chmod 0755, bin/"ecf-cli"
    system bin/"ecf-cli", "extract-daemon", bin/"ecf-daemon"
  end

  def caveats
    <<~CAVEAT
      Next step — connect this machine:

        ecf-cli install

      It asks for a key, tells you where to generate one, and sets up the
      background service.

      After every "brew upgrade", run it again:

        ecf-cli install

      This package carries two programs: ecf-cli, and the daemon the service
      runs. "brew upgrade" replaces both of them here — but it cannot touch
      the daemon the service is already running, because Homebrew's
      post-install step may only write inside its own prefix. Re-running
      "ecf-cli install" on a machine that is already connected asks for
      nothing and consumes no key: it keeps the machine identity, and puts
      this version's daemon in place.

      If you ran "ecf-cli install" before installing this package, a copy of
      the program may sit in ~/.local/bin and answer before this one. Then
      "brew upgrade" updates a copy nobody runs, and the next
      "ecf-cli install" puts back that copy's older daemon:

        command -v ecf-cli        # expect the Homebrew path
        rm ~/.local/bin/ecf-cli   # if it prints ~/.local/bin instead
        hash -r                   # your shell caches the path it resolved

      Before removing this package, undo the setup first:

        ecf-cli uninstall

      "brew uninstall" removes only this package. The background service, its
      configuration and its sessions stay behind — and once the program is
      gone, nothing is left to remove them.
    CAVEAT
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ecf-cli version")
    # Les DEUX binaires, a la meme version. Un paquet qui n'affirme que le CLI
    # ne dit rien du daemon qu'il vient de poser.
    assert_match version.to_s, shell_output("#{bin}/ecf-daemon version")
  end
end
