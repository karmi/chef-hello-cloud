# Install cookbooks with:
#
#     $ berks install --path ./site-cookbooks/
#
# Pre-requisites:
#
# * [gecode](http://www.gecode.org)  : $ brew install gecode
# * `berkshelf` gem                  : $ gem install berkshelf

# Base
#------------------------------------------------------------------------------
cookbook 'build-essential'
cookbook 'apt'
cookbook 'curl'
cookbook 'vim'
cookbook 'git'
cookbook 'monit'

# Webserver
#------------------------------------------------------------------------------
cookbook 'nginx'
cookbook 'haproxy'

# Database
#------------------------------------------------------------------------------
cookbook 'postgresql', :git => "git://github.com/vhyza/postgresql.git"
cookbook 'redisio',    :git => "git://github.com/vhyza/redisio.git"

# Search
#------------------------------------------------------------------------------
cookbook 'java'
cookbook 'elasticsearch', :git => 'git://github.com/karmi/cookbook-elasticsearch.git'
