FROM brigadecore/go-tools:v0.4.0

ARG VERSION
ARG COMMIT
ENV CGO_ENABLED=0

WORKDIR /
COPY . /
COPY go.mod go.mod
COPY go.sum go.sum

RUN go build \
  -o bin/dockerhub-gateway \
  -ldflags "-w -X github.com/brigadecore/brigade-foundations/version.version=$VERSION -X github.com/brigadecore/brigade-foundations/version.commit=$COMMIT" \
  .

FROM scratch
COPY --from=0 /bin/ /brigade-dockerhub-gateway/bin/
ENTRYPOINT ["/brigade-dockerhub-gateway/bin/dockerhub-gateway"]
