#!/bin/sh

# Disable authenticity checking for github.com
echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config

# Git repo of the Redmine

# Prepare Redmine
git clone --depth=100 $MAIN_REPO $TARGET_DIR
cd $TARGET_DIR
#git submodule update --init --recursive

# Copy over the already downloaded plugin 
cp -r ~/builds/*/$REPO_NAME vendor/plugins/$PLUGIN_DIR

#export BUNDLE_GEMFILE=$TARGET_DIR/Gemfile

bundle install --without=$BUNDLE_WITHOUT

echo "creating $DB database"
case $DB in
  "mysql" )
    mysql -e 'create database redmine_test;'
    cat > config/database.yml << EOF
test:
  adapter: mysql
  database: redmine_test
  username: postgres
EOF
    ;;
  "mysql2" )
    mysql -e 'create database redmine_test;'
    cat > config/database.yml << EOF
test:
  adapter: mysql2
  username: root
  encoding: utf8
  database: redmine_test
EOF
    ;;
  "postgres" )
    psql -c 'create database redmine_test;' -U postgres
    cat > config/database.yml << EOF
test:
  adapter: postgresql
  database: redmine_test
  username: postgres
EOF
    ;;
esac

bundle exec rake db:migrate
bundle exec rake db:migrate:plugins
