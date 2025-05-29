$repos = @(
    ".github",
    "Countdown",
    "the-ain-verse",
    "TestRepo",
    "Guess-the-Roll",
    "excel-selenium-app",
    "BlankCanvas",
    "RetirementCalculator",
    "DrumKit",
    "RandomPixelBox",
    "LavProjectICOMS",
    "photo-task-frontend",
    "photo-task-backend",
    "MyntraCucumber",
    "ContinueSequence",
    "CucumberNewBikes",
    "NewBikes"
)

$title = "[Hygiene] Apply README, CHANGELOG, SW, and Post-PR Fixes"

foreach ($repo in $repos) {
    Write-Host "Looking for open issues with title '$title' in $repo..."

    $issueNumbers = gh issue list --repo "ainstarc/$repo" --state open --json number,title --jq ".[] | select(.title -eq `"$title`") | .number" 2>$null

    foreach ($issueNumber in $issueNumbers) {
        Write-Host "Closing issue #$issueNumber in $repo..."
        gh issue close --repo "ainstarc/$repo" --number $issueNumber
    }
}
Write-Host "All specified issues have been closed."