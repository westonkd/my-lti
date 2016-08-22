FROM instructure/ruby-passenger:2.2

USER root
RUN apt-get update && apt-get install -y nodejs

ENV APP_HOME /usr/src/app/

RUN mkdir -p $APP_HOME

ADD . $APP_HOME
WORKDIR $APP_HOME

RUN bundle install --system

RUN chown -R docker:docker $APP_HOME

USER docker

CMD ["bin/startup"]
