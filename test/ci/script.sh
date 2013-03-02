#!/bin/sh

cd $TARGET_DIR
bundle exec rake redmine:plugins:test RAILS_ENV=test
