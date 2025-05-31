# This script uses GitHub CLI (gh) to ensure all your repositories have a consistent set of issue labels.
# It defines standard labels, fetches your repositories, and creates any missing labels in each repo.


# Parameters
$UserName = "ainstarc"

# Define labels with corrected names, colors, and descriptions
$Labels = @(
    @{ Name = "audio"; Color = "f29513"; Description = "Issues related to audio features" },
    @{ Name = "bug"; Color = "d73a4a"; Description = "Something isn't working" },
    @{Name = "cleanup"; Color = "fef2c0"; Description = "For code and repo cleanup" },
    @{ Name = "design"; Color = "ffb86c"; Description = "UI/UX and design improvements" },
    @{ Name = "documentation"; Color = "0075ca"; Description = "Improvements or additions to docs" },
    @{ Name = "duplicate"; Color = "cfd3d7"; Description = "This issue or PR is a duplicate" },
    @{ Name = "enhancement"; Color = "a2eeef"; Description = "New feature or request" },
    @{ Name = "fallback"; Color = "5319e7"; Description = "Fallback feature or issue" },
    @{ Name = "good first issue"; Color = "7057ff"; Description = "Good for newcomers" },
    @{ Name = "help wanted"; Color = "008672"; Description = "Extra attention is needed" },
    @{Name = "hygiene"; Color = "fef2c0"; Description = "General repo upkeep and standardization" },
    @{ Name = "improvement"; Color = "bfdadc"; Description = "General improvement suggestions" },
    @{ Name = "invalid"; Color = "e4e669"; Description = "This doesn't seem right" },
    @{ Name = "maintenance"; Color = "fef2c0"; Description = "General label for repository upkeep tasks" }
    @{ Name = "needs feedback"; Color = "f9d0c4"; Description = "Waiting for feedback or input" },
    @{ Name = "needs reproduction"; Color = "cccccc"; Description = "Needs a reproducible example" },
    @{ Name = "PWA"; Color = "5319e7"; Description = "Progressive Web App related" },
    @{ Name = "performance"; Color = "fef2c0"; Description = "Performance related issue" },
    @{ Name = "question"; Color = "d876e3"; Description = "Further information is requested" },
    @{ Name = "refactor"; Color = "d4c5f9"; Description = "Refactoring code with no change in behavior" },
    @{ Name = "responsive"; Color = "0a0a0a"; Description = "Responsive design related" },
    @{ Name = "security"; Color = "ee0701"; Description = "Security vulnerability or concern" },
    @{ Name = "service-worker"; Color = "4c1d95"; Description = "Service worker related" },
    @{ Name = "testing"; Color = "1d76db"; Description = "Test coverage or reliability issues" },
    @{ Name = "wontfix"; Color = "ffffff"; Description = "This will not be worked on" },
    @{ Name = "obsolete"; Color = "cccccc"; Description = "No longer relevant due to redesign or deprecation" },
    @{ Name = "legacy"; Color = "9e9e9e"; Description = "Applies to the previous version of the platform/site" },
    @{ Name = "archived"; Color = "586e75"; Description = "Kept for reference, not to be worked on" },
    @{ Name = "deprecated"; Color = "cccccc"; Description = "No longer supported or recommended" }

)


# Fetch all repos under the user/org
Write-Host "Fetching repositories for user/org '$UserName'..."
$reposJson = gh repo list $UserName --limit 100 --json name
$repos = ($reposJson | ConvertFrom-Json).name

foreach ($repo in $repos) {
    Write-Host "Processing repo: $repo"

    # Get existing labels in repo
    $labelsJson = gh label list -R "$UserName/$repo" --json name
    $existingLabels = ($labelsJson | ConvertFrom-Json).name

    foreach ($label in $Labels) {
        $labelName = $label.Name
        $labelColor = $label.Color
        $labelDescription = $label.Description

        if ($existingLabels -contains $labelName) {
            Write-Host "Label '$labelName' already exists in $repo. Skipping..."
        }
        else {
            Write-Host "Creating label '$labelName' in $repo"
            gh label create $labelName --color $labelColor --description "$labelDescription" -R "$UserName/$repo"
        }
    }
}

Write-Host "Done processing labels."
