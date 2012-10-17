Chef Server Hello Cloud
=======================

This repository contains a tutorial for [Chef Server](http://wiki.opscode.com/display/chef/Chef+Server).

It deploys a full-stack Ruby On Rails application on the following infrastructure:

* 1 load balancer running HAproxy
* 3 application servers
* 1 database server with PostgreSQL and Redis
* 2 elasticsearch servers in cluster

Exactly as prescribed:

![Hello World in Cloud](https://raw.github.com/karmi/chef-hello-cloud/master/hello-world-in-cloud.png)

The [`application`](tree/master/cookbooks/application/recipes) cookbook installs Ruby 1.9.3 via RVM, tweaks the PostgreSQL settings, searches Chef Server for database and elasticsearch nodes and stores their IPs in the configuration files, restores data from SQL dump and imports it into the search index.

The [`monitoring`](tree/master/cookbooks/monitoring/templates/default) cookbook ensures all parts of the stack are monitored via Monit.

There are two options how to install the stack: locally, with [Vagrant](http://vagrantup.com), and on [Amazon EC2](http://aws.amazon.com/ec2/).

The application being deployed is [Rubygems.org](https://rubygems.org), in a [specific version](https://github.com/karmi/rubygems.org/compare/search-steps) which adds full-text search using [elasticsearch](http://www.elasticsearch.org). See the [rubygems/rubygems.org#455](https://github.com/rubygems/rubygems.org/pull/455) issue for more information

Prerequisites
-------------

First, you need to have a valid Chef Server account, your user validation key, and your organization validation key.

Arguably the easiest way is to create a free account in [Hosted Chef](http://www.opscode.com/hosted-chef/), provided by Opscode.

You need to export the following environment variables for the provisioning scripts:

    export CHEF_ORGANIZATION='<your organization name>'
    export CHEF_ORGANIZATION_KEY='/path/to/your/your-organization-validator.pem'


Building the Stack in Vagrant
-----------------------------

Once you have your Chef Server credentials at hand, clone the repo:

    git clone git://github.com/karmi/chef-hello-cloud.git
    cd chef-hello-cloud

... install the required rubygems:

    bundle install

... install the site cookbooks with [Berkshelf](http://berkshelf.com):

    berks install --path ./site-cookbooks/

... upload the cookbooks to Chef Server:

    knife cookbook upload --all

... and finally, upload all roles to Chef Server:

    knife role from file roles/*.rb

If everything goes fine, build the simplified infrastructure in Vagrant:

    time vagrant up

The process should take between 30 and 50 minutes on a reasonable workstation with at least 4GB of RAM. It has been successfuly tested on Mac Book Air Mid 2011, Mac Book Pro Mid 2010 and iMac Mid 2009.


Building the Stack in Amazon EC2
--------------------------------

To build the stack in Amazon EC2, in addition to Chef Server credentials, you need to export the path to your private SSH key, downloaded from the AWS console:

    export SSH_IDENTITY_FILE='/path/to/your/name-ec2.pem'

After that, just create the servers with Rake commands.

First, create the `database` and `elasticsearch` servers:

    time rake server:create NAME=ec2-database ROLE=database
    time rake server:create NAME=ec2-elasticsearch-1 ROLE=elasticsearch
    time rake server:create NAME=ec2-elasticsearch-2 ROLE=elasticsearch

Once ready, create application servers:

    time rake server:create NAME=ec2-application-1 ROLE=application
    time rake server:create NAME=ec2-application-2 ROLE=application
    time rake server:create NAME=ec2-application-3 ROLE=application

Finally, create the load balancer server:

    time rake server:create NAME=ec2-load_balancer ROLE=load_balancer

After the stack is built, open the _Public DNS Name_ URL in your web browser. You should see Rubygems.org with some nice fulltext search features running (hint: click "Tips" on the `search` page).

----

(c) 2012 Karel Minarik & Vojtech Hyza. MIT License.
