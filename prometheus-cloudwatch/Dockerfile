FROM golang:1.19.8-alpine3.17 as builder
RUN apk add --no-cache git
RUN mkdir -p /go/src/github.com/cloudposse
WORKDIR /go/src/github.com/cloudposse
RUN git clone https://github.com/cloudposse/prometheus-to-cloudwatch.git
WORKDIR prometheus-to-cloudwatch
RUN go get && CGO_ENABLED=0 go build -v -o "./dist/bin/prometheus-to-cloudwatch" *.go


FROM alpine:3.8
RUN apk add --no-cache ca-certificates
COPY --from=builder /go/src/github.com/cloudposse/prometheus-to-cloudwatch /usr/bin/prometheus-to-cloudwatch
ENV PATH $PATH:/usr/bin
ENTRYPOINT ["prometheus-to-cloudwatch"]
