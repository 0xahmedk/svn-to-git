# SVN to Git Migration Script

This script helps you migrate a Subversion (SVN) repository to a Git repository using `git-svn`. Follow the steps below to perform the migration.

### Step 1: Configure Project Variables

Open the `configs.sh` file and fill in the required variables:

```bash
PROJECT_NAME="your_project_name"
SVN_HOST="your_svn_host"
TARGET_DIR="path/to/your/target/directory"
AUTHORS_FILE="path/to/your/authors/file"
```

Replace the placeholders with your specific values.

### Step 2: Import SVN Authors

Run the import-svn-authors.sh script to import SVN authors into the Git repository. Manually update the generated AUTHORS_FILE with correct name/email information for each new Git user. The script will provide the correct format.

```bash
./import-svn-authors.sh
```

### Step 3: Run the Import Repo Script

Run the import-svn-repo.sh script to initiate the actual migration. This process may take some time, so be patient.

```bash
./import-svn-repo.sh
```

While waiting for the migration to complete, feel free to enjoy a cup of coffee or a funny cat video. 🐱☕️

#### Optional Step: Update Commit Messages (if needed)

If you want to update commit messages, you can use the update-commit-messages.sh script. Refer to the script's documentation for details.

```bash
./update-commit-messages.sh
```

#### Bonus Script: Delete stale/unused branches that are imported by git-svn

If you want to delete extra branches, that are imported or duplicated by git-svn. Refer to the script's documentation for details.

```bash
./delete_unused_branches.sh
```

That's it! Your SVN repository should now be successfully migrated to a Git repository.

In this `README.md`, I've provided clear steps for configuring project variables, importing SVN authors, running the import repo script, and an optional step for updating commit messages. Feel free to customize the instructions to better fit your project's specific requirements.

### Important Notes

- Always create a backup of your SVN repository before migrating to Git.
- Carefully review and update authors and commit messages as needed.
- Be patient during the migration process, as it may take some time depending on the size of your repository.
  Enjoy your newly migrated Git repository!
