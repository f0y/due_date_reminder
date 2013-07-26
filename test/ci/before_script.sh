#!/bin/sh

# Git repo of the Redmine

# Prepare Redmine
git clone --depth=100 $MAIN_REPO $TARGET_DIR
cd $TARGET_DIR
git checkout $BRANCH
#git submodule update --init --recursive

# Copy over the already downloaded plugin 
cp -r $CI_HOME plugins/$REPO_NAME

cp -r $TARGET_DIR/config/database.yml.example $TARGET_DIR/config/database.yml

#export BUNDLE_GEMFILE=$TARGET_DIR/Gemfile

bundle install --without=$BUNDLE_WITHOUT RAILS_ENV=test

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
    "sqlite" )
        cat > config/database.yml << EOF
test:
  adapter: sqlite3
  database: db/redmine.sqlite3
EOF
    ;;
esac

bundle exec rake db:drop db:create db:migrate $LOAD_DEFAULT_DATA redmine:plugins:migrate RAILS_ENV=test REDMINE_LANG=en
