# 베이스 이미지 작성, AS 절에 단계 이름 지정
FROM golang:1.15-alpine3.12 AS gobuilder-stage
# 작성자와 설명을 작성
MAINTAINER kevin,lee <sjryu@dshub.cloud>
LABEL "purpose"="Service Deployment using Multi-stage builds."
# /usr/src/goapp 경로로 이동
WORKDIR /usr/src/goapp
# 현재 디렉토리의 goapp.go 파일을 이미지 내부의 현재 경로에 복사
COPY goapp.go .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /usr/local/bin/gostart
# 두 번째 단계, 두 번째 Dockerfile을 작성한 것과 같다. 베이스 이미지 작성.
FROM scratch AS runtime-stage
COPY --from=gobuilder-stage /usr/local/bin/gostart /usr/local/bin/gostart
# 컨테이너 실행시 파일 실행
CMD ["/usr/local/bin/gostart"]
