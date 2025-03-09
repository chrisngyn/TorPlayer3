# openapi_client.api.TorrentApi

## Load the API package
```dart
import 'package:openapi_client/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addTorrent**](TorrentApi.md#addtorrent) | **POST** /torrents | Add torrent
[**dropAllTorrents**](TorrentApi.md#dropalltorrents) | **DELETE** /torrents | Drop all torrents
[**getTorrent**](TorrentApi.md#gettorrent) | **GET** /torrents/{infoHash} | Get torrent
[**getTorrentFileStats**](TorrentApi.md#gettorrentfilestats) | **GET** /torrents/{infoHash}/files/{fileIndex}/stats | Get torrent file stats
[**getTorrentStats**](TorrentApi.md#gettorrentstats) | **GET** /torrents/{infoHash}/stats | Get torrent stats
[**listTorrents**](TorrentApi.md#listtorrents) | **GET** /torrents | List torrents


# **addTorrent**
> AddTorrent200Response addTorrent(addTorrentRequest)

Add torrent

Add torrent

### Example
```dart
import 'package:openapi_client/api.dart';

final api_instance = TorrentApi();
final addTorrentRequest = AddTorrentRequest(); // AddTorrentRequest | 

try {
    final result = api_instance.addTorrent(addTorrentRequest);
    print(result);
} catch (e) {
    print('Exception when calling TorrentApi->addTorrent: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **addTorrentRequest** | [**AddTorrentRequest**](AddTorrentRequest.md)|  | 

### Return type

[**AddTorrent200Response**](AddTorrent200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dropAllTorrents**
> dropAllTorrents(delete)

Drop all torrents

Drop all torrents

### Example
```dart
import 'package:openapi_client/api.dart';

final api_instance = TorrentApi();
final delete = true; // bool | Delete torrents

try {
    api_instance.dropAllTorrents(delete);
} catch (e) {
    print('Exception when calling TorrentApi->dropAllTorrents: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **delete** | **bool**| Delete torrents | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTorrent**
> Torrent getTorrent(infoHash)

Get torrent

Get torrent by info hash

### Example
```dart
import 'package:openapi_client/api.dart';

final api_instance = TorrentApi();
final infoHash = infoHash_example; // String | Torrent info hash

try {
    final result = api_instance.getTorrent(infoHash);
    print(result);
} catch (e) {
    print('Exception when calling TorrentApi->getTorrent: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infoHash** | **String**| Torrent info hash | 

### Return type

[**Torrent**](Torrent.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTorrentFileStats**
> Stats getTorrentFileStats(infoHash, fileIndex)

Get torrent file stats

Get torrent file stats

### Example
```dart
import 'package:openapi_client/api.dart';

final api_instance = TorrentApi();
final infoHash = infoHash_example; // String | Torrent info hash
final fileIndex = 56; // int | File index

try {
    final result = api_instance.getTorrentFileStats(infoHash, fileIndex);
    print(result);
} catch (e) {
    print('Exception when calling TorrentApi->getTorrentFileStats: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infoHash** | **String**| Torrent info hash | 
 **fileIndex** | **int**| File index | 

### Return type

[**Stats**](Stats.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTorrentStats**
> TorrentStats getTorrentStats(infoHash)

Get torrent stats

Get torrent stats

### Example
```dart
import 'package:openapi_client/api.dart';

final api_instance = TorrentApi();
final infoHash = infoHash_example; // String | Torrent info hash

try {
    final result = api_instance.getTorrentStats(infoHash);
    print(result);
} catch (e) {
    print('Exception when calling TorrentApi->getTorrentStats: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infoHash** | **String**| Torrent info hash | 

### Return type

[**TorrentStats**](TorrentStats.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listTorrents**
> ListTorrents200Response listTorrents()

List torrents

List of torrents

### Example
```dart
import 'package:openapi_client/api.dart';

final api_instance = TorrentApi();

try {
    final result = api_instance.listTorrents();
    print(result);
} catch (e) {
    print('Exception when calling TorrentApi->listTorrents: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ListTorrents200Response**](ListTorrents200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

