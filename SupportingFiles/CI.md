## CI

Usually CI should contain following jobs:

* run tests on any commit using *runTests* lane
* Create a build using *staging* lane for new commits in staging branch
* Create a build using *production* lane for new commits in production branch
* Once a day scheduled job to upload DSYM files to Fabric using *refresh_dsyms* lane

## Running tests

To make Jenkins run builds on each push:

```
Мастер проекта на гитлабе должен добавить hook вида http://ci.mlsdev.com/git/notifyCommit?url=<gitlab URL>[&branches=branch1[,branch2]*], где "gitlab URL" - адрес используемый для клонирования репозитория. В настройках проекта jenkins'а должна стоять галочка "Poll SCM" ("Опрашивать SCM об изменениях")

После этих манипуляций Jenkins будет собирать проект после пуша в ветку
```

To run tests using bundler(read Bundler.md file):

```
bundle install
bundle exec fastlane runTests
```

Add post-build hook to send emails about failures to team members.

## Making build for Staging server:

```
security unlock-keychain -p $KEYCHAIN_PASSWD /Users/jenkins/Library/Keychains/login.keychain
bundle install
bundle exec fastlane staging
```

## Making build for Release server:

```
security unlock-keychain -p $KEYCHAIN_PASSWD /Users/jenkins/Library/Keychains/login.keychain
bundle install
bundle exec fastlane production
```

## Job once a day to upload DSYMS

Use @daily macros in schedule field on Jenkins

```
security unlock-keychain -p $KEYCHAIN_PASSWD /Users/jenkins/Library/Keychains/login.keychain
bundle install
bundle exec fastlane refresh_dsyms
```
