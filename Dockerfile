FROM alpine
ADD inner-ss /usr/local/bin/
CMD inner-ss -v -c /data/config.json
EXPOSE 1086