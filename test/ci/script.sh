#!/bin/sh

cd $TARGET_DIR
bundle exec rake test:engines:all PLUGIN=$PLUGIN_NAME
