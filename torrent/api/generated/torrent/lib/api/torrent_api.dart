//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class TorrentApi {
  TorrentApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Add torrent
  ///
  /// Add torrent
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AddTorrentRequest] addTorrentRequest (required):
  Future<Response> addTorrentWithHttpInfo(AddTorrentRequest addTorrentRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/torrents';

    // ignore: prefer_final_locals
    Object? postBody = addTorrentRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Add torrent
  ///
  /// Add torrent
  ///
  /// Parameters:
  ///
  /// * [AddTorrentRequest] addTorrentRequest (required):
  Future<AddTorrent200Response?> addTorrent(AddTorrentRequest addTorrentRequest,) async {
    final response = await addTorrentWithHttpInfo(addTorrentRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AddTorrent200Response',) as AddTorrent200Response;
    
    }
    return null;
  }

  /// Cancel torrent
  ///
  /// Cancel torrent by info hash
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] infoHash (required):
  ///   Torrent info hash
  Future<Response> cancelTorrentWithHttpInfo(String infoHash,) async {
    // ignore: prefer_const_declarations
    final path = r'/torrents/{infoHash}/cancel'
      .replaceAll('{infoHash}', infoHash);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Cancel torrent
  ///
  /// Cancel torrent by info hash
  ///
  /// Parameters:
  ///
  /// * [String] infoHash (required):
  ///   Torrent info hash
  Future<void> cancelTorrent(String infoHash,) async {
    final response = await cancelTorrentWithHttpInfo(infoHash,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Delete torrent
  ///
  /// Delete torrent by info hash
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] infoHash (required):
  ///   Torrent info hash
  Future<Response> deleteTorrentWithHttpInfo(String infoHash,) async {
    // ignore: prefer_const_declarations
    final path = r'/torrents/{infoHash}/delete'
      .replaceAll('{infoHash}', infoHash);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete torrent
  ///
  /// Delete torrent by info hash
  ///
  /// Parameters:
  ///
  /// * [String] infoHash (required):
  ///   Torrent info hash
  Future<void> deleteTorrent(String infoHash,) async {
    final response = await deleteTorrentWithHttpInfo(infoHash,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Start download torrent
  ///
  /// Start download torrent by info hash
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] infoHash (required):
  ///   Torrent info hash
  Future<Response> downloadTorrentWithHttpInfo(String infoHash,) async {
    // ignore: prefer_const_declarations
    final path = r'/torrents/{infoHash}/download'
      .replaceAll('{infoHash}', infoHash);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Start download torrent
  ///
  /// Start download torrent by info hash
  ///
  /// Parameters:
  ///
  /// * [String] infoHash (required):
  ///   Torrent info hash
  Future<void> downloadTorrent(String infoHash,) async {
    final response = await downloadTorrentWithHttpInfo(infoHash,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Drop all torrents
  ///
  /// Drop all torrents
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [bool] delete:
  ///   Delete torrents
  Future<Response> dropAllTorrentsWithHttpInfo({ bool? delete, }) async {
    // ignore: prefer_const_declarations
    final path = r'/torrents';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (delete != null) {
      queryParams.addAll(_queryParams('', 'delete', delete));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Drop all torrents
  ///
  /// Drop all torrents
  ///
  /// Parameters:
  ///
  /// * [bool] delete:
  ///   Delete torrents
  Future<void> dropAllTorrents({ bool? delete, }) async {
    final response = await dropAllTorrentsWithHttpInfo( delete: delete, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get torrent
  ///
  /// Get torrent by info hash
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] infoHash (required):
  ///   Torrent info hash
  Future<Response> getTorrentWithHttpInfo(String infoHash,) async {
    // ignore: prefer_const_declarations
    final path = r'/torrents/{infoHash}'
      .replaceAll('{infoHash}', infoHash);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get torrent
  ///
  /// Get torrent by info hash
  ///
  /// Parameters:
  ///
  /// * [String] infoHash (required):
  ///   Torrent info hash
  Future<Torrent?> getTorrent(String infoHash,) async {
    final response = await getTorrentWithHttpInfo(infoHash,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Torrent',) as Torrent;
    
    }
    return null;
  }

  /// Get torrent file stats
  ///
  /// Get torrent file stats
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] infoHash (required):
  ///   Torrent info hash
  ///
  /// * [int] fileIndex (required):
  ///   File index
  Future<Response> getTorrentFileStatsWithHttpInfo(String infoHash, int fileIndex,) async {
    // ignore: prefer_const_declarations
    final path = r'/torrents/{infoHash}/files/{fileIndex}/stats'
      .replaceAll('{infoHash}', infoHash)
      .replaceAll('{fileIndex}', fileIndex.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get torrent file stats
  ///
  /// Get torrent file stats
  ///
  /// Parameters:
  ///
  /// * [String] infoHash (required):
  ///   Torrent info hash
  ///
  /// * [int] fileIndex (required):
  ///   File index
  Future<Stats?> getTorrentFileStats(String infoHash, int fileIndex,) async {
    final response = await getTorrentFileStatsWithHttpInfo(infoHash, fileIndex,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Stats',) as Stats;
    
    }
    return null;
  }

  /// Get torrent stats
  ///
  /// Get torrent stats
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] infoHash (required):
  ///   Torrent info hash
  Future<Response> getTorrentStatsWithHttpInfo(String infoHash,) async {
    // ignore: prefer_const_declarations
    final path = r'/torrents/{infoHash}/stats'
      .replaceAll('{infoHash}', infoHash);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get torrent stats
  ///
  /// Get torrent stats
  ///
  /// Parameters:
  ///
  /// * [String] infoHash (required):
  ///   Torrent info hash
  Future<TorrentStats?> getTorrentStats(String infoHash,) async {
    final response = await getTorrentStatsWithHttpInfo(infoHash,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TorrentStats',) as TorrentStats;
    
    }
    return null;
  }

  /// List torrents
  ///
  /// List of torrents
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listTorrentsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/torrents';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// List torrents
  ///
  /// List of torrents
  Future<ListTorrents200Response?> listTorrents() async {
    final response = await listTorrentsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ListTorrents200Response',) as ListTorrents200Response;
    
    }
    return null;
  }
}
