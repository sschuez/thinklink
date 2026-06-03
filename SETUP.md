# Per-machine setup (for the technical owner)

This is the one-time setup a **technical person** does on each editor's machine so a
non-coder can then manage content via the Claude Code desktop app (see `HOW-TO.md`).
The daily editing loop is non-technical; **this page is not.**

> **Designate an owner.** One person should own setup and repair across machines.
> When the toolchain breaks (a failed `bundle install`, an expired login, a port
> clash), the non-coder cannot fix it — they ping the owner. Put the owner's name and
> contact at the bottom of this file.

---

## Fast path: let the setup script do it

Most of this page is automated. On the new machine, open the `thinklink` folder in
Claude Code and say *"set up this machine"* — Claude runs the setup script, tells you
in plain language about anything that needs a human, and re-runs until it reports
**ready**. Or run it directly:

```bash
./script/setup                                              # macOS / Linux
powershell -ExecutionPolicy Bypass -File script/setup.ps1   # Windows
```

It's safe to re-run. It checks Git, the GitHub CLI + login, Ruby 3.3, the C toolchain
and the project gems; installs what it safely can; and prints `ACTION NEEDED` for steps
that need you (the Xcode tools dialog, `gh auth login`, a Ruby install). The one thing
it **can't** do for you is grant GitHub access — that's step 0 below, done once per
person from the repo settings. The rest of this page is the manual reference behind the
script and the troubleshooting guide.

Every script here is **idempotent** — safe to run any number of times. They check before
they act and only install what's missing, so re-running a fully-set-up machine changes
nothing. Claude also runs a fast read-only readiness check (`./script/check`) at the
start of each editing session and won't start editing until the machine reports ready.

---

## 0. GitHub access (do this once, per person)

Each editor pushes to GitHub **as their own GitHub account**, so each needs write access:

1. Each editor creates a GitHub account (free) and sends you their username.
2. Repo → **Settings → Collaborators and teams → Add people** → add each username with
   the **Write** role. (Today only `sschuez` can push — without this step, their
   "publish" fails at the very end.)
3. Each editor accepts the invitation from their email / GitHub notifications.

Avoid sharing one login across people — it breaks attribution and makes revoking access
messy.

---

## 1. Prerequisites (per machine)

### macOS

```bash
xcode-select --install          # C toolchain — some gems compile native extensions
brew install gh mise            # GitHub CLI + a Ruby version manager (or use asdf/rbenv)
mise use -g ruby@3.3            # match the version GitHub Pages builds with (see Gemfile.lock: 3.3)
```

If you prefer the system Ruby, it must still be 3.3.x. `mise` / `asdf` / `rbenv` are
more reliable than the macOS system Ruby.

### Windows

Use **RubyInstaller** (with the MSYS2 devkit, for native extensions) + **Git for
Windows** + the **GitHub CLI** (`winget install GitHub.cli`). The rest of the steps are
identical. Claude Code desktop runs on Windows too.

---

## 2. Clone and install (per machine)

```bash
gh auth login                   # choose GitHub.com → HTTPS → login via browser
git clone https://github.com/sschuez/thinklink.git
cd thinklink
bundle install                  # installs Jekyll + html-proofer into vendor/bundle
bundle exec jekyll serve        # confirm http://localhost:4000/ renders, then Ctrl-C
```

If `jekyll serve` shows the site, the machine is ready.

---

## 3. Claude Code desktop

1. Install the Claude Code desktop app and sign in.
2. Open the `thinklink` folder as the working directory.
3. The repo ships a shared `.claude/settings.json` that pre-approves the safe commands
   (build, serve, link-check, and `git` add/commit/push/pull), so the editor isn't
   prompted on every action. Personal overrides live in `.claude/settings.local.json`
   (git-ignored).
4. Hand the editor `HOW-TO.md`. That's all they need day-to-day.

---

## When it breaks — quick fixes (owner)

- **`bundle install` hangs on "Fetching source index", times out with "Failed to open
  TCP connection … execution expired"** — the network is routing IPv6 to a black hole
  and Ruby tries IPv6 first. Confirm with `curl -6 https://rubygems.org` (hangs) vs
  `curl -4 https://rubygems.org` (instant). Fixes: use a network with working IPv6, or
  temporarily disable IPv6 for the install. (We hit this once during initial setup.)
- **`bundle install` fails building a native gem (`io-event`, `ffi`)** — the C toolchain
  is missing. macOS: `xcode-select --install`. Windows: reinstall Ruby with the MSYS2
  devkit.
- **Publishing fails: "Permission denied" / "could not read Username" on push** — that
  account isn't a collaborator (step 0) or its login expired. Re-run `gh auth login`,
  or re-check the collaborator invite.
- **Publishing fails: "Updates were rejected … fetch first"** — the local copy is behind.
  Claude handles this automatically (pull-and-retry), but if needed:
  `git pull --rebase origin main` then push again.
- **`jekyll serve` says the port is in use** — an old preview is still running. Stop it,
  or serve on another port: `bundle exec jekyll serve --port 4001`.
- **The deploy (GitHub Actions) goes red** — open the repo's **Actions** tab; the failed
  step names the cause. The build + link-check must pass before the site updates.

---

**Setup owner:** _<name>_ — _<email / how to reach them>_
