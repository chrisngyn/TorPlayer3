# openapi_client
API for managing torrents, this server run on local for desktop application.

This Dart package is automatically generated by the [OpenAPI Generator](https://openapi-generator.tech) project:

- API version: 1.0.0
- Generator version: 7.7.0
- Build package: org.openapitools.codegen.languages.DartClientCodegen

## Requirements

Dart 2.12 or later

## Installation & Usage

### Github
If this Dart package is published to Github, add the following dependency to your pubspec.yaml
```
dependencies:
  openapi_client:
    git: https://github.com/GIT_USER_ID/GIT_REPO_ID.git
```

### Local
To use the package in your local drive, add the following dependency to your pubspec.yaml
```
dependencies:
  openapi_client:
    path: /path/to/openapi_client
```

## Tests

TODO

## Getting Started

Please follow the [installation procedure](#installation--usage) and then run the following:

```dart
import 'package:openapi_client/api.dart';


final api_instance = StreamApi();
final infoHash = infoHash_example; // String | Torrent info hash
final fileIndex = 56; // int | File index

try {
    final result = api_instance.getTorrentStats(infoHash, fileIndex);
    print(result);
} catch (e) {
    print('Exception when calling StreamApi->getTorrentStats: $e\n');
}

```

## Documentation for API Endpoints

All URIs are relative to *http://localhost:8080*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*StreamApi* | [**getTorrentStats**](doc//StreamApi.md#gettorrentstats) | **GET** /torrents/{infoHash}/files/{fileIndex}/stats | Get torrent stats
*StreamApi* | [**streamFile**](doc//StreamApi.md#streamfile) | **GET** /torrents/{infoHash}/files/{fileIndex}/stream/{fileName} | Stream file
*TorrentApi* | [**addTorrent**](doc//TorrentApi.md#addtorrent) | **POST** /torrents | Add torrent
*TorrentApi* | [**dropAllTorrents**](doc//TorrentApi.md#dropalltorrents) | **DELETE** /torrents | Drop all torrents
*TorrentApi* | [**getTorrent**](doc//TorrentApi.md#gettorrent) | **GET** /torrents/{infoHash} | Get torrent
*TorrentApi* | [**listTorrents**](doc//TorrentApi.md#listtorrents) | **GET** /torrents | List torrents


## Documentation For Models

 - [AddTorrent200Response](doc//AddTorrent200Response.md)
 - [AddTorrentRequest](doc//AddTorrentRequest.md)
 - [File](doc//File.md)
 - [ListTorrents200Response](doc//ListTorrents200Response.md)
 - [Stats](doc//Stats.md)
 - [Torrent](doc//Torrent.md)


## Documentation For Authorization

Endpoints do not require authorization.


## Author



