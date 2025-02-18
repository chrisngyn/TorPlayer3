# openapi_client.api.StreamApi

## Load the API package
```dart
import 'package:openapi_client/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**streamFile**](StreamApi.md#streamfile) | **GET** /stream/{infoHash}/files/{fileIndex}/{fileName} | Stream file
[**streamVideoFile**](StreamApi.md#streamvideofile) | **GET** /stream/{infoHash}/videos/{fileIndex}/{fileName} | Stream video file


# **streamFile**
> MultipartFile streamFile(infoHash, fileIndex, fileName)

Stream file

Stream file from torrent

### Example
```dart
import 'package:openapi_client/api.dart';

final api_instance = StreamApi();
final infoHash = infoHash_example; // String | Torrent info hash
final fileIndex = 56; // int | File index
final fileName = fileName_example; // String | File name

try {
    final result = api_instance.streamFile(infoHash, fileIndex, fileName);
    print(result);
} catch (e) {
    print('Exception when calling StreamApi->streamFile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infoHash** | **String**| Torrent info hash | 
 **fileIndex** | **int**| File index | 
 **fileName** | **String**| File name | 

### Return type

[**MultipartFile**](MultipartFile.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **streamVideoFile**
> MultipartFile streamVideoFile(infoHash, fileIndex, fileName)

Stream video file

Stream video file from torrent

### Example
```dart
import 'package:openapi_client/api.dart';

final api_instance = StreamApi();
final infoHash = infoHash_example; // String | Torrent info hash
final fileIndex = 56; // int | File index
final fileName = fileName_example; // String | File name

try {
    final result = api_instance.streamVideoFile(infoHash, fileIndex, fileName);
    print(result);
} catch (e) {
    print('Exception when calling StreamApi->streamVideoFile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infoHash** | **String**| Torrent info hash | 
 **fileIndex** | **int**| File index | 
 **fileName** | **String**| File name | 

### Return type

[**MultipartFile**](MultipartFile.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: video/mp4

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

