# Building the binary of the App
FROM golang:1.19 AS build

WORKDIR /go/src/tasky
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/src/tasky/tasky

FROM alpine:3.17.0 as release

WORKDIR /app
# Add a echo message
RUN echo "This is the message for CI for github actions on $(date '+%Y-%m-%d %H:%M:%S') " > /app/exercise.txt

COPY --from=build  /go/src/tasky/tasky .
COPY --from=build  /go/src/tasky/assets ./assets
COPY field_exercise.pdf /app/field_exercise.pdf
EXPOSE 8080
ENTRYPOINT ["/app/tasky"]


