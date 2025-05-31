# This script uses GitHub CLI (gh) to ensure a specific hygiene issue exists in each listed repository.
# If the issue already exists (by title), it updates the body; otherwise, it creates a new issue.

$repos = @(
    # ".github",
    # "Countdown",
    # "the-ain-verse",
    # "Guess-the-Roll",
    # "BlankCanvas",
    # "ContinueSequence",
    "github-repo-visualizer"
)

$title = "[Hygiene] Apply README, CHANGELOG, SW, and Post-PR Fixes"
$body = @"
This issue tracks repository-level hygiene tasks:

- [ ] Update or standardize README.md
- [ ] Add or update CHANGELOG.md
- [ ] Fix or remove Service Worker if not needed
- [ ] Complete post-PR cleanup tasks (formatting, etc.)
- [ ] Ensure all issues are closed
- [ ] Ensure all PRs are merged or closed
"@

foreach ($repo in $repos) {
    Write-Host "Checking for existing open issues with the title in $repo..."

    # Search for open issues with the exact title (case-sensitive)
    $existingIssueNumber = gh issue list --repo "ainstarc/$repo" --state open --json number, title --jq ".[] | select(.title -eq '$title') | .number" 2>$null

    if ($existingIssueNumber) {
        Write-Host "Found existing issue #$existingIssueNumber in $repo. Updating issue body..."
        gh issue edit --repo "ainstarc/$repo" --number $existingIssueNumber --body $body
    }
    else {
        Write-Host "No existing issue found in $repo. Creating a new issue..."
        gh issue create --repo "ainstarc/$repo" --title $title --body $body
    }
}
