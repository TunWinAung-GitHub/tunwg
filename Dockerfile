FROM golang:1.20 as build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . ./
RUN --mount=type=cache,target=/root/.cache/go-build CGO_ENABLED=0 go build -ldflags="-w -s" -o bin/ ./tunwg

FROM alpine

RUN apk add -U --no-cache ca-certificates

COPY --from=build /app/bin/ /bin/

VOLUME /data
ENV TUNWG_PATH=/data

ENTRYPOINT ["/bin/tunwg"]