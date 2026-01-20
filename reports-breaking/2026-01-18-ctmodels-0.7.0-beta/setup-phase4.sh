#!/bin/bash
# Script to setup Phase 4: OptimalControl adaptation
# Created: 2026-01-20

set -e  # Exit on error

REPO="control-toolbox/OptimalControl.jl"
BRANCH="breaking/ctmodels-0.7"
ISSUE_TITLE="Adapt to CTModels v0.7.x and integrate CTSolvers"
PR_TITLE="Adapt to CTModels v0.7.x and integrate CTSolvers"
LABELS="breaking-change,migration,phase-4"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Phase 4: OptimalControl Setup ===${NC}"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ISSUE_BODY_FILE="$SCRIPT_DIR/phase4-issue-body.md"
PR_BODY_FILE="$SCRIPT_DIR/phase4-pr-body.md"

# Step 1: Create GitHub Issue
echo -e "${YELLOW}Step 1: Creating GitHub Issue...${NC}"
if [ -f "$ISSUE_BODY_FILE" ]; then
    ISSUE_URL=$(gh issue create \
        --repo "$REPO" \
        --title "$ISSUE_TITLE" \
        --body-file "$ISSUE_BODY_FILE" \
        --label "$LABELS")
    
    # Extract issue number from URL
    ISSUE_NUMBER=$(echo "$ISSUE_URL" | grep -o '[0-9]*$')
    echo -e "${GREEN}✓ Issue created: $ISSUE_URL${NC}"
    echo -e "${GREEN}  Issue number: #$ISSUE_NUMBER${NC}"
else
    echo -e "${YELLOW}⚠ Issue body file not found: $ISSUE_BODY_FILE${NC}"
    echo -e "${YELLOW}  Skipping issue creation. Please create manually.${NC}"
    ISSUE_NUMBER="[REPLACE_WITH_ISSUE_NUMBER]"
fi
echo ""

# Step 2: Ask user to navigate to OptimalControl repo
echo -e "${YELLOW}Step 2: Branch Creation${NC}"
echo -e "${BLUE}Please navigate to your OptimalControl.jl repository and run:${NC}"
echo ""
echo "  cd /path/to/OptimalControl.jl"
echo "  git fetch --tags"
echo "  git checkout v1.1.8-beta"
echo "  git checkout -b $BRANCH"
echo "  git push -u origin $BRANCH"
echo ""
read -p "Press Enter once you've created the branch..."
echo ""

# Step 3: Create Pull Request
echo -e "${YELLOW}Step 3: Creating Pull Request...${NC}"
if [ -f "$PR_BODY_FILE" ]; then
    # Update PR body with issue number
    TEMP_PR_BODY=$(mktemp)
    sed "s/\[ISSUE_NUMBER\]/$ISSUE_NUMBER/g" "$PR_BODY_FILE" > "$TEMP_PR_BODY"
    
    PR_URL=$(gh pr create \
        --repo "$REPO" \
        --base main \
        --head "$BRANCH" \
        --title "$PR_TITLE" \
        --body-file "$TEMP_PR_BODY" \
        --label "$LABELS")
    
    rm "$TEMP_PR_BODY"
    echo -e "${GREEN}✓ Pull Request created: $PR_URL${NC}"
else
    echo -e "${YELLOW}⚠ PR body file not found: $PR_BODY_FILE${NC}"
    echo -e "${YELLOW}  Skipping PR creation. Please create manually.${NC}"
fi
echo ""

# Summary
echo -e "${BLUE}=== Setup Complete ===${NC}"
echo ""
echo -e "${GREEN}Issue:${NC} $ISSUE_URL"
echo -e "${GREEN}Branch:${NC} $BRANCH"
echo -e "${GREEN}PR:${NC} $PR_URL"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Adapt OptimalControl code to CTModels v0.7.x API"
echo "2. Integrate CTSolvers as dependency"
echo "3. Run tests and fix any failures"
echo "4. Update Project.toml"
echo "5. Register v2.0.0-beta in ct-registry"
echo ""
echo -e "${BLUE}See phase4-optimalcontrol-setup.md for detailed instructions${NC}"
