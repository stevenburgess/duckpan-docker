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


# Create the user with a home directory
RUN useradd -m ddg

# The USER command can be used to change the user that runs all lines after its
# declaration.
USER ddg

# Install perlbrew, a tool that creates perl working environments in the users
# home directories
RUN curl -kL http://install.perlbrew.pl | /bin/bash
# This drops the perlbrew binary into ~/perl5/perlbrew/bin/perlbrew,
# You can then run the perbew installer to get the correct version of perl.
# Note that this does take a while!
RUN /home/ddg/perl5/perlbrew/bin/perlbrew install perl-5.16.3
# Install cpanm with our specific version of perl. This places the cpnam bin
# at /perl5/perlbrew/perls/perl-5.16.3/bin/cpanm
RUN curl -L http://cpanmin.us | /home/ddg/perl5/perlbrew/perls/perl-5.16.3/bin/perl - App::cpanminus

# This gets perlbrew, and importantly cpanm on your login bash
RUN 'echo "source ~/perl5/perlbrew/etc/bashrc" >> ~/.bashrc'

# This instance has problems with the tests for this package, so I install
# it without running the tests (-s)
RUN /home/ddg/perl5/perlbrew/perls/perl-5.16.3/bin/cpan -f -s Text::Xslate

# Actually install duckpan
RUN /home/ddg/perl5/perlbrew/perls/perl-5.16.3/bin/cpanm App::DuckPAN

