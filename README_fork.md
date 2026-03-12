# Fork info

## Rebase

Fetch tags from upstream:

Only the first time, add upstream:

```bash
git remote add upstream https://github.com/nextcloud/user_oidc.git
git remote -v
```

Fetch tags and list them:

```bash
git fetch upstream --tags
git tag -l
```

Work only on the dedicated branch called `garr`.

When a new tag appears, rebase it to build the new version on our custom branch as well:

- Sync the fork without discarding commit on main branch

```bash
git checkout main
git pull main
```

- Rebase the tag into the custom branch

```bash
git checkout garr
git rebase <tag_name>
```

Resolve conflicts if any:

```bash
git add .
git rebase --continue
git push origin garr --force-with-lease
```

### `composer.lock`

`composer.lock` is a generated file and often conflicts when rebasing upstream tags.

Instead of resolving conflicts manually, it is usually safer to **delete it and
regenerate it** so Composer rebuilds a consistent dependency tree.

```bash
rm composer.lock
composer install or ./build_with_docker.sh composer
```

## Build

Run .github/workflows/krankerl-build.yml manually on `garr` branch to build the app
