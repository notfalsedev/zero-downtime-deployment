#!/bin/bash
set -e

# Change this
GIT_REMOTE_URL='ssh://github.com/laravel/laravel.git'
BASE_DIR=/app

TAG=$1
HTTP_DIR=$BASE_DIR/www
RELEASE_DIR=$BASE_DIR/releases/$TAG

# Symlink the release
function move_symlink {
  mkdir -p $HTTP_DIR
  rm -Rf $HTTP_DIR
  ln -sf $RELEASE_DIR $HTTP_DIR
}

# The artisan commands
function artisan {
  # Run database migrations
  php artisan migrate --no-interaction --force

  # Run optimization commands for Laravel
  php artisan optimize
  php artisan cache:clear
  php artisan route:cache
  php artisan view:clear
  php artisan config:cache
}

read -p "Move release to $TAG? " -n 1 -r
echo # move to a new line

if [[ $REPLY =~ ^[Yy]$ ]]
then
  if [[ -d $RELEASE_DIR ]]
  then
    cd $RELEASE_DIR

    # Do artisan stuff
    artisan

    # Move symlink to release
    move_symlink
  else
    # Create folder structure for releases if necessary
    mkdir -p $RELEASE_DIR
    cd $RELEASE_DIR

    # Fetch the release files from git as a tar archive and unzip
    git archive \
        --remote=$GIT_REMOTE_URL \
        --format=tar \
        $TAG \
        | tar xf -

    # Install laravel dependencies with composer
    composer install -o --no-interaction --no-dev

    # Create symlinks to `data`
    ln -sf $BASE_DIR/data/.env ./
    rm -rf storage && ln -sf $BASE_DIR/data/storage ./
    rm -rf public/files && ln -sf $BASE_DIR/data/files ./public

    # Do artisan stuff
    artisan

    # Move symlink to release
    move_symlink
  fi
fi