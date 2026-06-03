# Fast, read-only readiness check: is this machine ready to edit and publish?
# Installs and changes NOTHING. Exit 0 = ready, exit 1 = not ready (run script/setup.ps1).
#
# Claude runs this once at the start of a session, before the first edit.
#
#   powershell -ExecutionPolicy Bypass -File script/check.ps1
#
$RubyReq = "3.3"
$Ready = $true
Set-Location (Join-Path $PSScriptRoot "..")

function Chk($label, $test) {
  $ok = $false
  try { $ok = (& $test) } catch { $ok = $false }
  if ($ok) { Write-Host "  [OK] $label" -ForegroundColor Green }
  else { Write-Host "  [X]  $label" -ForegroundColor Red; $script:Ready = $false }
}

Write-Host "Readiness check (read-only):"
Chk "git installed"          { [bool](Get-Command git -ErrorAction SilentlyContinue) }
Chk "GitHub CLI installed"   { [bool](Get-Command gh -ErrorAction SilentlyContinue) }
Chk "GitHub login active"    { gh auth status 2>$null | Out-Null; $LASTEXITCODE -eq 0 }
Chk "Ruby $RubyReq active"   { (Get-Command ruby -ErrorAction SilentlyContinue) -and ((ruby -e "print RUBY_VERSION" 2>$null) -like "$RubyReq.*") }
Chk "project gems installed" { bundle check 2>$null | Out-Null; $LASTEXITCODE -eq 0 }
Chk "site builds"            { bundle exec jekyll build *> $null; $LASTEXITCODE -eq 0 }

if ($Ready) {
  Write-Host "READY - this machine can edit and publish."
  exit 0
} else {
  Write-Host "NOT READY - run script/setup.ps1 to fix the [X] items above, then start editing."
  exit 1
}
