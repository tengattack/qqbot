FROM python:3-alpine

RUN adduser -D -u 1000 qqbot

COPY requirements.txt /app/qqbot/
WORKDIR /app/qqbot/
RUN pip install -r requirements.txt

COPY . /app/qqbot/
RUN mkdir -p /home/qqbot/.qqbot-tmp && chown -R qqbot:qqbot /home/qqbot/.qqbot-tmp

EXPOSE 8188 8189
VOLUME /home/qqbot/.qqbot-tmp

CMD ["sh", "-c", "chown qqbot:qqbot /home/qqbot/.qqbot-tmp && su qqbot -c 'python /app/qqbot/main.py'"]
