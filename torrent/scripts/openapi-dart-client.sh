
readonly service="$1"
readonly output_dir="$2"

openapi-generator-cli generate -i "api/openapi/$service.yml" -g dart -o "$output_dir" \
  --additional-properties pubName=openapi_client,pubPublishTo=none