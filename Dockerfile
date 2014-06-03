# Every dockerfile needs a FROM statement, for this one I fully qualify
# this one to ensure that we get a current version of ubuntu, but ensure
# docker will not default to a new version when it comes out.
FROM ubuntu:14.04

MAINTAINER Steven Burgess steven.a.burgess@hotmail.com

RUN apt-get update
RUN apt-get install -y build-essential
# Multiple steps need curl installed, so lets get it
RUN apt-get install -y curl
# During the install of the duckpan, we found out we also need
RUN apt-get install -y libssl-dev


# This will be the dividing line, all above steps do not specify a user
# so they are done by root. Below are things done by the ddg user.


