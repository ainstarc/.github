# This script uses GitHub CLI (gh) to remove an incorrect label and ensure the correct "cleanup" label exists
# across all repositories for the specified user.

# Parameters
$UserName = "ainstarc"

# Labels to ensure exist (correct names only)
$Labels = @(
    @{Name = "cleanup"; Color = "fef2c0"; Description = "For code and repo cleanup" }
)

# Incorrect label to remove
$IncorrectLabel = "@cleanup"

# Fetch all repos under the user/org
Write-Host "Fetching repositories for user/org '$UserName'..."
$reposJson = gh repo list $UserName --limit 100 --json name
$repos = ($reposJson | ConvertFrom-Json).name

foreach ($repo in $repos) {
    Write-Host "`nProcessing repo: $repo"

    # Get existing labels in repo
    $labelsJson = gh label list -R "$UserName/$repo" --json name
    $existingLabels = ($labelsJson | ConvertFrom-Json).name

    # Remove incorrect label if exists
    if ($existingLabels -contains $IncorrectLabel) {
        Write-Host "Removing incorrect label '$IncorrectLabel' from $repo..."
        gh label delete $IncorrectLabel -R "$UserName/$repo" --yes
    }
    else {
        Write-Host "Incorrect label '$IncorrectLabel' not found in $repo."
    }

    # Ensure correct labels exist
    foreach ($label in $Labels) {
        $labelName = $label.Name
        $labelColor = $label.Color
        $labelDescription = $label.Description

        if ($existingLabels -contains $labelName) {
            Write-Host "Label '$labelName' already exists in $repo. Skipping creation..."
        }
        else {
            Write-Host "Creating label '$labelName' in $repo..."
            gh label create $labelName --color $labelColor --description "$labelDescription" -R "$UserName/$repo"
        }
    }
}

Write-Host "`nLabel fix process completed."
