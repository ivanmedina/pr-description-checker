# pr-description-checker
PR description pattern checker


### Simple use with default values:

```
name: description

on: [ pull_request ]

jobs:
  description: 
    runs-on: ubuntu-latest
    name: Chcke if pull request body description match pattern
    steps:
      - name: Pull request description checker
        uses: ivanmedina/pr-description-checker@main
        with:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### Simple use with default values:

```
name: description

on: [ pull_request ]

jobs:
  description: 
    runs-on: ubuntu-latest
    name: Chcke if pull request body description match pattern
    steps:
      - name: Pull request description checker
        uses: ivanmedina/pr-description-checker@main
        with:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          regex: '^[a-zA-z0-9]{0,100}'
          SUCCESS_EMOJI: '+1'
          SUCCESS_COMMENT: 'Ok'
          FAIL_EMOJI: '-1'
          FAIL_COMMENT: 'Error'
```