# Sets up this Windows machine to edit and publish the ThinkLink site via Claude Code.
# Safe to re-run any number of times: it checks first and only installs what's missing.
#
# Claude runs this for a new editor, reads the summary, and walks the person through
# any "ACTION NEEDED" item in plain language, then re-runs until everything is green.
#
#   powershell -ExecutionPolicy Bypass -File script/setup.ps1
#
$ErrorActionPreference = "Continue"
$RubyReq = "3.3"
$Actions = New-Object System.Collections.Generic.List[string]

function Say    ($m) { Write-Host "`n> $m" -ForegroundColor Cyan }
function Ok     ($m) { Write-Host "  [OK] $m" -ForegroundColor Green }
function Warn   ($m) { Write-Host "  [!]  $m" -ForegroundColor Yellow }
function Bad    ($m) { Write-Host "  [X]  $m" -ForegroundColor Red }
function Action ($m) { $Actions.Add($m); Write-Host "  ACTION NEEDED: $m" -ForegroundColor Magenta }
function Have   ($c) { [bool](Get-Command $c -ErrorAction SilentlyContinue) }

Set-Location (Join-Path $PSScriptRoot "..")

Say "Operating system"
Ok "Windows detected"

# ---------------------------------------------------------------------------
Say "Git"
if (Have git) { Ok "git $((git --version) -replace 'git version ','')" }
else { Action "Install Git for Windows: 'winget install Git.Git' then re-run." }

# ---------------------------------------------------------------------------
Say "GitHub CLI (for login + push)"
if (Have gh) { Ok "gh installed" }
elseif (Have winget) {
  Warn "installing gh via winget..."
  winget install --silent --accept-source-agreements --accept-package-agreements GitHub.cli | Out-Null
  if (Have gh) { Ok "gh installed" } else { Action "Run 'winget install GitHub.cli' then re-run." }
}
else { Action "Install the GitHub CLI from https://github.com/cli/cli#installation then re-run." }

# ---------------------------------------------------------------------------
Say "GitHub login"
if ((Have gh) -and (gh auth status 2>$null; $LASTEXITCODE -eq 0)) {
  $who = (gh api user -q .login 2>$null); if (-not $who) { $who = "authenticated" }
  Ok "logged in as $who"
}
elseif (Have gh) {
  Action "Run 'gh auth login' (choose GitHub.com -> HTTPS -> login with a browser), then re-run. You must be added as a collaborator on sschuez/thinklink first - see SETUP.md step 0."
}
else { Warn "skipping login check until gh is installed" }

# ---------------------------------------------------------------------------
Say "Ruby $RubyReq (with the MSYS2 devkit for native gems)"
$RubyOk = $false
if (Have ruby) {
  $cur = (ruby -e "print RUBY_VERSION" 2>$null)
  if ($cur -like "$RubyReq.*") { Ok "ruby $cur"; $RubyOk = $true }
  else { Warn "ruby $cur found, but $RubyReq.x is expected" }
}
if (-not $RubyOk) {
  if (Have winget) {
    Action "Install Ruby+Devkit: 'winget install RubyInstallerTeam.RubyWithDevKit.3.3', then open a NEW terminal and re-run. (After install, run 'ridk install' and pick option 3 if prompted, so native gems compile.)"
  } else {
    Action "Install Ruby $RubyReq via RubyInstaller (with the MSYS2 devkit) from https://rubyinstaller.org, then re-run."
  }
}

# ---------------------------------------------------------------------------
Say "Project gems (Jekyll + link checker)"
if ($RubyOk -and (Have bundle)) {
  bundle check 2>$null | Out-Null
  if ($LASTEXITCODE -eq 0) { Ok "gems already installed" }
  else {
    Warn "running 'bundle install'... (first run can take a couple of minutes)"
    bundle install *> $env:TEMP\thinklink_bundle.log
    if ($LASTEXITCODE -eq 0) { Ok "gems installed" }
    else {
      Bad "bundle install failed - see $env:TEMP\thinklink_bundle.log"
      Get-Content $env:TEMP\thinklink_bundle.log -Tail 8 | ForEach-Object { Write-Host "      $_" }
      Action "Fix the bundle error above (often a missing devkit - run 'ridk install') then re-run."
    }
  }
}
elseif ($RubyOk -and -not (Have bundle)) {
  gem install bundler | Out-Null
  if (Have bundle) { Ok "bundler installed" } else { Action "Run 'gem install bundler' then re-run." }
}
else { Warn "skipping gem install until Ruby $RubyReq is in place" }

# ---------------------------------------------------------------------------
Say "Build check"
if ($RubyOk -and (Have bundle)) {
  bundle check 2>$null | Out-Null
  if ($LASTEXITCODE -eq 0) {
    bundle exec jekyll build *> $null
    if ($LASTEXITCODE -eq 0) {
      Ok "site builds"
      bundle exec htmlproofer ./_site --disable-external --allow-hash-href *> $null
      if ($LASTEXITCODE -eq 0) { Ok "links and images check out" }
      else { Warn "link check reported issues - run 'bundle exec htmlproofer ./_site --disable-external --allow-hash-href' to see them" }
    }
    else { Bad "jekyll build failed - run 'bundle exec jekyll build' to see the error" }
  }
  else { Warn "skipping build check until gems are installed" }
}
else { Warn "skipping build check until gems are installed" }

# ---------------------------------------------------------------------------
Say "Summary"
if ($Actions.Count -eq 0) {
  Write-Host "  This machine is ready. Open this folder in Claude Code and you can start editing - see HOW-TO.md.`n" -ForegroundColor Green
  exit 0
}
else {
  Write-Host "  $($Actions.Count) thing(s) need a human before this machine is ready:" -ForegroundColor Yellow
  foreach ($a in $Actions) { Write-Host "    - $a" }
  Write-Host "`n  Do those, then run script/setup.ps1 again.`n"
  exit 1
}
