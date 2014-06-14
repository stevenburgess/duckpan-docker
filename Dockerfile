# Every dockerfile needs a FROM statement, for this one I fully qualify
# this one to ensure that we get a current version of ubuntu, but ensure
# docker will not default to a new version when it comes out.
FROM ubuntu:14.04

FROM ubuntu:trusty
MAINTAINER Steven Burgess steven.a.burgess@hotmail.com
# With help from Chris Weyl <chris.weyl@wps.io>, who wrote a perlbrew installer
# at https://github.com/RsrchBoy/perlbrew-base-dock

RUN apt-get update
RUN apt-get install -y build-essential
# Multiple steps need curl installed, so lets get it
RUN apt-get install -y curl
# During the install of the duckpan, we found out we also need
RUN apt-get install -y libssl-dev

# prep for the install...
RUN umask 0022
RUN mkdir -p /usr/local/perlbrew /root
ENV HOME /root
ENV PERLBREW_ROOT /usr/local/perlbrew
ENV PERLBREW_HOME /root/.perlbrew

# install the standalone perlbrew and cpanm
RUN curl -kL http://install.perlbrew.pl | bash
ENV PATH /usr/local/perlbrew/bin:$PATH
ENV PERLBREW_PATH /usr/local/perlbrew/bin
# This drops the perlbrew binary into ~/perl5/perlbrew/bin/perlbrew,
# You can then run the perbew installer to get the correct version of perl.
# Note that this does take a while!
RUN perlbrew install perl-5.16.3
ENV PATH /usr/local/perlbrew/perls/perl-5.16.3/bin:$PATH
# Install cpanm with our specific version of perl. This places the cpnam bin
# at /perl5/perlbrew/perls/perl-5.16.3/bin/cpanm
RUN curl -L http://cpanmin.us | perl - App::cpanminus

# This instance has problems with the tests for this package, so I install
# it without running the tests (-s)
RUN cpan -f -s Text::Xslate

# Actually install duckpan
RUN cpanm App::DuckPAN

