.PHONY: openapi
openapi: openapi-http openapi-dart-client

.PHONY: openapi-http
openapi-http:
	@./scripts/openapi-http.sh torrent src/http http

.PHONY: openapi-dart-client
openapi-dart-client:
	rm -rf api/generated/torrent
	@./scripts/openapi-dart-client.sh torrent api/generated/torrent
	rm -rf api/generated/torrent/test