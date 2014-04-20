#
# AnsibleShipyard/base-ubuntu-nginx
#   docker build -t AnsibleShipyard/base-ubuntu-nginx .
#
# Requires:
# AnsibleShipyard/base-ubuntu
#   https://github.com/AnsibleShipyard/base-ubuntu
#

FROM AnsibleShipyard/base-ubuntu
MAINTAINER AnsibleShipyard

# Working dir
ENV WORKDIR /tmp/build/nginx
ENV NGINX_PREFIX /usr/local/nginx

# ADD
ADD meta $WORKDIR/meta
ADD tasks $WORKDIR/tasks
ADD tests $WORKDIR/tests
ADD vars $WORKDIR/vars
ADD templates $WORKDIR/templates
ADD handlers $WORKDIR/handlers

# Here we continue to use add because
# there are a limited number of RUNs
# allowed.
ADD tests/inventory /etc/ansible/hosts
ADD tests/playbook.yml $WORKDIR/playbook.yml

# Execute
RUN ansible-playbook $WORKDIR/playbook.yml -c local

# TODO: in debug mode, leave. Prod, cleanup
# Cleanup
# RUN rm -R $WORKDIR

EXPOSE 80

# Safely assume that since we FROM'd the base ubuntu
# that the nginx bin is in the default location
# CMD $NGINX_PREFIX/sbin/nginx -c $NGINX_PREFIX/conf/nginx.conf
CMD /usr/bin/test ! -f /etc/init.d/nginx; $NGINX_PREFIX/sbin/nginx -c $NGINX_PREFIX/conf/nginx.conf
